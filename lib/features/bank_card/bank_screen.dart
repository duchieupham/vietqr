import 'dart:async';
import 'dart:math' as math;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/qr_scanner_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_card/widgets/function_bank_widget.dart';
import 'package:vierqr/features/bank_detail/bank_card_detail_screen.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/create_qr/create_qr_screen.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_provider.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/auth_provider.dart';
import 'package:vierqr/services/providers/bank_card_select_provider.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import 'views/share_bdsd_view.dart';

class BankScreen extends StatelessWidget {
  const BankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BankBloc>(
      create: (BuildContext context) => BankBloc(context),
      child: ChangeNotifierProvider(
        create: (context) => BankCardSelectProvider(),
        child: const _BankScreen(),
      ),
    );
  }
}

class _BankScreen extends StatefulWidget {
  const _BankScreen();

  @override
  State<_BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<_BankScreen>
    with AutomaticKeepAliveClientMixin {
  final List<Widget> cardWidgets = [];
  final scrollController = ScrollController();
  final carouselController = CarouselController();

  late BusinessInformationBloc businessInformationBloc;
  late BankBloc _bloc;

  String userId = UserInformationHelper.instance.getUserId();

  StreamSubscription? _subscription;

  initialServices(BuildContext context) {
    businessInformationBloc = BlocProvider.of(context);
    _bloc = BlocProvider.of(context);
    Provider.of<BankCardSelectProvider>(context, listen: false).reset();
  }

  initData({bool isRefresh = false}) {
    if (isRefresh) {
      context.read<DashBoardBloc>().add(GetPointEvent());
    }
    _bloc.add(BankCardEventGetList());
    _bloc.add(LoadDataBankEvent());
  }

  @override
  void initState() {
    super.initState();
    initialServices(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });

    _subscription = eventBus.on<GetListBankScreen>().listen((_) {
      _bloc.add(BankCardEventGetList());
    });
  }

  Future<void> _refresh() async {
    initData();
  }

  List<BankAccountDTO> fillListBankAccount(List<BankAccountDTO> list) {
    return list;
  }

  List<Color> fillListListColor(List<Color> list) {
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double maxListHeight = MediaQuery.of(context).size.height - 200;
    final double height = MediaQuery.of(context).size.height;
    double sizedBox = 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: BlocConsumer<BankBloc, BankState>(
              listener: (context, state) async {
                if (state.request == BankType.SCAN) {
                  Navigator.pushNamed(
                    context,
                    Routes.ADD_BANK_CARD,
                    arguments: {
                      'step': 0,
                      'bankDTO': state.bankTypeDTO,
                      'bankAccount': state.bankAccount,
                      'name': ''
                    },
                  );
                }

                if (state.request == BankType.SCAN_NOT_FOUND) {
                  DialogWidget.instance.openMsgDialog(
                    title: 'Không thể xác nhận mã QR',
                    msg:
                        'Không tìm thấy thông tin trong đoạn mã QR. Vui lòng kiểm tra lại thông tin.',
                    function: () {
                      Navigator.pop(context);
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  );
                }
                if (state.request == BankType.SCAN_ERROR) {
                  DialogWidget.instance.openMsgDialog(
                    title: 'Không tìm thấy thông tin',
                    msg:
                        'Không tìm thấy thông tin ngân hàng tương ứng. Vui lòng thử lại sau.',
                    function: () {
                      Navigator.pop(context);
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                  );
                }

                if (state.request == BankType.BANK) {
                  if (scrollController.hasClients) {
                    scrollController.jumpTo(0);
                  }
                  Provider.of<DashBoardProvider>(context, listen: false)
                      .updateListBanks(state.listBanks);
                }
              },
              builder: (context, state) {
                if (state.status == BlocStatus.LOADING) {
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
                return buildList(
                  maxListHeight,
                  state.listBanks,
                  state.colors,
                  height - 280,
                  sizedBox,
                  _refresh,
                  state.listBankTypeDTO,
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          BlocConsumer<BankBloc, BankState>(
            listener: (context, state) async {},
            builder: (context, state) {
              return _buildListSection(state.listBanks, state.colors);
            },
          ),
        ],
      ),
    );
  }

  void startBarcodeScanStream() async {
    final data = await Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
    if (data is Map<String, dynamic>) {
      if (!mounted) return;
      QRScannerUtils.instance.onScanNavi(data, context);
    }
  }

  Widget _buildListSection(List<BankAccountDTO> listBanks, List<Color> colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildSection(
                'assets/images/qr-contact-other-blue.png',
                () async {
                  if (QRScannerHelper.instance.getQrIntro()) {
                    startBarcodeScanStream();
                  } else {
                    await DialogWidget.instance.showFullModalBottomContent(
                      widget: const QRScanWidget(),
                      color: AppColor.BLACK,
                    );
                    if (!mounted) return;
                    startBarcodeScanStream();
                  }
                },
                title: 'Copy mã QR',
                des: 'Quét mã VietQR để thêm/Liên kết TK ngân hàng',
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildSection(
                'assets/images/ic-bankaccount-blue.png',
                () async {
                  await Navigator.pushNamed(context, Routes.ADD_BANK_CARD);
                  getListBank(context);
                },
                title: 'Thêm TK',
                des: 'Thêm hoặc liên kết TK ngân hàng để nhận BDSD',
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildSection(
                'assets/images/ic_share_code.png',
                () async {
                  await DialogWidget.instance.showModelBottomSheet(
                    context: context,
                    sigmaX: 0,
                    sigmaY: 0,
                    padding: EdgeInsets.zero,
                    height:
                        MediaQuery.of(context).size.height - kToolbarHeight * 2,
                    widget: ShareBDSDView(),
                  );
                },
                title: 'Chia sẻ BĐSD',
                des: 'Thêm hoặc liên kết TK ngân hàng để nhận BĐSD',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String pathIcon, VoidCallback onTab,
      {String title = '', String des = ''}) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          children: [
            Image.asset(
              pathIcon,
              width: 40,
              height: 28,
              color: AppColor.BLUE_TEXT,
              fit: BoxFit.cover,
            ),
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w400, height: 1.4, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildList(
    double maxListHeight,
    List<BankAccountDTO> banks,
    List<Color> colors,
    double listHeight,
    double sizeBox,
    RefreshCallback? onRefresh,
    List<BankTypeDTO> listBanks,
  ) {
    return StackedList(
      maxListHeight: maxListHeight,
      list: banks,
      colors: colors,
      scrollController: scrollController,
      height: listHeight,
      sizeBox: sizeBox,
      onRefresh: onRefresh,
      listBanks: listBanks,
      getListBank: () {
        getListBank(context);
      },
    );
  }

  void getListBank(BuildContext context) {
    _bloc.add(BankCardEventGetList());
  }

  void getListQR(BuildContext context, List<QRCreateDTO> list) {
    _bloc.add(QREventGenerateList(list: list));
  }

  void addQRWidget(double width, double height, List<QRGeneratedDTO> list,
      List<BankAccountDTO> bankAccounts) {
    if (list.isNotEmpty) {
      for (int i = 0; i < list.length; i++) {
        final Widget qrWidget = Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
          child: InkWell(
            onTap: () {
              DialogWidget.instance.showModalBottomContent(
                widget: FunctionBankWidget(
                  bankAccountDTO: bankAccounts[i],
                  qrGeneratedDTO: list[i],
                  businessInformationBloc: businessInformationBloc,
                ),
                height: height * 0.35,
              );
            },
            child: VietQRWidget(
              width: width - 10,
              qrGeneratedDTO: list[i],
              content: '',
              isCopy: true,
              isStatistic: true,
              // isSmallWidget: (height <= 800),
            ),
          ),
        );
        cardWidgets.add(qrWidget);
      }
    }
  }

  void resetProvider(BuildContext context) {
    Provider.of<BankCardSelectProvider>(context, listen: false).reset();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }
}

class StackedList extends StatefulWidget {
  final double maxListHeight;
  final List<BankAccountDTO> list;
  final List<Color> colors;
  final ScrollController scrollController;
  final double sizeBox;
  final double height;
  final RefreshCallback? onRefresh;
  final Function getListBank;
  final List<BankTypeDTO> listBanks;

  const StackedList({
    super.key,
    required this.maxListHeight,
    required this.list,
    required this.colors,
    required this.scrollController,
    required this.sizeBox,
    required this.height,
    this.onRefresh,
    required this.getListBank,
    required this.listBanks,
  });

  @override
  State<StatefulWidget> createState() => _StackedList();
}

class _StackedList extends State<StackedList> {
  _StackedList();

  @override
  void initState() {
    super.initState();
    handleMessageOnBackground();
  }

  void handleMessageOnBackground() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (remoteMessage) {
        if (remoteMessage != null) {
          if (remoteMessage.data['transactionReceiveId'] != null) {
            Navigator.pushNamed(
              NavigationService.navigatorKey.currentContext!,
              Routes.TRANSACTION_DETAIL,
              arguments: {
                'transactionId': remoteMessage.data['transactionReceiveId'],
                // 'bankId': bankId,
              },
            );
          }
        }
      },
    );
  }

  List<BankAccountDTO> fillListBankAccount(List<BankAccountDTO> listBank) {
    List<BankAccountDTO> listBankAccount = [];

    listBankAccount = listBank;

    return listBankAccount;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh!,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: fillListBankAccount(widget.list).map(
              (item) {
                int index = fillListBankAccount(widget.list).indexOf(item);
                return Padding(
                  padding: EdgeInsets.only(top: index * 97),
                  child: _buildCardItem(
                      context: context,
                      index: index,
                      maxLengthList: fillListBankAccount(widget.list).length,
                      dto: item,
                      getListBank: widget.getListBank),
                );
              },
            ).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildCardItem(
      {required BuildContext context,
      required int index,
      required BankAccountDTO dto,
      required Function getListBank,
      int maxLengthList = 0}) {
    String userId = UserInformationHelper.instance.getUserId();
    final double width = MediaQuery.of(context).size.width;
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    });

    if (index == 0) {
      return _buildCardWallet();
    } else if (index == maxLengthList - 1) {
      return _buildAddBankCard(width);
    }
    return (dto.id.isNotEmpty)
        ? InkWell(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BankCardDetailScreen(bankId: dto.id),
                  settings: const RouteSettings(
                    name: Routes.BANK_CARD_DETAIL_VEW,
                  ),
                ),
              );

              getListBank();
            },
            child: Container(
              width: width,
              height: 120,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 14,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: fillListBankAccount(widget.list)[index].bankColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    _buildTitleCard(dto, userId),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Spacer(),
                        if ((!dto.isAuthenticated &&
                            dto.bankCode == 'MB' &&
                            dto.userId == userId))
                          InkWell(
                            onTap: () async {
                              BankTypeDTO bankTypeDTO;

                              bankTypeDTO = widget.listBanks.where((element) {
                                return element.bankCode == 'MB';
                              }).first;

                              await Navigator.pushNamed(
                                context,
                                Routes.ADD_BANK_CARD,
                                arguments: {
                                  'step': 1,
                                  'bankAccount': dto.bankAccount,
                                  'name': dto.userBankName,
                                  'bankDTO': bankTypeDTO,
                                  'bankId': dto.id,
                                },
                              );

                              getListBank();
                            },
                            child: BoxLayout(
                              width: 95,
                              height: 30,
                              borderRadius: 6,
                              alignment: Alignment.center,
                              padding: EdgeInsets.zero,
                              bgColor:
                                  Theme.of(context).cardColor.withOpacity(0.3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/ic-linked-white.png',
                                    height: 28,
                                    width: 28,
                                  ),
                                  const Text(
                                    'Liên kết',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColor.WHITE,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  )
                                ],
                              ),
                            ),
                          ),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        InkWell(
                          onTap: () async {
                            NavigatorUtils.navigatePage(
                                context, CreateQrScreen(bankAccountDTO: dto));
                            // Navigator.pushNamed(
                            //   context,
                            //   Routes.CREATE_QR,
                            //   arguments: {
                            //     'bankInfo': dto,
                            //   },
                            // );
                          },
                          child: BoxLayout(
                            width: 95,
                            height: 30,
                            borderRadius: 6,
                            alignment: Alignment.center,
                            padding: EdgeInsets.zero,
                            bgColor:
                                Theme.of(context).cardColor.withOpacity(0.3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/ic-qr-white.png',
                                  height: 20,
                                  width: 20,
                                ),
                                const Text(
                                  'Tạo QR',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColor.WHITE,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 20)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget _buildTitleCard(BankAccountDTO dto, String userId) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      child: SizedBox(
        height: 35,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      image: ImageUtils.instance.getImageNetWork(
                        dto.imgId,
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
                      '${dto.bankCode} - ${dto.bankAccount}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColor.WHITE, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      dto.userBankName.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColor.WHITE,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                if (dto.isAuthenticated)
                  Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.only(top: 4, left: 2),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      color: dto.userId == userId
                          ? AppColor.BLUE_TEXT
                          : AppColor.ORANGE,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColor.WHITE,
                      size: 8,
                    ),
                  )
              ],
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(top: 10, right: 6),
              child: Icon(
                Icons.arrow_forward_ios,
                color: AppColor.WHITE,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardWallet() {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(top: 16, left: 12, right: 12),
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      decoration: BoxDecoration(
          color: AppColor.BLUE_TEXT, borderRadius: BorderRadius.circular(22)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    borderRadius: BorderRadius.circular(40),
                    image: const DecorationImage(
                        image:
                            AssetImage('assets/images/ic-viet-qr-small.png'))),
              ),
              const Padding(padding: EdgeInsets.only(left: 10)),
              Consumer<AuthProvider>(
                builder: (context, provider, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 5)),
                      const Text(
                        'VietQR',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            color: AppColor.WHITE,
                            fontWeight: FontWeight.w600),
                      ),
                      Row(
                        children: [
                          Text(
                            'Số dư : ${CurrencyUtils.instance.getCurrencyFormatted(provider.introduceDTO?.amount ?? '0')} VQR - Điểm thưởng: ${provider.introduceDTO?.point ?? '0'} ',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColor.WHITE,
                              fontSize: 13,
                            ),
                          ),
                          Image.asset(
                            'assets/images/ic_point.png',
                            height: 16,
                            color: AppColor.WHITE,
                          )
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(top: 10, right: 8),
            child: Icon(
              Icons.arrow_forward_ios,
              color: AppColor.WHITE,
              size: 12,
            ),
          ),
        ],
      ),
    );
  }

  final MethodChannel platformChannel = const MethodChannel('scan_qr_code');

  Widget _buildAddBankCard(double width) {
    return GestureDetector(
      onTap: () async {
        // _pickAndProcessQRImage();
        await Navigator.pushNamed(context, Routes.ADD_BANK_CARD);
        widget.getListBank();
      },
      child: Container(
        width: width,
        height: 120,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: Theme.of(context).scaffoldBackgroundColor,
            width: 14,
          ),
        ),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg-member-card.png'),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/ic-card-grey.png',
                    height: 35,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 5)),
                  const Text(
                    'Thêm tài khoản ngân hàng',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                      color: AppColor.GREY_TEXT,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StackedListChild extends StatelessWidget {
  final double minHeight;
  final double maxHeight;
  final bool pinned;
  final bool floating;
  final Widget child;

  SliverPersistentHeaderDelegate get _delegate => _StackedListDelegate(
      minHeight: minHeight, maxHeight: maxHeight, child: child);

  const StackedListChild({
    Key? key,
    required this.minHeight,
    required this.maxHeight,
    required this.child,
    this.pinned = false,
    this.floating = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
        key: key,
        pinned: pinned,
        delegate: _delegate,
      );
}

class _StackedListDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StackedListDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StackedListDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight / 2 ||
        minHeight != oldDelegate.minHeight / 2 ||
        child != oldDelegate.child;
  }
}
