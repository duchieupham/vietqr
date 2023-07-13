import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'dart:math' as math;

import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/currency_utils.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/features/account/blocs/account_bloc.dart';
import 'package:vierqr/features/account/events/account_event.dart';
import 'package:vierqr/features/account/states/account_state.dart';
import 'package:vierqr/features/bank_detail/bank_card_detail_screen.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_card/widgets/function_bank_widget.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/generate_qr/views/create_qr.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/bank_%20arrangement_provider.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/bank_card_select_provider.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class BankScreen extends StatelessWidget {
  const BankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BankBloc>(
      create: (BuildContext context) => BankBloc(context),
      child: const _BankScreen(),
    );
  }
}

class _BankScreen extends StatefulWidget {
  const _BankScreen({super.key});

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

  initData() {
    _bloc.add(BankCardEventGetList());
  }

  @override
  void initState() {
    super.initState();
    initialServices(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });

    _subscription = eventBus.on<ChangeThemeEvent>().listen((_) {
      _bloc.add(BankCardEventGetList());
    });
  }

  Future<void> _refresh() async {
    initData();
    // refreshController.refreshCompleted();
  }

  void onLoading() async {
    // refreshController.loadComplete();
  }

  List<BankAccountDTO> fillListBankAccount(List<BankAccountDTO> list) {
    // if (list.isNotEmpty) {
    //   if (list.length > 3) {
    //     return [
    //       list[0],
    //       list[1],
    //       list[2],
    //     ];
    //   }
    // }
    return list;
  }

  List<Color> fillListListColor(List<Color> list) {
    // if (list.isNotEmpty) {
    //   if (list.length > 3) {
    //     return [
    //       list[0],
    //       list[1],
    //       list[2],
    //     ];
    //   }
    // }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double width = MediaQuery.of(context).size.width;
    final double maxListHeight = MediaQuery.of(context).size.height - 200;
    final double height = MediaQuery.of(context).size.height;
    double sizedBox = 0;
    return Consumer<BankArrangementProvider>(
      builder: (context, provider, child) {
        return (provider.type == 0)
            ? Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Tài khoản',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Sử dụng tạo mã QR, đối soát giao dịch',
                            style: TextStyle(
                                fontSize: 12, color: AppColor.GREY_TEXT),
                          ),
                          // GestureDetector(
                          //   onTap: () {},
                          //   child: const Text(
                          //     'Tất cả',
                          //     style: TextStyle(
                          //       decoration: TextDecoration.underline,
                          //       fontSize: 13,
                          //       color: AppColor.BLUE_TEXT,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
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

                          if (state.request == BankType.BANK) {
                            if (scrollController.hasClients) {
                              scrollController.jumpTo(0);
                            }
                          }
                          // if (state.status == BlocStatus.INSERT ||
                          //     state.status == BlocStatus.DELETE) {
                          //   if (scrollController.hasClients) {
                          //     scrollController.jumpTo(0);
                          //   }
                          //   getListBank(context);
                          // }
                        },
                        builder: (context, state) {
                          if (state.status == BlocStatus.LOADING) {
                            return const Center(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: AppColor.GREEN,
                                ),
                              ),
                            );
                          }

                          return buildList(
                              maxListHeight,
                              fillListBankAccount(state.listBanks),
                              fillListListColor(state.colors),
                              height - 280,
                              sizedBox,
                              _refresh);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildListSection(),
                  ],
                ),
              )
            : Container(
                width: width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg-qr.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Column(
                  children: [
                    BlocConsumer<BankBloc, BankState>(
                      listener: (context, state) {
                        if (state.status == BlocStatus.SUCCESS) {
                          List<QRCreateDTO> qrCreateDTOs = [];
                          if (state.listBanks.isNotEmpty) {
                            for (BankAccountDTO bankAccountDTO
                                in state.listBanks) {
                              QRCreateDTO qrCreateDTO = QRCreateDTO(
                                bankId: bankAccountDTO.id,
                                amount: '',
                                content: '',
                                branchId: '',
                                businessId: '',
                                userId: '',
                              );
                              qrCreateDTOs.add(qrCreateDTO);
                            }
                            getListQR(context, qrCreateDTOs);
                          }
                        }
                        // if (state.status == BlocStatus.INSERT ||
                        //     state.status == BlocStatus.DELETE) {
                        //   getListBank(context);
                        // }
                      },
                      builder: (context, state) {
                        return Expanded(
                          child: (state.listGeneratedQR.isEmpty)
                              ? _buildEmptyList(width)
                              : Column(
                                  children: [
                                    CarouselSlider(
                                      carouselController: carouselController,
                                      items: cardWidgets,
                                      options: CarouselOptions(
                                        viewportFraction: 1,
                                        aspectRatio:
                                            width / (width + width * 0.25),
                                        disableCenter: true,
                                        onPageChanged: ((index, reason) {
                                          Provider.of<BankAccountProvider>(
                                                  context,
                                                  listen: false)
                                              .updateIndex(index);
                                        }),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      width: width,
                                      height: 10,
                                      alignment: Alignment.center,
                                      child: Consumer<BankAccountProvider>(
                                          builder: (context, page, child) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                state.listGeneratedQR.length,
                                            itemBuilder: ((context, index) =>
                                                _buildDot((index ==
                                                    page.indexSelected))));
                                      }),
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                  ],
                ),
              );
      },
    );
  }

  Future<void> startBarcodeScanStream(BuildContext context) async {
    String data = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.QR);
    if (data.isNotEmpty) {
      if (data == TypeQR.NEGATIVE_ONE.value) {
      } else if (data == TypeQR.NEGATIVE_TWO.value) {
        DialogWidget.instance.openMsgDialog(
          title: 'Không thể xác nhận mã QR',
          msg: 'Ảnh QR không đúng định dạng, vui lòng chọn ảnh khác.',
          function: () {
            Navigator.pop(context);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        );
      } else {
        if (data.contains('|')) {
          final list = data.split("|");
          if (list.isNotEmpty) {
            NationalScannerDTO identityDTO = NationalScannerDTO.fromJson(list);
            if (!mounted) return;
            Navigator.pushNamed(
              context,
              Routes.NATIONAL_INFORMATION,
              arguments: {'dto': identityDTO},
            );
          }
        } else {
          if (!mounted) return;
          _bloc.add(ScanQrEventGetBankType(code: data));
        }
      }
    }
  }

  Widget _buildListSection() {
    return Column(
      children: [
        _buildSection('assets/images/ic-qr-white.png', () async {
          if (QRScannerHelper.instance.getQrIntro()) {
            // Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
            startBarcodeScanStream(context);
          } else {
            await DialogWidget.instance.showFullModalBottomContent(
              widget: const QRScanWidget(),
              color: AppColor.BLACK,
            );
            if (!mounted) return;
            startBarcodeScanStream(context);
          }
        },
            title: 'Copy mã QR',
            des: 'Quét mã VietQR để thêm/Liên kết TK ngân hàng'),
      ],
    );
  }

  Widget _buildSection(String pathIcon, VoidCallback onTab,
      {String title = '', String des = ''}) {
    return GestureDetector(
      onTap: onTab,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: AppColor.GREY_LIGHT.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              pathIcon,
              width: 40,
              color: AppColor.BLUE_TEXT,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  des,
                  style:
                      const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
              ],
            )),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(top: 4, left: 2),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  color: AppColor.GREY_LIGHT.withOpacity(0.2)),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: AppColor.GREY_HIGHLIGHT,
                size: 12,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyList(double width) {
    return UnconstrainedBox(
      child: BoxLayout(
        width: width - 60,
        borderRadius: 15,
        alignment: Alignment.center,
        bgColor: Theme.of(context).cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ic-card.png',
              width: width * 0.4,
            ),
            const Text(
              'Chưa có tài khoản ngân hàng được thêm.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            ButtonIconWidget(
              width: width,
              icon: Icons.add_rounded,
              title: 'Thêm TK ngân hàng',
              function: () {
                Navigator.pushNamed(context, Routes.ADD_BANK_CARD).then(
                  (value) {
                    Provider.of<BankAccountProvider>(context, listen: false)
                        .reset();
                  },
                );
              },
              bgColor: AppColor.GREEN,
              textColor: AppColor.WHITE,
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
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
      RefreshCallback? onRefresh) {
    return StackedList(
      maxListHeight: maxListHeight,
      list: banks,
      colors: colors,
      scrollController: scrollController,
      height: listHeight,
      sizeBox: sizeBox,
      onRefresh: onRefresh,
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

  Widget _buildDot(bool isSelected) {
    return Container(
      width: (isSelected) ? 20 : 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: (isSelected)
            ? Border.all(color: AppColor.GREY_LIGHT, width: 0.5)
            : null,
        color: (isSelected) ? AppColor.WHITE : AppColor.GREY_LIGHT,
        borderRadius: BorderRadius.circular(10),
      ),
    );
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
  });

  @override
  State<StatefulWidget> createState() => _StackedList();
}

class _StackedList extends State<StackedList> {
  // final refreshController = RefreshController(initialRefresh: false);
  List<BankAccountDTO> listBankAccount = [];
  List<Color> listColor = [];
  late AccountBloc _accountBloc;

  @override
  void initState() {
    super.initState();
    _accountBloc = BlocProvider.of(context);
    addElementInList();
    _accountBloc.add(InitAccountEvent());
  }

  addElementInList() {
    BankAccountDTO otd = const BankAccountDTO(
        id: '',
        bankAccount: '',
        userBankName: '',
        bankCode: '',
        bankName: '',
        imgId: '',
        type: 0,
        branchId: '',
        businessId: '',
        branchName: '',
        isAuthenticated: false,
        businessName: '');
    BankAccountDTO otd2 = const BankAccountDTO(
        id: '',
        bankAccount: 'MB',
        userBankName: '',
        bankCode: '',
        bankName: '',
        imgId: '',
        type: 0,
        branchId: '',
        businessId: '',
        branchName: '',
        isAuthenticated: false,
        businessName: '');
    listBankAccount = widget.list;
    if (listBankAccount.isNotEmpty) {
      listBankAccount.insert(0, otd);
      listBankAccount = [...listBankAccount, otd2];
    } else {
      listBankAccount = [otd, otd2];
    }

    listColor = widget.colors;
    if (listColor.isNotEmpty) {
      listColor.insert(0, Colors.white);
      listColor = [...listColor, Colors.black26];
    } else {
      listColor = [Colors.white, Colors.black26];
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh!,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            children: listBankAccount.map(
              (item) {
                int index = listBankAccount.indexOf(item);
                return Padding(
                  padding: EdgeInsets.only(top: index * 97),
                  child: _buildCardItem(
                    context: context,
                    index: index,
                    maxLengthList: listBankAccount.length,
                    dto: item,
                    getListBank: widget.getListBank,
                  ),
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
                  color: listColor[index],
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
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.ADD_BANK_CARD,
                                arguments: {
                                  'pageIndex': 3,
                                  'bankAccount': dto.bankAccount,
                                  'name': dto.userBankName
                                },
                              );
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
                          onTap: () {
                            BankAccountDTO bankAccountDTO = BankAccountDTO(
                              id: dto.id,
                              bankAccount: dto.bankAccount,
                              userBankName: dto.userBankName,
                              bankCode: dto.bankCode,
                              bankName: dto.bankName,
                              imgId: dto.imgId,
                              type: dto.type,
                              branchId:
                                  (dto.branchId.isEmpty) ? '' : dto.branchId,
                              businessId: (dto.businessId.isEmpty)
                                  ? ''
                                  : dto.businessId,
                              branchName: (dto.branchName.isEmpty)
                                  ? ''
                                  : dto.branchName,
                              businessName: (dto.businessName.isEmpty)
                                  ? ''
                                  : dto.businessName,
                              isAuthenticated: dto.isAuthenticated,
                            );
                            Navigator.of(context)
                                .push(
                                  MaterialPageRoute(
                                    builder: (context) => CreateQRScreen(
                                      bankAccountDTO: bankAccountDTO,
                                    ),
                                  ),
                                )
                                .then((value) {});
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
                          ? AppColor.GREEN
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
              BlocConsumer<AccountBloc, AccountState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state.status == BlocStatus.SUCCESS) {
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
                                'Số dư : ${CurrencyUtils.instance.getCurrencyFormatted(state.introduceDTO!.amount ?? '0')} VND - Điểm thưởng: ${state.introduceDTO!.point ?? '0'} ',
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
                    }
                    return const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: AppColor.WHITE,
                      ),
                    );
                  }),
            ],
          ),
          const Spacer(),
          // const Padding(
          //   padding: EdgeInsets.only(top: 10, right: 6),
          //   child: Icon(
          //     Icons.arrow_forward_ios,
          //     color: AppColor.WHITE,
          //     size: 12,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildAddBankCard(double width) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(context, Routes.ADD_BANK_CARD);

        widget.getListBank();
      },
      child: Container(
        width: width - 20,
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
