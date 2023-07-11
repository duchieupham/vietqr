import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'dart:math' as math;

import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/check_type.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/features/bank_card/states/bank_state.dart';
import 'package:vierqr/features/bank_card/widgets/function_bank_widget.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/generate_qr/blocs/qr_blocs.dart';
import 'package:vierqr/features/generate_qr/events/qr_event.dart';
import 'package:vierqr/features/generate_qr/states/qr_state.dart';
import 'package:vierqr/features/generate_qr/views/create_qr.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/national_scanner_dto.dart';
import 'package:vierqr/models/qr_create_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';
import 'package:vierqr/services/providers/bank_%20arrangement_provider.dart';
import 'package:vierqr/services/providers/bank_account_provider.dart';
import 'package:vierqr/services/providers/bank_card_select_provider.dart';
import 'package:vierqr/services/shared_references/qr_scanner_helper.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

const double _minHeight = 60;
const double _maxHeight = 150;

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen>
    with AutomaticKeepAliveClientMixin {
  final List<QRGeneratedDTO> qrGenerateds = [];
  final List<Widget> cardWidgets = [];
  final scrollController = ScrollController();
  late QRBloc qrBloc;
  final carouselController = CarouselController();

  late BusinessInformationBloc businessInformationBloc;
  late BankBloc bankCardBloc;

  String userId = UserInformationHelper.instance.getUserId();

  StreamSubscription? _subscription;

  initialServices(BuildContext context) {
    businessInformationBloc = BlocProvider.of(context);
    bankCardBloc = BlocProvider.of(context);
    qrBloc = BlocProvider.of(context);
    Provider.of<BankCardSelectProvider>(context, listen: false).reset();
  }

  initData() {
    bankCardBloc.add(BankCardEventGetList(userId: userId));
  }

  @override
  void initState() {
    super.initState();
    initialServices(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });

    _subscription = eventBus.on<ChangeThemeEvent>().listen((_) {
      bankCardBloc.add(BankCardEventGetList(userId: userId));
    });
  }

  Future<void> _refresh() async {
    initData();
    // refreshController.refreshCompleted();
  }

  void onLoading() async {
    // refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double width = MediaQuery.of(context).size.width;
    final double maxListHeight = MediaQuery.of(context).size.height - 200;
    final double height = MediaQuery.of(context).size.height;
    double sizedBox = 0;
    double listHeight = 0;
    return Consumer<BankArrangementProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: _refresh,
          child: (provider.type == 0)
              ? Column(
                  children: [
                    BlocConsumer<BankBloc, BankState>(
                      listener: (context, state) async {
                        if (state.type == TypePermission.ScanSuccess) {
                          if (state.bankTypeDTO!.bankCode == 'MB') {
                            Provider.of<AddBankProvider>(context, listen: false)
                                .updateSelect(2);
                            Provider.of<AddBankProvider>(context, listen: false)
                                .updateRegisterAuthentication(true);
                          } else {
                            Provider.of<AddBankProvider>(context, listen: false)
                                .updateSelect(1);
                            Provider.of<AddBankProvider>(context, listen: false)
                                .updateRegisterAuthentication(false);
                          }
                          Provider.of<AddBankProvider>(context, listen: false)
                              .updateSelectBankType(state.bankTypeDTO!);
                          await Navigator.pushNamed(
                            context,
                            Routes.ADD_BANK_CARD,
                            arguments: {
                              'pageIndex': 2,
                              'bankAccount': state.bankAccount,
                            },
                          );

                          bankCardBloc.add(UpdateEvent());
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
                          return const Expanded(
                            child: UnconstrainedBox(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: AppColor.GREEN,
                                ),
                              ),
                            ),
                          );
                        }
                        if (state.status == BlocStatus.SUCCESS) {
                          if (scrollController.hasClients) {
                            scrollController.jumpTo(0);
                          }
                          sizedBox =
                              (state.listBanks.length * _maxHeight) * 0.7;
                          listHeight = (sizedBox < _maxHeight)
                              ? _maxHeight
                              : (sizedBox > maxListHeight)
                                  ? maxListHeight
                                  : sizedBox;
                        }

                        return (sizedBox <= listHeight)
                            ? buildList(maxListHeight, state.listBanks,
                                state.colors, listHeight, sizedBox, _refresh)
                            : Expanded(
                                child: buildList(
                                    maxListHeight,
                                    state.listBanks,
                                    state.colors,
                                    listHeight,
                                    sizedBox,
                                    _refresh),
                              );
                      },
                    ),
                    Container(
                      height: (PlatformUtils.instance.isAndroidApp())
                          ? 80
                          : (PlatformUtils.instance.isIOsApp() && height <= 800)
                              ? 90
                              : 110,
                    ),
                  ],
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
                          return BlocBuilder<QRBloc, QRState>(
                            builder: (context, qrState) {
                              if (state.status == BlocStatus.LOADING ||
                                  qrState is QRGenerateLoadingState) {
                                return const Expanded(
                                  child: UnconstrainedBox(
                                    child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        color: AppColor.WHITE,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (qrState is QRGeneratedListSuccessfulState) {
                                cardWidgets.clear();
                                qrGenerateds.clear();
                                if (qrState.list.isNotEmpty) {
                                  addQRWidget(width, height, qrState.list,
                                      state.listBanks);
                                }
                              }
                              return Expanded(
                                child: (qrGenerateds.isEmpty)
                                    ? UnconstrainedBox(
                                        child: BoxLayout(
                                          width: width - 60,
                                          borderRadius: 15,
                                          alignment: Alignment.center,
                                          bgColor: Theme.of(context).cardColor,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10)),
                                              ButtonIconWidget(
                                                width: width,
                                                icon: Icons.add_rounded,
                                                title: 'Thêm TK ngân hàng',
                                                function: () {
                                                  Provider.of<AddBankProvider>(
                                                          context,
                                                          listen: false)
                                                      .updateSelect(1);
                                                  Navigator.pushNamed(context,
                                                      Routes.ADD_BANK_CARD,
                                                      arguments: {
                                                        'pageIndex': 1
                                                      }).then(
                                                    (value) {
                                                      Provider.of<BankAccountProvider>(
                                                              context,
                                                              listen: false)
                                                          .reset();
                                                    },
                                                  );
                                                },
                                                bgColor: AppColor.GREEN,
                                                textColor: AppColor.WHITE,
                                              ),
                                              const Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10)),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          CarouselSlider(
                                            carouselController:
                                                carouselController,
                                            items: cardWidgets,
                                            options: CarouselOptions(
                                              viewportFraction: 1,
                                              aspectRatio: width /
                                                  (width + width * 0.25),
                                              disableCenter: true,
                                              onPageChanged: ((index, reason) {
                                                Provider.of<BankAccountProvider>(
                                                        context,
                                                        listen: false)
                                                    .updateIndex(index);
                                              }),
                                            ),
                                          ),
                                          // Expanded(
                                          //   child: PageView(
                                          //     onPageChanged: (index) {
                                          //       Provider.of<BankAccountProvider>(
                                          //               context,
                                          //               listen: false)
                                          //           .updateIndex(index);
                                          //     },
                                          //     children: List.generate(
                                          //       cardWidgets.length,
                                          //       (index) {
                                          //         return cardWidgets[index];
                                          //       },
                                          //     ).toList(),
                                          //   ),
                                          // ),
                                          // const SizedBox(height: 100),
                                          const Spacer(),
                                          Container(
                                            width: width,
                                            height: 10,
                                            alignment: Alignment.center,
                                            child:
                                                Consumer<BankAccountProvider>(
                                                    builder:
                                                        (context, page, child) {
                                              return ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount:
                                                      qrGenerateds.length,
                                                  itemBuilder: ((context,
                                                          index) =>
                                                      _buildDot((index ==
                                                          page.indexSelected))));
                                            }),
                                          ),
                                        ],
                                      ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: (PlatformUtils.instance.isAndroidApp())
                            ? 90
                            : (PlatformUtils.instance.isIOsApp() &&
                                    height <= 800)
                                ? 70
                                : 110,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget buildList(
      double maxListHeight,
      List<BankAccountDTO> banks,
      List<Color> colors,
      double listHeight,
      double sizeBox,
      RefreshCallback? onRefresh) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: StackedList(
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
      ),
    );
  }

  void getListBank(BuildContext context) {
    String userId = UserInformationHelper.instance.getUserId();
    bankCardBloc.add(
      BankCardEventGetList(userId: userId),
    );
  }

  void getListQR(BuildContext context, List<QRCreateDTO> list) {
    qrGenerateds.clear();
    qrBloc.add(QREventGenerateList(list: list));
  }

  void addQRWidget(double width, double height, List<QRGeneratedDTO> list,
      List<BankAccountDTO> bankAccounts) {
    if (qrGenerateds.isEmpty) {
      qrGenerateds.addAll(list);
      if (qrGenerateds.isNotEmpty) {
        for (int i = 0; i < qrGenerateds.length; i++) {
          final Widget qrWidget = Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: InkWell(
              onTap: () {
                DialogWidget.instance.showModalBottomContent(
                  widget: FunctionBankWidget(
                    bankAccountDTO: bankAccounts[i],
                    qrGeneratedDTO: qrGenerateds[i],
                    businessInformationBloc: businessInformationBloc,
                  ),
                  height: height * 0.35,
                );
              },
              child: VietQRWidget(
                width: width - 10,
                qrGeneratedDTO: qrGenerateds[i],
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

  @override
  void initState() {
    super.initState();
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
          context.read<BankBloc>().add(ScanQrEventGetBankType(code: data));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isPinned = (widget.sizeBox <= widget.maxListHeight) ||
        (((widget.list.length * _minHeight) + _maxHeight) < widget.height);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (widget.list.isEmpty)
            ? ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Container(
                  width: width,
                  color: Theme.of(context).cardColor,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 150,
                        height: 100,
                        child: Image.asset(
                          'assets/images/ic-card.png',
                        ),
                      ),
                      const Text('Chưa có tài khoản ngân hàng được thêm.'),
                      const SizedBox(height: 16),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset('assets/images/banner_app.png'))
                    ],
                  ),
                ),
              )
            : (widget.sizeBox <= widget.height)
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: SizedBox(
                      height: widget.height,
                      child: RefreshIndicator(
                        onRefresh: widget.onRefresh!,
                        // controller: refreshController,
                        // scrollController: widget.scrollController,
                        child: CustomScrollView(
                          slivers: widget.list.map(
                            (item) {
                              int index = widget.list.indexOf(item);
                              return StackedListChild(
                                key: Key(const Uuid().v1()),
                                minHeight: _minHeight,
                                maxHeight: widget.list.indexOf(item) ==
                                        widget.list.length - 1
                                    ? MediaQuery.of(context).size.height
                                    : _maxHeight,
                                pinned: isPinned,
                                floating: true,
                                child: _buildCardItem(
                                  context: context,
                                  index: index,
                                  dto: widget.list[index],
                                  getListBank: widget.getListBank,
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: (widget.list.isEmpty)
                        ? ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: Container(
                              width: width,
                              height: _maxHeight,
                              color: Theme.of(context).cardColor,
                              alignment: Alignment.center,
                              child: Column(children: [
                                SizedBox(
                                  width: 150,
                                  height: 100,
                                  child: Image.asset(
                                    'assets/images/ic-card.png',
                                  ),
                                ),
                                const Text(
                                    'Chưa có tài khoản ngân hàng được thêm.'),
                              ]),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(15),
                            ),
                            child: SizedBox(
                              height: widget.height,
                              child: RefreshIndicator(
                                onRefresh: widget.onRefresh!,
                                // controller: refreshController,
                                // scrollController: widget.scrollController,
                                child: CustomScrollView(
                                  controller: widget.scrollController,
                                  slivers: widget.list.map(
                                    (item) {
                                      int index = widget.list.indexOf(item);
                                      return StackedListChild(
                                        key: Key(const Uuid().v1()),
                                        minHeight: _minHeight,
                                        maxHeight: widget.list.indexOf(item) ==
                                                widget.list.length - 1
                                            ? MediaQuery.of(context).size.height
                                            : _maxHeight,
                                        pinned: isPinned,
                                        floating: true,
                                        child: _buildCardItem(
                                          context: context,
                                          index: index,
                                          dto: widget.list[index],
                                          getListBank: widget.getListBank,
                                        ),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                          ),
                  ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        InkWell(
          onTap: () async {
            Provider.of<AddBankProvider>(context, listen: false)
                .updateSelect(1);
            await Navigator.pushNamed(context, Routes.ADD_BANK_CARD,
                arguments: {'pageIndex': 1});
            widget.getListBank();
          },
          child: Row(
            children: [
              BoxLayout(
                width: width / 2 - 15,
                height: 40,
                bgColor: Theme.of(context).buttonColor,
                borderRadius: 5,
                enableShadow: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.add_rounded,
                      size: 15,
                      color: AppColor.GREEN,
                    ),
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text(
                      'TK ngân hàng',
                      style: TextStyle(
                        color: AppColor.GREEN,
                      ),
                    )
                  ],
                ),
              ),
              const Spacer(),
              BoxLayout(
                width: width / 2 - 15,
                height: 40,
                bgColor: Theme.of(context).buttonColor,
                borderRadius: 5,
                enableShadow: true,
                child: InkWell(
                  onTap: () async {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 15,
                        color: AppColor.BLUE_TEXT,
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Text(
                        'Quét mã QR',
                        style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardItem({
    required BuildContext context,
    required int index,
    required BankAccountDTO dto,
    required Function getListBank,
  }) {
    String userId = UserInformationHelper.instance.getUserId();
    final double width = MediaQuery.of(context).size.width;
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    });

    return (dto.id.isNotEmpty)
        ? InkWell(
            onTap: () async {
              await Navigator.pushNamed(
                context,
                Routes.BANK_CARD_DETAIL_VEW,
                arguments: {
                  'bankId': dto.id,
                },
              );

              getListBank();
            },
            child: Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: widget.colors[index],
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 0.5,
                  ),
                ),
              ),
              child: SizedBox(
                width: width,
                height: 60,
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  key: Key('card$index'),
                  controller: scrollController,
                  children: [
                    Container(
                      height: 60,
                      width: width,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: Row(
                        children: [
                          UnconstrainedBox(
                            child: Container(
                              width: 60,
                              height: 30,
                              decoration: BoxDecoration(
                                color: AppColor.WHITE,
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: ImageUtils.instance.getImageNetWork(
                                    dto.imgId,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Expanded(
                            child: Text(
                              '${dto.bankCode} - ${dto.bankAccount}\n${dto.bankName}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColor.WHITE,
                              ),
                            ),
                          ),
                          if (dto.isAuthenticated)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(25)),
                                color: dto.userId == userId
                                    ? AppColor.GREEN
                                    : AppColor.ORANGE,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: AppColor.WHITE,
                                size: 14,
                              ),
                            )
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 20)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dto.userBankName.toUpperCase(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColor.WHITE,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  (dto.isAuthenticated)
                                      ? 'Trạng thái: Đã liên kết'
                                      : 'Trạng thái: Chưa liên kết',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColor.WHITE,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                                  builder: (context) => CreateQR(
                                    bankAccountDTO: bankAccountDTO,
                                  ),
                                ),
                              )
                                  .then((value) {
                                //
                              });
                            },
                            child: BoxLayout(
                              width: 110,
                              borderRadius: 5,
                              alignment: Alignment.center,
                              bgColor:
                                  Theme.of(context).cardColor.withOpacity(0.3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.add_rounded,
                                    color: AppColor.WHITE,
                                    size: 15,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    'Tạo QR',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.WHITE,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 20)),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
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
