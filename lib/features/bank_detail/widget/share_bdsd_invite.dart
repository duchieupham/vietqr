import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/invite_bdsd_bloc.dart';
import 'package:vierqr/features/bank_detail/events/invite_bdsd_event.dart';
import 'package:vierqr/features/bank_detail/provider/share_bdsd_invite_provider.dart';
import 'package:vierqr/features/bank_detail/states/invite_bdsd_state.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_add_bank_bdsd.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_add_user_bdsd.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/detail_group_dto.dart';
import 'package:vierqr/models/member_branch_model.dart';
import 'package:vierqr/models/member_search_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import '../../../commons/widgets/button_icon_widget.dart';

class ShareBDSDInviteScreen extends StatefulWidget {
  final String bankId;
  final bool isUpdate;
  final GroupDetailDTO? groupDetailDTO;
  const ShareBDSDInviteScreen(
      {required this.bankId, this.isUpdate = false, this.groupDetailDTO});

  @override
  State<ShareBDSDInviteScreen> createState() => _ShareBDSDInviteState();
}

class _ShareBDSDInviteState extends State<ShareBDSDInviteScreen> {
  late InviteBDSDBloc _bloc;

  String get userId => UserHelper.instance.getUserId();

  List<MemberBranchModel> listMemberData = [];
  List<MemberBranchModel> listMember = [];
  TextEditingController ranDomCodeController = TextEditingController();
  TextEditingController nameGroupController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = InviteBDSDBloc();
    if (widget.isUpdate) {
      ranDomCodeController.text = widget.groupDetailDTO?.code ?? '';
      addressController.text = widget.groupDetailDTO?.address ?? '';
      nameGroupController.text = widget.groupDetailDTO?.name ?? '';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  initData() {
    // _bloc.add(GetInfoTelegramEvent(bankId: widget.bankId, isLoading: true));
    // _bloc.add(GetInfoLarkEvent(bankId: widget.bankId));
    // _bloc.add(GetMemberEvent(bankId: widget.bankId));
  }

  Future<void> onRefresh() async {
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(title: 'Chia sẻ BDSD'),
      body: ChangeNotifierProvider<ShareBDSDInviteProvider>(
        create: (context) => ShareBDSDInviteProvider(),
        child: BlocProvider<InviteBDSDBloc>(
          create: (context) => _bloc,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocConsumer<InviteBDSDBloc, InviteBDSDState>(
              listener: (context, state) {
                if (state is InviteBDSDLoadingState) {
                  DialogWidget.instance.openLoadingDialog();
                }
                if (state is InviteBDSDGetRandomCodeSuccessState) {
                  Navigator.pop(context);
                  Provider.of<ShareBDSDInviteProvider>(context, listen: false)
                      .updateRandomCode(state.data);
                  setState(() {
                    ranDomCodeController.text = state.data;
                  });
                }
                if (state is InviteBDSDGetRandomCodeFailedState) {
                  Navigator.pop(context);
                  DialogWidget.instance.openMsgDialog(
                      title: 'Lỗi',
                      msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau');
                }

                if (state is RemoveGroupSuccessState) {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: 'Đã xóa',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Theme.of(context).cardColor,
                    textColor: Theme.of(context).hintColor,
                    fontSize: 15,
                  );
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  }
                }
                if (state is UpdateGroupSuccessState) {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: 'Cập nhật thành công',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Theme.of(context).cardColor,
                    textColor: Theme.of(context).hintColor,
                    fontSize: 15,
                  );
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                }
                if (state is CreateNewGroupSuccessState) {
                  Navigator.pop(context);
                  Fluttertoast.showToast(
                    msg: 'Tạo group thành công',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Theme.of(context).cardColor,
                    textColor: Theme.of(context).hintColor,
                    fontSize: 15,
                  );
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                }

                if (state is CreateNewGroupFailedState ||
                    state is UpdateGroupFailedState ||
                    state is RemoveGroupFailedState) {
                  Navigator.pop(context);
                  DialogWidget.instance.openMsgDialog(
                      title: 'Lỗi',
                      msg: 'Đã có lỗi xảy ra, vui lòng thử lại sau');
                }
              },
              builder: (context, state) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Thông tin nhóm',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text(
                            'Tên nhóm*',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text('Tên nhóm tối đa 50 ký tự',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.GREY_TEXT,
                              )),
                          Consumer<ShareBDSDInviteProvider>(
                              builder: (context, provider, _) {
                            return Container(
                              margin: EdgeInsets.only(top: 12),
                              padding: EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                  color: AppColor.WHITE,
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextField(
                                controller: nameGroupController,
                                onChanged: provider.updateNamGroup,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(50),
                                ],
                                decoration: InputDecoration(
                                    hintText: 'Nhập tên nhóm',
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 12),
                                    hintStyle: TextStyle(
                                        color: AppColor.GREY_TEXT,
                                        fontSize: 13)),
                              ),
                            );
                          }),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Mã nhóm',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                              'Mã nhóm tối đa 10 ký tự. Có thể tự nhập hoặc gắn giá trị ngẫu nhiên.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.GREY_TEXT,
                              )),
                          Row(
                            children: [
                              Expanded(
                                child: Consumer<ShareBDSDInviteProvider>(
                                    builder: (context, provider, _) {
                                  return Container(
                                    margin: EdgeInsets.only(top: 12),
                                    padding: EdgeInsets.only(left: 8),
                                    decoration: BoxDecoration(
                                        color: AppColor.WHITE,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: TextField(
                                      controller: ranDomCodeController,
                                      onChanged: provider.updateRandomCode,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      decoration: InputDecoration(
                                          hintText: 'Nhập mã nhóm',
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12),
                                          hintStyle: TextStyle(
                                              color: AppColor.GREY_TEXT,
                                              fontSize: 13)),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: ButtonWidget(
                                    height: 46,
                                    borderRadius: 5,
                                    fontSize: 12,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    text: 'Tạo ngẫu nhiên',
                                    textColor: AppColor.BLUE_TEXT,
                                    bgColor:
                                        AppColor.BLUE_TEXT.withOpacity(0.3),
                                    function: () {
                                      FocusScope.of(context).unfocus();
                                      _bloc.add(GetRanDomCode());
                                    }),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Địa chỉ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            padding: EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                                color: AppColor.WHITE,
                                borderRadius: BorderRadius.circular(5)),
                            child: TextField(
                              controller: addressController,
                              decoration: InputDecoration(
                                  hintText: 'Nhập địa chỉ',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 12),
                                  hintStyle: TextStyle(
                                      color: AppColor.GREY_TEXT, fontSize: 13)),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          if (widget.isUpdate) ...[
                            Text(
                              'Cài đặt',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            GestureDetector(
                              onTap: () {
                                Map<String, dynamic> param = {};
                                param['userId'] =
                                    UserHelper.instance.getUserId();
                                param['terminalId'] =
                                    widget.groupDetailDTO?.id ?? '';
                                _bloc.add(RemoveGroup(param: param));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: AppColor.WHITE),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/ic-trash.png',
                                      height: 26,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Xóa nhóm'),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Hủy chia sẻ biến động số dư với những thành viên trong nhóm.',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: AppColor.GREY_TEXT),
                                        )
                                      ],
                                    ))
                                  ],
                                ),
                              ),
                            )
                          ] else ...[
                            _addBankAccount(),
                            _addUser(),
                          ]
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 16),
                      child: Consumer<ShareBDSDInviteProvider>(
                          builder: (context, provider, _) {
                        if (widget.isUpdate) {
                          return ButtonWidget(
                              borderRadius: 5,
                              text: 'Cập nhật',
                              textColor: AppColor.WHITE,
                              bgColor: AppColor.BLUE_TEXT,
                              function: () {
                                Map<String, dynamic> param = {};
                                param['address'] = addressController.text;
                                param['name'] = nameGroupController.text;
                                param['code'] = ranDomCodeController.text;

                                param['id'] = widget.groupDetailDTO?.id ?? '';
                                print('-----------------------------$param ');
                                _bloc.add(UpdateGroup(param: param));
                              });
                        }

                        return ButtonWidget(
                            borderRadius: 5,
                            text: 'Tạo',
                            textColor: provider.validateFormIV
                                ? AppColor.WHITE
                                : AppColor.GREY_TEXT,
                            bgColor: provider.validateFormIV
                                ? AppColor.BLUE_TEXT
                                : AppColor.GREY_BUTTON,
                            function: () {
                              Map<String, dynamic> param = {};
                              param['address'] = addressController.text;
                              param['name'] = nameGroupController.text;
                              param['code'] = ranDomCodeController.text;
                              param['bankIds'] = provider.bankIDs;
                              param['userIds'] = provider.userIDS;
                              param['userId'] = UserHelper.instance.getUserId();
                              print('-----------------------------$param ');
                              _bloc.add(CreateNewGroup(param: param));
                            });
                      }),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _addUser() {
    return Consumer<ShareBDSDInviteProvider>(builder: (context, provider, _) {
      return Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thành viên*',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Thêm thành viên để nhận chia sẻ biến động số dư.',
                    style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                  )
                ],
              )),
              ButtonIconWidget(
                borderRadius: 5,
                height: 36,
                title: 'Thành viên mới',
                function: () async {
                  FocusScope.of(context).unfocus();
                  await DialogWidget.instance.showModelBottomSheet(
                    isDismissible: true,
                    height: MediaQuery.of(context).size.height * 0.7,
                    margin: EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 200),
                    borderRadius: BorderRadius.circular(16),
                    widget: BottomSheetAddUserBDSD(
                      bankId: widget.bankId,
                      onSelect: (dto) {
                        provider.addListMember(dto);
                      },
                    ),
                  );
                  // _bloc.add(GetMemberEvent(bankId: widget.bankId));
                },
                textSize: 11,
                contentPadding: EdgeInsets.only(left: 4, right: 12),
                bgColor: AppColor.BLUE_TEXT,
                textColor: AppColor.WHITE,
                pathIcon: 'assets/images/ic-add-member-white.png',
              )
            ],
          ),
          if (provider.member.isNotEmpty) ...[
            const SizedBox(
              height: 4,
            ),
            _buildItemAdmin(),
            ...provider.member.map((e) {
              return _buildItemMember(e, (userId) {
                provider.removeByUserId(userId);
              });
            }).toList(),
          ]
        ],
      );
    });
  }

  Widget _addBankAccount() {
    return Consumer<ShareBDSDInviteProvider>(builder: (context, provider, _) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tài khoản chia sẻ BĐSD*',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Thêm tài khoản để chia sẻ biến động số dư.',
                    style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                  )
                ],
              )),
              ButtonIconWidget(
                borderRadius: 5,
                height: 36,
                title: 'Thêm TK',
                function: () async {
                  FocusScope.of(context).unfocus();
                  await DialogWidget.instance.showModelBottomSheet(
                    isDismissible: true,
                    padding: EdgeInsets.only(left: 12, right: 12, bottom: 32),
                    height: MediaQuery.of(context).size.height * 0.8,
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    borderRadius: BorderRadius.circular(16),
                    widget: BottomSheetAddBankBDSD(
                      onSelect: (bankAccount) async {
                        if (provider.bankAccounts.isNotEmpty) {
                          bool existed = false;
                          await Future.forEach(provider.bankAccounts,
                              (BankAccountDTO bank) async {
                            if (bank.id == bankAccount.id) {
                              existed = true;
                              DialogWidget.instance.openMsgDialog(
                                  title: 'Thêm tài khoản',
                                  msg: 'Tài khoản ngân hàng này đã được thêm');
                            }
                          });
                          if (!existed) {
                            provider.addListBankAccount(bankAccount);
                            // final Map<String, dynamic> body = {
                            //   'id': dto.id,
                            //   'userId': UserInformationHelper.instance.getUserId(),
                            //   'bankId': bankAccount.id,
                            // };
                            //
                            // BlocProvider.of<ConnectLarkBloc>(context)
                            //     .add(AddBankLarkEvent(body));
                          }
                        } else {
                          provider.addListBankAccount(bankAccount);
                        }
                      },
                    ),
                  );
                },
                textSize: 11,
                contentPadding: EdgeInsets.only(left: 8, right: 12),
                bgColor: AppColor.BLUE_TEXT,
                textColor: AppColor.WHITE,
                pathIcon: 'assets/images/ic-add-card-white.png',
              )
            ],
          ),
          if (provider.bankAccounts.isNotEmpty) ...[
            const SizedBox(
              height: 4,
            ),
            ...provider.bankAccounts.map((e) {
              return _buildItemBank(e, (bankId) {
                provider.removeByBankID(bankId);
              });
            }).toList(),
          ]
        ],
      );
    });
  }

  Widget _buildItemBank(BankAccountDTO dto, Function(String) remove) {
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
            width: 4,
          ),
          Container(
            width: 1,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: AppColor.GREY_TEXT.withOpacity(0.2),
            ),
          ),
          const SizedBox(
            width: 12,
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
                style: TextStyle(fontSize: 12),
              )
            ],
          )),
          GestureDetector(
            onTap: () {
              remove(dto.id);
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
    );
  }

  Widget _buildItemMember(MemberSearchDto dto, Function(String) remove) {
    return Container(
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
                dto.fullName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                dto.phoneNo ?? '',
                style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
              )
            ],
          )),
          GestureDetector(
            onTap: () {
              remove(dto.id ?? '');
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
    );
  }

  Widget _buildItemAdmin() {
    return Container(
      height: 54,
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          const SizedBox(
            width: 12,
          ),
          UserHelper.instance.getAccountInformation().imgId.isNotEmpty
              ? Container(
                  width: 30,
                  height: 30,
                  margin: EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: ImageUtils.instance.getImageNetWork(
                            UserHelper.instance.getAccountInformation().imgId),
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
                UserHelper.instance.getUserFullName(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                UserHelper.instance.getPhoneNo(),
                style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
              )
            ],
          )),
          Container(
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
        ],
      ),
    );
  }
}
