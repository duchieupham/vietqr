import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/share_bdsd_bloc.dart';
import 'package:vierqr/features/bank_detail/states/share_bdsd_state.dart';
import 'package:vierqr/features/create_store/create_store_screen.dart';
import 'package:vierqr/features/detail_store/detail_store_screen.dart';
import 'package:vierqr/features/share_bdsd/provider/share_bdsd_provider.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../../models/terminal_response_dto.dart';
import '../bank_detail/events/share_bdsd_event.dart';

class ShareBDSDScreen extends StatefulWidget {
  const ShareBDSDScreen({super.key});

  @override
  State<ShareBDSDScreen> createState() => _ShareBDSDInviteState();
}

class _ShareBDSDInviteState extends State<ShareBDSDScreen> {
  late ShareBDSDBloc _bloc;
  late ShareBDSDProvider provider;
  TerminalDto terminalDto = TerminalDto(terminals: []);
  BankTerminalDto bankTerminalDto = BankTerminalDto(bankShares: []);
  final ScrollController controller = ScrollController();

  String get userId => SharePrefUtils.getProfile().userId;

  @override
  void initState() {
    super.initState();
    _bloc = ShareBDSDBloc(context);
    provider = ShareBDSDProvider();
    _bloc.add(GetTerminalsBDSDScreenEvent(
        userID: userId, type: 0, offset: 0, loadingPage: true));
    controller.addListener(_loadMore);
  }

  Future<void> onRefresh(ShareBDSDProvider provider) async {
    int type = provider.getTypeFilter();
    provider.updateOffset(0);
    _bloc.add(GetTerminalsBDSDScreenEvent(
        userID: userId, type: type, offset: 0, loadingPage: true));
  }

  _loadMore() async {
    int type = provider.getTypeFilter();
    int offset = provider.offset + 1;

    final maxScroll = controller.position.maxScrollExtent;
    if (controller.offset >= maxScroll && !controller.position.outOfRange) {
      _bloc.add(FetchShareBDSDScreenEvent(
          userID: userId, type: type, offset: offset));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(title: 'Chia sẻ BĐSD'),
      body: BlocProvider<ShareBDSDBloc>(
        create: (context) => _bloc,
        child: ChangeNotifierProvider<ShareBDSDProvider>(
          create: (context) => provider,
          child: Padding(
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
                  provider.updateOffset(state.offset);
                  terminalDto = state.listTerminal;

                  if (state.bankShareTerminal != null) {
                    bankTerminalDto = state.bankShareTerminal!;
                  }
                }
              },
              builder: (context, state) {
                return Consumer<ShareBDSDProvider>(
                    builder: (context, provider, child) {
                  return Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          await onRefresh(provider);
                        },
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            _buildTitlePage(provider),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sắp xếp theo',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 12),
                                    padding:
                                        EdgeInsets.only(left: 16, right: 12),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: AppColor.WHITE,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: DropdownButton<String>(
                                            value: provider.titleFilter,
                                            icon: const RotatedBox(
                                              quarterTurns: 5,
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 12,
                                                color: AppColor.WHITE,
                                              ),
                                            ),
                                            underline: const SizedBox.shrink(),
                                            onChanged: (String? value) {
                                              provider.updateTypeFilter(value ??
                                                  provider.titleFilter);
                                              onRefresh(provider);
                                            },
                                            items: provider.filterTitles
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 4),
                                                  child: Text(
                                                    value,
                                                    style: const TextStyle(
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                        const RotatedBox(
                                          quarterTurns: 5,
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Divider(
                                color: AppColor.GREY_TEXT,
                              ),
                            ),
                            Expanded(
                              child: state.status == BlocStatus.LOADING_PAGE
                                  ? const Center(
                                      child: SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: CircularProgressIndicator(
                                          color: AppColor.BLUE_TEXT,
                                        ),
                                      ),
                                    )
                                  : ListView(
                                      controller: controller,
                                      children: [
                                        if (provider.typeFilter == 0)
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Danh sách cửa hàng',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    right: 8, left: 12),
                                                decoration: BoxDecoration(
                                                    color: AppColor.BLUE_TEXT
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '${terminalDto.totalTerminals}',
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .BLUE_TEXT,
                                                          fontSize: 12),
                                                    ),
                                                    Image.asset(
                                                      'assets/images/ic-group-member-blue.png',
                                                      height: 28,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        else
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Danh sách tài khoản',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    right: 8, left: 12),
                                                decoration: BoxDecoration(
                                                    color: AppColor.BLUE_TEXT
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '${bankTerminalDto.totalBankShares}',
                                                      style: TextStyle(
                                                          color: AppColor
                                                              .BLUE_TEXT,
                                                          fontSize: 12),
                                                    ),
                                                    Image.asset(
                                                      'assets/images/ic-card-counting-blue.png',
                                                      height: 28,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        _buildList(provider),
                                        if (state.isLoadMore)
                                          Center(
                                            child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator()),
                                          )
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 40,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              await NavigatorUtils.navigatePage(
                                  context, CreateStoreScreen(),
                                  routeName: CreateStoreScreen.routeName);
                              _bloc.add(GetTerminalsBDSDScreenEvent(
                                  userID: SharePrefUtils.getProfile().userId,
                                  type: provider.getTypeFilter(),
                                  offset: 0,
                                  loadingPage: false));
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
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(ShareBDSDProvider provider) {
    if (provider.typeFilter == 0) {
      if (terminalDto.totalTerminals > 0) {
        return Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            ...terminalDto.terminals.map((e) {
              return _buildItemGroup(e, provider.getTypeFilter());
            }).toList(),
          ],
        );
      } else {
        return Center(
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
              Text('Chưa có nhóm nào.'),
            ],
          ),
        );
      }
    } else {
      if (bankTerminalDto.totalBankShares > 0) {
        return Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            ...bankTerminalDto.bankShares.map((e) {
              return _buildItemBank(e);
            }).toList(),
          ],
        );
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
              ),
              Image.asset(
                'assets/images/ic-add-bank.png',
                height: 100,
              ),
              const SizedBox(
                height: 12,
              ),
              Text('Chưa có nhóm tài khoản ngân hàng nào.'),
            ],
          ),
        );
      }
    }
  }

  Widget _buildTitlePage(ShareBDSDProvider provider) {
    return Center(
      child: UnconstrainedBox(
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColor.BLUE_TEXT)),
          child: Row(
            children: [
              _buildItemTab('Đã chia sẻ', provider.typeList == 0, () {
                provider.updateTypeList(0);
                onRefresh(provider);
              }),
              _buildItemTab('Chia sẻ với tôi', provider.typeList == 1, () {
                provider.updateTypeList(1);
                onRefresh(provider);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemTab(String title, bool isSelect, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelect
              ? AppColor.BLUE_TEXT.withOpacity(0.3)
              : AppColor.TRANSPARENT,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelect ? AppColor.BLUE_TEXT : AppColor.BLACK,
          ),
        ),
      ),
    );
  }

  Widget _buildItemGroup(TerminalResponseDTO dto, int type) {
    return GestureDetector(
      onTap: () async {
        await NavigatorUtils.navigatePage(
            context,
            DetailStoreScreen(
              terminalCode: dto.code,
              terminalId: dto.id,
              terminalName: dto.name,
            ),
            routeName: DetailStoreScreen.routeName);
        _bloc.add(
          GetTerminalsBDSDScreenEvent(
              userID: SharePrefUtils.getProfile().userId,
              type: type,
              offset: 0,
              loadingPage: true),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            color: AppColor.WHITE, borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 4,
            ),
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
                GestureDetector(
                  onTap: () => _onDetailStore(dto.id, dto.code, dto.name),
                  child: Icon(
                    Icons.arrow_forward,
                    color: AppColor.BLUE_TEXT,
                    size: 18,
                  ),
                )
              ],
            ),
            Text(
              'Tài khoản chia sẻ:',
              style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
            ),
            const SizedBox(height: 4),
            ...dto.banks.map((e) {
              return _buildShareBankItem(e);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemBank(BankShareResponseDTO dto) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 4,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tài khoản chia sẻ:',
                style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                            color: AppColor.BLACK_BUTTON.withOpacity(0.2)),
                        image: DecorationImage(
                            image: ImageUtils.instance
                                .getImageNetWork(dto.imgId))),
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
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Cửa hàng:',
            style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
          ),
          ...dto.terminals.map((e) {
            return _buildTerminalBank(e, e.id != dto.terminals.last.id);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTerminalBank(TerminalShareDTO dto, bool showBorder) {
    return GestureDetector(
      onTap: () => _onDetailStore(dto.id, dto.terminalCode, dto.terminalName),
      child: Container(
        padding: EdgeInsets.only(bottom: 12, top: 12),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: showBorder ? AppColor.GREY_BORDER : AppColor.WHITE,
                    width: 0.5))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                dto.terminalName,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15),
              ),
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
            ),
            SizedBox(
              width: 12,
            ),
            GestureDetector(
              onTap: () =>
                  _onDetailStore(dto.id, dto.terminalCode, dto.terminalName),
              child: Icon(
                Icons.arrow_forward,
                color: AppColor.BLUE_TEXT,
                size: 18,
              ),
            )
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

  void _onDetailStore(String id, String code, String name) async {
    await NavigatorUtils.navigatePage(
        context,
        DetailStoreScreen(
          terminalCode: code,
          terminalId: id,
          terminalName: name,
        ),
        routeName: DetailStoreScreen.routeName);
    _bloc.add(GetTerminalsBDSDScreenEvent(
        userID: SharePrefUtils.getProfile().userId,
        type: 0,
        offset: 0,
        loadingPage: true));
  }
}
