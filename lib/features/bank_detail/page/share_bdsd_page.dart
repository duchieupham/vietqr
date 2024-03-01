import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/blocs/share_bdsd_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/events/share_bdsd_event.dart';
import 'package:vierqr/features/bank_detail/states/share_bdsd_state.dart';
import 'package:vierqr/features/bank_detail/widget/detail_group.dart';
import 'package:vierqr/features/bank_detail/widget/share_bdsd_invite.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../../models/member_branch_model.dart';

class ShareBDSDPage extends StatelessWidget {
  final String bankId;
  final AccountBankDetailDTO dto;
  final BankCardBloc bloc;

  const ShareBDSDPage(
      {super.key, required this.bankId, required this.dto, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ShareBDSDBloc>(
      create: (BuildContext context) => ShareBDSDBloc(context),
      child: _ShareBDSDScreen(bankId: bankId, dto: dto, bloc: bloc),
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
  static String routeName = '/share_bdsd_invite';
  late ShareBDSDBloc _bloc;

  String get userId => SharePrefUtils.getProfile().userId;

  List<MemberBranchModel> listMemberData = [];
  final ScrollController controller = ScrollController();

  int offset = 0;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    controller.addListener(_loadMore);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });
  }

  initData() {
    _bloc.add(GetInfoTelegramEvent(bankId: widget.bankId, isLoading: true));
    _bloc.add(GetInfoLarkEvent(bankId: widget.bankId));
    _bloc.add(GetMyListGroupBDSDEvent(
        userID: userId, bankId: widget.bankId, offset: 0));
  }

  Future<void> onRefresh() async {
    initData();
  }

  void _loadMore() {
    final maxScroll = controller.position.maxScrollExtent;
    if (controller.offset >= maxScroll && !controller.position.outOfRange) {
      _bloc.add(GetListGroupBDSDEvent(
          userID: userId, offset: offset + 1, loadMore: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocConsumer<ShareBDSDBloc, ShareBDSDState>(
        listener: (context, state) {
          if (state.status == BlocStatus.LOADING) {
            DialogWidget.instance.openLoadingDialog();
          }

          if (state.status == BlocStatus.UNLOADING) {
            Navigator.pop(context);
          }

          if (state.request == ShareBDSDType.GET_LIST_GROUP) {
            setState(() {
              offset = state.offset;
            });
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
                  controller: controller,
                  children: [
                    const SizedBox(height: 16),
                    const Text('Tài khoản chia sẻ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.dto.bankCode} Bank - ${widget.dto.bankAccount}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  '${widget.dto.userBankName}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    if (widget.dto.userId == userId) ...[
                      const SizedBox(
                        height: 24,
                      ),
                      const Text(
                        'Chia sẻ qua mạng xã hội',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildSocialNetwork(context)
                    ],
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Danh sách cửa hàng',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (state.listGroup.totalTerminals > 0)
                          Container(
                            padding: EdgeInsets.only(right: 8, left: 12),
                            decoration: BoxDecoration(
                                color: AppColor.BLUE_TEXT.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              children: [
                                Text(
                                  '${state.listGroup.totalTerminals}',
                                  style: TextStyle(color: AppColor.BLUE_TEXT),
                                ),
                                Image.asset(
                                  'assets/images/ic-group-member-blue.png',
                                  height: 26,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    if (state.status == BlocStatus.LOADING_PAGE)
                      Container(
                        height: 250,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else ...[
                      if (state.listGroup.totalTerminals > 0)
                        Column(
                          children: [
                            const SizedBox(height: 12),
                            ...state.listGroup.terminals.map((e) {
                              return _buildItemGroup(e);
                            }).toList(),
                            if (state.isLoadMore)
                              Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        )
                      else if (state.isEmpty)
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
                              Text('Chưa có cửa hàng nào.'),
                            ],
                          ),
                        )
                    ]
                  ],
                ),
              ),
              if (widget.dto.userId == userId)
                Positioned(
                    bottom: 40,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        await NavigatorUtils.navigatePage(
                            context, ShareBDSDInviteScreen(),
                            routeName: _ShareBDSDScreenState.routeName);
                        _bloc.add(GetMyListGroupBDSDEvent(
                            userID: userId,
                            bankId: widget.bankId,
                            offset: 0,
                            isLoading: false));
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
                              'assets/images/ic-store-white.png',
                              height: 26,
                              color: Colors.white,
                            ),
                            Text(
                              'Thêm cửa hàng',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.WHITE),
                            )
                          ],
                        ),
                      ),
                    )),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItemGroup(TerminalResponseDTO dto) {
    return GestureDetector(
      onTap: () async {
        await NavigatorUtils.navigatePage(
            context, DetailGroupScreen(groupId: dto.id),
            routeName: _ShareBDSDScreenState.routeName);
        _bloc.add(GetMyListGroupBDSDEvent(
            userID: userId, bankId: widget.bankId, offset: 0));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            color: AppColor.WHITE, borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cửa hàng:',
                        style:
                            TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                      ),
                      Text(
                        dto.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thành viên:',
                      style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                    ),
                    Row(
                      children: [
                        Text(
                          dto.totalMembers.toString(),
                          style: TextStyle(fontSize: 15),
                        ),
                        Image.asset(
                          'assets/images/ic-member-black.png',
                          width: 24,
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(width: 60),
                Icon(
                  Icons.arrow_forward,
                  color: AppColor.BLUE_TEXT,
                  size: 18,
                )
              ],
            ),
            Text(
              'Tài khoản chia sẻ:',
              style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
            ),
            const SizedBox(
              height: 12,
            ),
            ...dto.banks.map((e) {
              return _buildShareBankItem(e);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildShareBankItem(TerminalBankResponseDTO dto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            height: 20,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border:
                    Border.all(color: AppColor.BLACK_BUTTON.withOpacity(0.2)),
                image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(dto.imgId))),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
              child: Text(
            '${dto.bankAccount} - ${dto.userBankName}',
            overflow: TextOverflow.ellipsis,
          ))
        ],
      ),
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
