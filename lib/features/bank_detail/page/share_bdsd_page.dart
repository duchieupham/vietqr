import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/textfield_custom.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/blocs/share_bdsd_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/events/share_bdsd_event.dart';
import 'package:vierqr/features/bank_detail/states/share_bdsd_state.dart';
import 'package:vierqr/features/bank_detail/views/bottom_sheet_add_user_bdsd.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/info_tele_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import '../../../models/member_branch_model.dart';

class ShareBDSDScreen extends StatelessWidget {
  final String bankId;
  final AccountBankDetailDTO dto;
  final BankCardBloc bloc;

  const ShareBDSDScreen(
      {super.key, required this.bankId, required this.dto, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShareBDSDBloc>(
      create: (BuildContext context) => ShareBDSDBloc(context),
      child: _ShareBDSDScreen(
        bankId: bankId,
        dto: dto,
        bloc: bloc,
      ),
    );
  }
}

class _ShareBDSDScreen extends StatefulWidget {
  final String bankId;
  final AccountBankDetailDTO dto;
  final BankCardBloc bloc;

  const _ShareBDSDScreen(
      {required this.bankId, required this.dto, required this.bloc});

  @override
  State<_ShareBDSDScreen> createState() => _ShareBDSDScreenState();
}

class _ShareBDSDScreenState extends State<_ShareBDSDScreen> {
  late ShareBDSDBloc _bloc;

  String get userId => UserInformationHelper.instance.getUserId();

  List<MemberBranchModel> listMemberData = [];
  List<MemberBranchModel> listMember = [];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  initData() {
    _bloc.add(GetInfoTelegramEvent(bankId: widget.bankId, isLoading: true));
    _bloc.add(GetInfoLarkEvent(bankId: widget.bankId));
    _bloc.add(GetMemberEvent(bankId: widget.bankId));
  }

  Future<void> onRefresh() async {
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShareBDSDBloc, ShareBDSDState>(
      listener: (context, state) {
        if (state.status == BlocStatus.LOADING) {
          DialogWidget.instance.openLoadingDialog();
        }

        if (state.status == BlocStatus.UNLOADING) {
          Navigator.pop(context);
        }

        if (state.request == ShareBDSDType.MEMBER) {
          if (state.listMember.length >= 1) {
            listMember = state.listMember;
            listMember.removeWhere((member) => member.isOwner);
            listMemberData = listMember;
          }
        }

        if (state.request == ShareBDSDType.CONNECT) {
          widget.bloc.add(const BankCardGetDetailEvent());
          _bloc.add(GetBusinessAvailDTOEvent());
          Navigator.of(context).pop();
        }

        if (state.request == ShareBDSDType.DELETE_MEMBER) {
          print('-----------');

          _bloc.add(GetMemberEvent(bankId: widget.bankId));
        }
        if (state.request == ShareBDSDType.ADD_TELEGRAM ||
            state.request == ShareBDSDType.REMOVE_TELEGRAM) {
          _bloc.add(GetInfoTelegramEvent(bankId: widget.bankId));
        }

        if (state.request == ShareBDSDType.ADD_LARK ||
            state.request == ShareBDSDType.REMOVE_LARK) {
          _bloc.add(GetInfoLarkEvent(bankId: widget.bankId));
        }
      },
      builder: (context, state) {
        if (state.isLoading)
          return const UnconstrainedBox(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                color: AppColor.BLUE_TEXT,
              ),
            ),
          );
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Tài khoản chia sẻ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color:
                                      AppColor.BLACK_BUTTON.withOpacity(0.2)),
                              image: DecorationImage(
                                  image: ImageUtils.instance
                                      .getImageNetWork(widget.dto.imgId))),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.dto.bankCode} Bank - ${widget.dto.bankAccount}',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              '${widget.dto.userBankName}',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  if (widget.dto.userId ==
                      UserInformationHelper.instance.getUserId()) ...[
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'Chia sẻ qua mạng xã hội',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildSocialNetwork(context)
                  ],
                  // if (state.listTelegram.isEmpty && state.listLark.isEmpty)
                  //
                  // else
                  // Column(
                  //   children: [
                  //     ...[
                  //       if (state.listTelegram.isNotEmpty)
                  //         _buildListChatTelegram(
                  //             state.listTelegram, state.isTelegram)
                  //       else
                  //         GestureDetector(
                  //           onTap: () async {
                  //             await Navigator.pushNamed(
                  //                 context, Routes.CONNECT_TELEGRAM);
                  //             _bloc.add(GetInfoTelegramEvent());
                  //           },
                  //           child: _buildItemNetWork('Kết nối Telegram',
                  //               'assets/images/logo-telegram.png'),
                  //         )
                  //     ],
                  //     const SizedBox(height: 20),
                  //     ...[
                  //       if (state.listLark.isNotEmpty)
                  //         _buildListConnectLark(state.listLark, state.isLark)
                  //       else
                  //         GestureDetector(
                  //           onTap: () async {
                  //             await Navigator.pushNamed(
                  //                 context, Routes.CONNECT_LARK);
                  //             _bloc.add(GetInfoLarkEvent());
                  //           },
                  //           child: _buildItemNetWork('Kết nối Lark',
                  //               'assets/images/logo-lark.png'),
                  //         )
                  //     ]
                  //   ],
                  // ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Danh sách thành viên',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            const Text(
                              'Nhận thông tin Biến động số dư qua hệ thống VietQR VN',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      if (listMember.isNotEmpty)
                        Container(
                          padding: EdgeInsets.only(right: 8, left: 12),
                          decoration: BoxDecoration(
                              color: AppColor.BLUE_TEXT.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            children: [
                              Text(
                                '${listMember.length}',
                                style: TextStyle(color: AppColor.BLUE_TEXT),
                              ),
                              Image.asset(
                                'assets/images/ic-member-bdsd-blue.png',
                                height: 26,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  if (listMember.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Container(
                          height: 41,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: AppColor.BLACK_BUTTON.withOpacity(0.5),
                                  width: 0.5)),
                          child: TextFieldCustom(
                            isObscureText: false,
                            maxLines: 1,
                            fillColor: AppColor.WHITE,
                            // controller: searchController,
                            hintText: 'Tìm kiếm người dùng',
                            inputType: TextInputType.text,
                            prefixIcon: const Icon(Icons.search),
                            keyboardAction: TextInputAction.search,
                            onChange: (value) {
                              setState(() {
                                listMemberData = listMember
                                    .where((element) => element.fullName
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                              // _valueSearch = value;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ...listMemberData.map((e) {
                          return _buildItemMember(e);
                        }).toList(),
                        if (widget.dto.userId ==
                            UserInformationHelper.instance.getUserId())
                          Align(
                            alignment: Alignment.topRight,
                            child: ButtonWidget(
                              height: 32,
                              width: 140,
                              fontSize: 12,
                              text: 'Xóa tất cả thành viên',
                              textColor: AppColor.RED_TEXT,
                              bgColor: AppColor.RED_TEXT.withOpacity(0.2),
                              function: () {
                                _bloc.add(RemoveAllMemberEvent(
                                    bankId: widget.bankId));
                              },
                            ),
                          ),
                        const SizedBox(
                          height: 100,
                        )
                      ],
                    )
                  else
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 60,
                          ),
                          Image.asset(
                            'assets/images/ic-member-empty.png',
                            height: 100,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text('Chưa có thành viên nào được chia sẻ.'),
                        ],
                      ),
                    )
                ],
              ),
            ),
            if (widget.dto.userId == UserInformationHelper.instance.getUserId())
              Positioned(
                  bottom: 40,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      await DialogWidget.instance.showModelBottomSheet(
                        isDismissible: true,
                        height: MediaQuery.of(context).size.height * 0.8,
                        margin: EdgeInsets.only(
                            left: 10, right: 10, bottom: 10, top: 200),
                        borderRadius: BorderRadius.circular(16),
                        widget: BottomSheetAddUserBDSD(
                          bankId: widget.bankId,
                        ),
                      );
                      _bloc.add(GetMemberEvent(bankId: widget.bankId));
                    },
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColor.BLUE_TEXT,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/images/ic-add-member-bdsd-white.png',
                            height: 26,
                          ),
                          Text(
                            'Thêm thành viên',
                            style:
                                TextStyle(fontSize: 12, color: AppColor.WHITE),
                          )
                        ],
                      ),
                    ),
                  )),
          ],
        );
      },
    );
  }

  Widget _buildItemMember(MemberBranchModel dto) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          dto.imgId.isNotEmpty
              ? Container(
                  width: 32,
                  height: 32,
                  margin: EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: DecorationImage(
                        image: ImageUtils.instance.getImageNetWork(dto.imgId),
                        fit: BoxFit.cover),
                  ),
                )
              : Container(
                  width: 32,
                  height: 32,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dto.fullName,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                dto.phoneNo ?? '',
                style: TextStyle(fontSize: 12),
              )
            ],
          )),
          if (widget.dto.userId == UserInformationHelper.instance.getUserId())
            GestureDetector(
              onTap: () {
                _bloc.add(
                    RemoveMemberEvent(bankId: widget.bankId, userId: dto.id));
              },
              child: Image.asset(
                'assets/images/ic-remove-red.png',
                height: 36,
              ),
            )
        ],
      ),
    );
  }

  Widget _buildItemNetWork(String title, String url) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.WHITE,
      ),
      child: Row(
        children: [
          Image.asset(
            url,
            width: 32,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Image.asset(
            'assets/images/ic-next-user.png',
            width: 32,
          ),
        ],
      ),
    );
  }

  Widget _buildListConnectLark(List<InfoLarkDTO> list, bool isExist) {
    return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          InfoLarkDTO dto = list[index];
          return _buildItemChatLark(dto, context, isExist);
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 20);
        },
        itemCount: list.length);
  }

  Widget _buildListChatTelegram(List<InfoTeleDTO> list, bool isExist) {
    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return _buildItemChatTelegram(list[index], context, isExist);
        },
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(height: 20);
        },
        itemCount: list.length);
  }

  Widget _buildItemChatLark(
      InfoLarkDTO dto, BuildContext context, bool isExist) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.WHITE,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo-lark.png',
                      height: 28,
                      width: 28,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Webhook Address',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          dto.webhook,
                          maxLines: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const Divider(
                color: Colors.black,
                thickness: 0.2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, right: 12),
                child: Column(
                  children: dto.banks.map((bank) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                  width: 0.5, color: AppColor.GREY_TEXT),
                              image: DecorationImage(
                                image: ImageUtils.instance.getImageNetWork(
                                  bank.imageId,
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${bank.bankCode} - ${bank.bankAccount}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColor.BLACK,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                bank.userBankName.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColor.BLACK,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (widget.dto.id == bank.bankId &&
                              widget.dto.userId == userId)
                            GestureDetector(
                              onTap: () {
                                final Map<String, dynamic> body = {
                                  'id': dto.id,
                                  'userId': userId,
                                  'bankId': widget.dto.id,
                                };

                                _bloc.add(RemoveBankLarkEvent(body));
                              },
                              child: Image.asset(
                                'assets/images/ic-remove-red.png',
                                width: 36,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        if (!isExist && widget.dto.userId == userId && widget.dto.authenticated)
          MButtonWidget(
            title: 'Nhận BĐSD qua Lark',
            isEnable: true,
            colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.25),
            margin: EdgeInsets.symmetric(vertical: 10),
            colorEnableText: AppColor.BLUE_TEXT,
            onTap: () {
              final Map<String, dynamic> body = {
                'id': dto.id,
                'userId': userId,
                'bankId': widget.dto.id,
              };

              _bloc.add(AddBankLarkEvent(body));
            },
          )
      ],
    );
  }

  Widget _buildItemChatTelegram(
    InfoTeleDTO dto,
    BuildContext context,
    bool isExist,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.WHITE,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo-telegram.png',
                      height: 28,
                      width: 28,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Chat ID',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      dto.chatId,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const Divider(
                color: Colors.black,
                thickness: 0.2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, right: 12),
                child: Column(
                  children: dto.banks.map((bank) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.circular(40),
                              border: Border.all(
                                  width: 0.5, color: AppColor.GREY_TEXT),
                              image: DecorationImage(
                                image: ImageUtils.instance.getImageNetWork(
                                  bank.imageId,
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${bank.bankCode} - ${bank.bankAccount}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColor.BLACK,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                bank.userBankName.toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColor.BLACK,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (widget.dto.id == bank.bankId &&
                              widget.dto.userId == userId)
                            GestureDetector(
                              onTap: () {
                                final Map<String, dynamic> body = {
                                  'id': dto.id,
                                  'userId': userId,
                                  'bankId': widget.dto.id,
                                };

                                _bloc.add(RemoveBankTelegramEvent(body));
                              },
                              child: Image.asset(
                                'assets/images/ic-remove-red.png',
                                width: 36,
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        if (!isExist && widget.dto.userId == userId && widget.dto.authenticated)
          MButtonWidget(
            title: 'Nhận BĐSD qua Telegram',
            isEnable: true,
            colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.25),
            margin: EdgeInsets.symmetric(vertical: 10),
            colorEnableText: AppColor.BLUE_TEXT,
            onTap: () {
              final Map<String, dynamic> body = {
                'id': dto.id,
                'userId': userId,
                'bankId': widget.dto.id,
              };

              _bloc.add(AddBankTelegramEvent(body));
            },
          )
      ],
    );
  }

  Widget _buildSocialNetwork(BuildContext context) {
    return Wrap(
      runSpacing: 20,
      children: [
        _buildItemService(
            context, 'assets/images/logo-telegram-dash.png', 'Telegram',
            () async {
          Navigator.pushNamed(context, Routes.CONNECT_TELEGRAM);
        }),
        _buildItemService(context, 'assets/images/logo-lark-dash.png', 'Lark',
            () async {
          Navigator.pushNamed(context, Routes.CONNECT_LARK);
        }),
      ],
    );
  }

  Widget _buildItemService(
      BuildContext context, String pathIcon, String title, VoidCallback onTap) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: getDeviceType() == 'phone' ? width / 5 - 7 : 70,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              pathIcon,
              height: 45,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10),
            )
          ],
        ),
      ),
    );
  }

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }
}
