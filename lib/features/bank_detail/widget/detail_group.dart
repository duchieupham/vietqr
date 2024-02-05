import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dashed_line.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/detail_group_bloc.dart';
import 'package:vierqr/features/bank_detail/states/detail_group_state.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_add_bank_bdsd.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_add_user_bdsd.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_detail_bank_terminal.dart';
import 'package:vierqr/features/bank_detail/widget/share_bdsd_invite.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/detail_group_dto.dart';

import '../../../commons/widgets/button_icon_widget.dart';
import '../../../models/terminal_response_dto.dart';
import '../../../services/shared_references/user_information_helper.dart';
import '../events/detail_group_event.dart';

class DetailGroupScreen extends StatefulWidget {
  final String groupId;

  const DetailGroupScreen({required this.groupId});

  @override
  State<DetailGroupScreen> createState() => _ShareBDSDInviteState();
}

class _ShareBDSDInviteState extends State<DetailGroupScreen> {
  late DetailGroupBloc _bloc;
  GroupDetailDTO detailDTO = GroupDetailDTO(banks: [], members: []);
  List<AccountMemberDTO> listMember = [];
  @override
  void initState() {
    super.initState();
    _bloc = DetailGroupBloc();
    _bloc.add(GetDetailGroup(id: widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(title: 'Nhóm'),
      body: BlocProvider<DetailGroupBloc>(
        create: (context) => _bloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<DetailGroupBloc, DetailGroupState>(
            listener: (context, state) {
              if (state is DetailGroupLoadingState) {
                DialogWidget.instance.openLoadingDialog();
              }
              if (state is DetailGroupSuccessState) {
                detailDTO = state.data;
              }
              if (state is RemoveMemberSuccessState ||
                  state is RemoveBankToGroupSuccessState) {
                Navigator.pop(context);

                _bloc.add(
                    GetDetailGroup(id: widget.groupId, loadingPage: false));
                Fluttertoast.showToast(
                  msg: 'Đã xóa',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Theme.of(context).hintColor,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255)',
                  webPosition: 'center',
                );
              }
              if (state is AddMemberSuccessState ||
                  state is AddBankToGroupSuccessState) {
                Navigator.pop(context);

                _bloc.add(
                    GetDetailGroup(id: widget.groupId, loadingPage: false));
                Fluttertoast.showToast(
                  msg: 'Đã thêm',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Theme.of(context).hintColor,
                  fontSize: 15,
                  webBgColor: 'rgba(255, 255, 255)',
                  webPosition: 'center',
                );
              }
              if (state is RemoveMemberFailedState ||
                  state is AddMemberFailedState ||
                  state is AddBankToGroupFailedState ||
                  state is RemoveBankToGroupFailedState) {
                Navigator.pop(context);
                DialogWidget.instance.openMsgDialog(
                    title: 'Không thành công',
                    msg: 'Đã có lỗi xảy ra vui lòng thử lại sau.');
              }
            },
            builder: (context, state) {
              if (state is DetailGroupLoadingPageState) {
                return const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: AppColor.BLUE_TEXT,
                    ),
                  ),
                );
              }

              return ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nhóm',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.GREY_TEXT),
                            ),
                            Text(
                              detailDTO.name,
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      if (detailDTO.userId == UserHelper.instance.getUserId())
                        ButtonIconWidget(
                            height: 36,
                            borderRadius: 5,
                            iconSize: 28,
                            contentPadding: EdgeInsets.only(right: 16, left: 8),
                            pathIcon: 'assets/images/ic-edit-white.png',
                            title: 'Cập nhật',
                            textSize: 12,
                            function: () async {
                              await NavigatorUtils.navigatePage(
                                  context,
                                  ShareBDSDInviteScreen(
                                    terminalId: detailDTO.id,
                                    isUpdate: true,
                                    groupDetailDTO: detailDTO,
                                  ),
                                  routeName: 'detail_group');
                              _bloc.add(GetDetailGroup(
                                  id: widget.groupId, loadingPage: false));
                            },
                            bgColor: AppColor.BLUE_TEXT,
                            textColor: AppColor.WHITE)
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Thông tin nhóm',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppColor.WHITE),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mã nhóm:',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColor.GREY_TEXT),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  detailDTO.code,
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                FlutterClipboard.copy(detailDTO.code).then(
                                  (value) => Fluttertoast.showToast(
                                    msg: 'Đã sao chép',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    textColor: Theme.of(context).hintColor,
                                    fontSize: 15,
                                    webBgColor: 'rgba(255, 255, 255, 0.5)',
                                    webPosition: 'center',
                                  ),
                                );
                              },
                              child: Image.asset(
                                'assets/images/ic_copy.png',
                                width: 32,
                              ),
                            )
                          ],
                        ),
                        if (detailDTO.address.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Divider(
                              color: AppColor.BLACK_LIGHT.withOpacity(0.5),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Địa chỉ:',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.GREY_TEXT),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    detailDTO.address,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  FlutterClipboard.copy(detailDTO.address).then(
                                    (value) => Fluttertoast.showToast(
                                      msg: 'Đã sao chép',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      textColor: Theme.of(context).hintColor,
                                      fontSize: 15,
                                      webBgColor: 'rgba(255, 255, 255, 0.5)',
                                      webPosition: 'center',
                                    ),
                                  );
                                },
                                child: Image.asset(
                                  'assets/images/ic_copy.png',
                                  width: 32,
                                ),
                              )
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                  _buildBankShare(),
                  _buildListMember(),
                  // _addBankAccount(),
                  // _addUser(),

                  const SizedBox(
                    height: 40,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBankShare() {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Text(
              'Tài khoản chia sẻ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (detailDTO.userId == UserHelper.instance.getUserId())
              ButtonIconWidget(
                  height: 36,
                  borderRadius: 5,
                  textSize: 12,
                  iconSize: 28,
                  contentPadding: EdgeInsets.only(right: 16, left: 8),
                  pathIcon: 'assets/images/ic-add-card-white.png',
                  iconPathColor: AppColor.WHITE,
                  title: 'Thêm TK',
                  function: () async {
                    await DialogWidget.instance.showModelBottomSheet(
                      isDismissible: true,
                      padding: EdgeInsets.only(left: 12, right: 12, bottom: 32),
                      height: MediaQuery.of(context).size.height * 0.8,
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      borderRadius: BorderRadius.circular(16),
                      widget: BottomSheetAddBankBDSD(
                        terminalId: detailDTO.id,
                        onSelect: (bankAccount) async {
                          Map<String, dynamic> param = {};
                          param['terminalId'] = detailDTO.id;
                          param['bankId'] = bankAccount.bankId;
                          param['userId'] = UserHelper.instance.getUserId();
                          _bloc.add(AddBankToGroup(param: param));
                          // bool existed = false;
                          // await Future.forEach(detailDTO.banks,
                          //     (TerminalBankResponseDTO bank) async {
                          //   if (bank.bankAccount == bankAccount.bankAccount) {
                          //     existed = true;
                          //     DialogWidget.instance.openMsgDialog(
                          //         title: 'Thêm tài khoản',
                          //         msg: 'Tài khoản ngân hàng này đã được thêm');
                          //   }
                          // });
                          //
                          // if (!existed) {}
                        },
                      ),
                    );
                  },
                  bgColor: AppColor.BLUE_TEXT,
                  textColor: AppColor.WHITE)
          ],
        ),
        ...detailDTO.banks.map((e) {
          return _buildItemBank(e);
        }).toList()
      ],
    );
  }

  Widget _buildListMember() {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Text(
              'Thành viên',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              margin: EdgeInsets.only(left: 12),
              padding: EdgeInsets.only(left: 12, right: 4),
              decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  Text(
                    detailDTO.totalMember.toString(),
                    style: TextStyle(color: AppColor.BLUE_TEXT),
                  ),
                  Image.asset(
                    'assets/images/ic-member-bdsd-blue.png',
                    height: 24,
                  )
                ],
              ),
            ),
            const Spacer(),
            if (detailDTO.userId == UserHelper.instance.getUserId())
              ButtonIconWidget(
                  height: 36,
                  borderRadius: 5,
                  textSize: 12,
                  iconSize: 26,
                  contentPadding: EdgeInsets.only(right: 16, left: 8),
                  pathIcon: 'assets/images/ic-add-member-white.png',
                  title: 'Thành viên mới',
                  function: () async {
                    await DialogWidget.instance.showModelBottomSheet(
                      isDismissible: true,
                      height: MediaQuery.of(context).size.height * 0.7,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 200),
                      borderRadius: BorderRadius.circular(16),
                      widget: BottomSheetAddUserBDSD(
                        terminalId: detailDTO.id,
                        onSelect: (dto) {
                          Map<String, dynamic> param = {};
                          param['userId'] = dto.id;
                          param['terminalId'] = detailDTO.id;
                          _bloc.add(AddMemberGroup(param: param));
                          // provider.addListMember(dto);
                        },
                      ),
                    );
                  },
                  bgColor: AppColor.BLUE_TEXT,
                  textColor: AppColor.WHITE)
          ],
        ),
        ...detailDTO.members.map((e) {
          return _buildItemMember(e);
        }).toList()
      ],
    );
  }

  Widget _buildItemBank(TerminalBankResponseDTO dto) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const SizedBox(
            width: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Image(
              image: ImageUtils.instance.getImageNetWork(dto.imgId),
              width: 60,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          SizedBox(height: 50, child: VerticalDashedLine()),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dto.bankAccount,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                dto.userBankName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12),
              )
            ],
          )),
          const SizedBox(width: 16,),
          GestureDetector(
            onTap: () async {
              await DialogWidget.instance.showModelBottomSheet(
                isDismissible: true,
                margin:
                    EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 40),
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(16),
                widget: BottomSheetDetailBankBDSD(
                  dto: dto,
                  onDelete: (bankId) {
                    Map<String, dynamic> param = {};
                    param['userId'] = UserHelper.instance.getUserId();
                    param['terminalId'] = detailDTO.id;
                    param['bankId'] = bankId;
                    _bloc.add(RemoveBankToGroup(param: param));
                    // provider.addListMember(dto);
                  },
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColor.BLUE_TEXT)),
              child: Icon(
                Icons.more_horiz,
                size: 18,
                color: AppColor.BLUE_TEXT,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemMember(AccountMemberDTO dto) {
    return GestureDetector(
      child: Container(
        height: 54,
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: AppColor.WHITE, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            dto.imgId.isNotEmpty
                ? Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                          image: ImageUtils.instance.getImageNetWork(dto.imgId),
                          fit: BoxFit.cover),
                    ),
                  )
                : Container(
                    width: 30,
                    height: 30,
                    margin: EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                          image: AssetImage('assets/images/ic-avatar.png')),
                    ),
                  ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dto.fullName(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  dto.phoneNo ?? '',
                  style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                )
              ],
            )),
            dto.isOwner
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    margin: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                        color: AppColor.BLUE_TEXT.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text(
                      'Admin',
                      style: TextStyle(fontSize: 12, color: AppColor.BLUE_TEXT),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      _bloc.add(RemoveMemberGroup(
                          userId: dto.id, terminalId: widget.groupId));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        Icons.remove_circle_outline,
                        size: 18,
                        color: AppColor.RED_TEXT,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
