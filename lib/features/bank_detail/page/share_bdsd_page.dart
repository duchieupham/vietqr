import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/utils/user_information_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/blocs/share_bdsd_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/events/share_bdsd_event.dart';
import 'package:vierqr/features/bank_detail/states/share_bdsd_state.dart';
import 'package:vierqr/features/bank_detail/views/connect_business_view.dart';
import 'package:vierqr/features/branch/widgets/add_branch_member_widget.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_text_form_field.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/business_branch_dto.dart';
import 'package:vierqr/models/info_tele_dto.dart';
import 'package:vierqr/models/member_branch_model.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

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
    if (widget.dto.businessDetails.isEmpty) {
      _bloc.add(GetBusinessAvailDTOEvent());
    } else {
      String branchId = '';
      String businessId = widget.dto.businessDetails.first.businessId;

      if (widget.dto.businessDetails.first.branchDetails.isNotEmpty) {
        branchId =
            widget.dto.businessDetails.first.branchDetails.first.branchId;
      }
      _bloc.add(GetMemberEvent(branchId: branchId, businessId: businessId));
    }
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

        if (state.request == ShareBDSDType.Avail) {}

        if (state.request == ShareBDSDType.CONNECT) {
          widget.bloc.add(const BankCardGetDetailEvent());
          _bloc.add(GetBusinessAvailDTOEvent());
          Navigator.of(context).pop();
        }

        if (state.request == ShareBDSDType.DELETE_MEMBER) {
          _bloc.add(GetMemberEvent());
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
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            children: [
              if (widget.dto.businessDetails.isEmpty)
                _BuildNotConnectWidget(
                  list: state.listBusinessAvailDTO,
                  onCallBack: () {
                    _bloc.add(GetBusinessAvailDTOEvent());
                    Navigator.pop(context);
                  },
                  onConnect: (BusinessId, branchId) {
                    _bloc.add(
                      ConnectBranchEvent(
                        businessId: BusinessId,
                        branchId: branchId,
                        bankId: widget.bankId,
                      ),
                    );
                  },
                )
              else
                _BuildConnectWidget(
                  dto: widget.dto,
                  list: state.listMember,
                  isAdmin: widget.dto.userId == userId,
                  branchId: state.branchId ?? '',
                  businessId: state.businessId ?? '',
                  onCallBack: () {
                    widget.bloc.add(const BankCardGetDetailEvent());
                    _bloc.add(GetBusinessAvailDTOEvent());
                  },
                  onGetMember: () {
                    _bloc.add(GetMemberEvent());
                  },
                  onRemoveMember: (value) {
                    String businessId = '';
                    if (widget.dto.businessDetails.isNotEmpty) {
                      businessId = widget.dto.businessDetails.first.businessId;
                    }
                    _bloc.add(DeleteMemberEvent(
                        businessId: businessId, userId: value));
                  },
                ),
              const SizedBox(height: 30),
              const Text(
                'Chia sẻ qua mạng xã hội',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              if (state.listTelegram.isEmpty && state.listLark.isEmpty)
                _buildSocialNetwork(context)
              else
                Column(
                  children: [
                    ...[
                      if (state.listTelegram.isNotEmpty)
                        _buildListChatTelegram(
                            state.listTelegram, state.isTelegram)
                      else
                        GestureDetector(
                          onTap: () async {
                            await Navigator.pushNamed(
                                context, Routes.CONNECT_TELEGRAM);
                            _bloc.add(GetInfoTelegramEvent());
                          },
                          child: _buildItemNetWork('Kết nối Telegram',
                              'assets/images/logo-telegram.png'),
                        )
                    ],
                    const SizedBox(height: 20),
                    ...[
                      if (state.listLark.isNotEmpty)
                        _buildListConnectLark(state.listLark, state.isLark)
                      else
                        GestureDetector(
                          onTap: () async {
                            await Navigator.pushNamed(
                                context, Routes.CONNECT_LARK);
                            _bloc.add(GetInfoLarkEvent());
                          },
                          child: _buildItemNetWork(
                              'Kết nối Lark', 'assets/images/logo-lark.png'),
                        )
                    ]
                  ],
                ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
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

class _BuildNotConnectWidget extends StatelessWidget {
  final List<BusinessAvailDTO> list;
  final Function(String, String) onConnect;
  final VoidCallback onCallBack;

  const _BuildNotConnectWidget(
      {required this.list, required this.onConnect, required this.onCallBack});

  @override
  Widget build(BuildContext context) {
    return Container(child: _buildItemNotConnect(context));
  }

  _buildItemNotConnect(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
              'Kết nối doanh nghiệp và chia sẻ biến động số dư với mọi người. Để quản lý chi tiêu dễ hơn'),
          const SizedBox(height: 24),
          MButtonWidget(
            title: '',
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            isEnable: true,
            onTap: () async {
              await showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black45,
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (BuildContext buildContext, Animation animation,
                    Animation secondaryAnimation) {
                  return ConnectBusinessView(
                    list: list,
                    onConnect: onConnect,
                    onCallBack: onCallBack,
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/ic-next-user.png', width: 32),
                Expanded(
                  child: Center(
                    child: Text(
                      'Kết nối doanh nghiệp',
                      style: TextStyle(color: AppColor.WHITE),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/ic-next-user.png',
                  color: AppColor.WHITE,
                  width: 32,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildConnectWidget extends StatelessWidget {
  final AccountBankDetailDTO dto;
  final List<MemberBranchModel> list;
  final Function(String) onRemoveMember;
  final bool isAdmin;
  final String branchId;
  final String businessId;
  final VoidCallback onGetMember;
  final VoidCallback onCallBack;

  const _BuildConnectWidget({
    required this.dto,
    required this.list,
    required this.onRemoveMember,
    required this.isAdmin,
    required this.branchId,
    required this.businessId,
    required this.onGetMember,
    required this.onCallBack,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAdmin) ...[
          Text(
              'Tìm kiếm và thêm thành viên có thể nhận thông báo biến động số dư của bạn. Để quản lý chi tiêu dễ dàng hơn'),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              await DialogWidget.instance.showModelBottomSheet(
                context: context,
                height: height * 0.5,
                widget: AddBranchMemberWidget(
                  branchId: branchId,
                  businessId: businessId,
                ),
              );

              onGetMember();
            },
            child: MTextFieldCustom(
              hintText: 'Thêm thành viên bằng Số điện thoại',
              keyboardAction: TextInputAction.next,
              onChange: (value) {},
              enable: false,
              inputType: TextInputType.text,
              isObscureText: false,
              hintColor: AppColor.BLUE_TEXT,
              fontSize: 16,
              fillColor: AppColor.BLUE_TEXT.withOpacity(0.25),
              prefixIcon: Icon(
                Icons.search,
                color: AppColor.BLUE_TEXT,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (dto.businessDetails.isNotEmpty)
          ...List.generate(dto.businessDetails.length, (index) {
            BusinessDetails model = dto.businessDetails[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.BUSINESS_INFORMATION_VIEW,
                  arguments: {'heroId': model.businessId},
                ).then((value) {
                  onCallBack();
                });
              },
              child: _buildItemBusiness(model),
            );
          }).toList(),
        const SizedBox(height: 16),
        Text(
          'Danh sách thành viên',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        if (list.isNotEmpty) ...[
          ...List.generate(list.length, (index) {
            MemberBranchModel model = list[index];
            return _buildItemMember(
              model,
              onRemoveMember,
              isAdmin,
            );
          }).toList()
        ] else
          Center(
            child: Text(
              'Không có thành viên',
              style: TextStyle(fontSize: 16),
            ),
          ),
      ],
    );
  }

  Widget _buildItemBusiness(BusinessDetails model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.WHITE,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/ic-tb-business-selected.png',
            width: 32,
            color: AppColor.BLACK,
          ),
          Expanded(
            child: Text(
              model.businessName,
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

  Widget _buildItemMember(
    MemberBranchModel model,
    Function(String) onRemove,
    bool isAdmin,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColor.WHITE,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              'assets/images/ic-avatar.png',
              width: 36,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UserInformationUtils.instance
                      .formatFullName(model.firstName ?? '',
                          model.middleName ?? '', model.lastName ?? '')
                      .trim(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  StringUtils.instance.formatPhoneNumberVN(model.phoneNo ?? ''),
                  style: TextStyle(fontSize: 15, color: AppColor.GREY_TEXT),
                ),
              ],
            ),
          ),
          if (isAdmin)
            GestureDetector(
              onTap: () {
                onRemove(model.id ?? '');
              },
              child: Image.asset(
                'assets/images/ic-remove-red.png',
                width: 36,
              ),
            ),
        ],
      ),
    );
  }
}
