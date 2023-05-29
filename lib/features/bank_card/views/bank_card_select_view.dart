import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'dart:math' as math;

import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/widgets/button_icon_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/viet_qr_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/features/bank_card/states/bank_card_state.dart';
import 'package:vierqr/features/bank_card/widgets/function_bank_widget.dart';
import 'package:vierqr/features/business/blocs/business_information_bloc.dart';
import 'package:vierqr/features/generate_qr/blocs/qr_blocs.dart';
import 'package:vierqr/features/generate_qr/events/qr_event.dart';
import 'package:vierqr/features/generate_qr/states/qr_state.dart';
import 'package:vierqr/features/generate_qr/views/create_qr.dart';
import 'package:vierqr/features/scan_qr/widgets/qr_scan_widget.dart';
import 'package:vierqr/layouts/box_layout.dart';
import 'package:vierqr/models/bank_account_dto.dart';
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

class BankCardSelectView extends StatelessWidget {
  final BusinessInformationBloc businessInformationBloc;
  final BankCardBloc bankCardBloc;
  static final List<BankAccountDTO> bankAccounts = [];
  static final List<Color> cardColors = [];
  static final List<QRGeneratedDTO> qrGenerateds = [];
  static final List<Widget> cardWidgets = [];
  static final ScrollController scrollController = ScrollController();
  static late QRBloc qrBloc;
  static final CarouselController carouselController = CarouselController();

  const BankCardSelectView({
    super.key,
    required this.businessInformationBloc,
    required this.bankCardBloc,
  });

  initialServices(BuildContext context) {
    Provider.of<BankCardSelectProvider>(context, listen: false).reset();
    bankAccounts.clear();
    cardColors.clear();
    String userId = UserInformationHelper.instance.getUserId();
    bankCardBloc.add(BankCardEventGetList(userId: userId));
    qrBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double maxListHeight = MediaQuery.of(context).size.height - 200;
    final double height = MediaQuery.of(context).size.height;
    double sizedBox = 0;
    double listHeight = 0;
    initialServices(context);
    return Consumer<BankArrangementProvider>(
      builder: (context, provider, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: (provider.type == 0)
                ? null
                : const DecorationImage(
                    image: AssetImage('assets/images/bg-qr.png'),
                    fit: BoxFit.fitHeight,
                  ),
          ),
          child: (provider.type == 0)
              ? Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 100)),
                    BlocConsumer<BankCardBloc, BankCardState>(
                      listener: (context, state) {
                        if (state is BankCardGetListSuccessState) {
                          resetProvider(context);
                          if (bankAccounts.isEmpty) {
                            bankAccounts.addAll(state.list);
                            cardColors.addAll(state.colors);
                          }
                        }
                        if (state
                                is BankCardInsertUnauthenticatedSuccessState ||
                            state is BankCardRemoveSuccessState ||
                            state is BankCardInsertSuccessfulState) {
                          if (scrollController.hasClients) {
                            scrollController.jumpTo(0);
                          }
                          getListBank(context);
                        }
                      },
                      builder: (context, state) {
                        if (state is BankCardLoadingListState) {
                          return const Expanded(
                            child: UnconstrainedBox(
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: DefaultTheme.GREEN,
                                ),
                              ),
                            ),
                          );
                        }
                        if (state is BankCardGetListSuccessState) {
                          if (scrollController.hasClients) {
                            scrollController.jumpTo(0);
                          }
                          sizedBox = (bankAccounts.length * _maxHeight) * 0.75;
                          listHeight = (sizedBox < _maxHeight)
                              ? _maxHeight
                              : (sizedBox > maxListHeight)
                                  ? maxListHeight
                                  : sizedBox;
                        }

                        return (sizedBox <= listHeight)
                            ? buildList(
                                maxListHeight,
                                bankAccounts,
                                cardColors,
                                listHeight,
                                sizedBox,
                              )
                            : Expanded(
                                child: buildList(
                                  maxListHeight,
                                  bankAccounts,
                                  cardColors,
                                  listHeight,
                                  sizedBox,
                                ),
                              );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: (PlatformUtils.instance.isAndroidApp())
                            ? 90
                            : (PlatformUtils.instance.isIOsApp() &&
                                    height <= 800)
                                ? 90
                                : 110,
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 35)),
                    Expanded(
                      child: BlocConsumer<BankCardBloc, BankCardState>(
                        listener: ((context, state) {
                          if (state is BankCardGetListSuccessState) {
                            resetProvider(context);
                            if (bankAccounts.isEmpty) {
                              bankAccounts.addAll(state.list);
                              List<QRCreateDTO> qrCreateDTOs = [];
                              if (bankAccounts.isNotEmpty) {
                                for (BankAccountDTO bankAccountDTO
                                    in bankAccounts) {
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
                          }
                          if (state
                                  is BankCardInsertUnauthenticatedSuccessState ||
                              state is BankCardRemoveSuccessState ||
                              state is BankCardInsertSuccessfulState) {
                            getListBank(context);
                          }
                        }),
                        builder: ((context, state) {
                          return SizedBox(
                            width: width,
                            height: height,
                            child: BlocBuilder<QRBloc, QRState>(
                              builder: (context, state) {
                                if (state is QRGeneratedListSuccessfulState) {
                                  cardWidgets.clear();
                                  qrGenerateds.clear();
                                  if (state.list.isNotEmpty) {
                                    addQRWidget(width, height, state.list);
                                  }
                                }
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(top: 50)),
                                    Expanded(
                                      child: (qrGenerateds.isEmpty)
                                          ? UnconstrainedBox(
                                              child: BoxLayout(
                                                width: width - 60,
                                                borderRadius: 15,
                                                alignment: Alignment.center,
                                                bgColor:
                                                    Theme.of(context).cardColor,
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
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10)),
                                                    ButtonIconWidget(
                                                      width: width,
                                                      icon: Icons.add_rounded,
                                                      title:
                                                          'Thêm TK ngân hàng',
                                                      function: () {
                                                        Provider.of<AddBankProvider>(
                                                                context,
                                                                listen: false)
                                                            .updateSelect(1);
                                                        Navigator.pushNamed(
                                                            context,
                                                            Routes
                                                                .ADD_BANK_CARD,
                                                            arguments: {
                                                              'pageIndex': 1
                                                            }).then(
                                                          (value) {
                                                            Provider.of<BankAccountProvider>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .reset();
                                                          },
                                                        );
                                                      },
                                                      bgColor:
                                                          DefaultTheme.GREEN,
                                                      textColor:
                                                          DefaultTheme.WHITE,
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10)),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              width: width,
                                              child: CarouselSlider(
                                                carouselController:
                                                    carouselController,
                                                items: cardWidgets,
                                                options: CarouselOptions(
                                                  aspectRatio: 1,
                                                  // autoPlay: true,
                                                  enlargeCenterPage: true,
                                                  viewportFraction: 1,
                                                  // autoPlayInterval:
                                                  //     const Duration(seconds: 5),
                                                  disableCenter: true,
                                                  onPageChanged:
                                                      ((index, reason) {
                                                    Provider.of<BankAccountProvider>(
                                                            context,
                                                            listen: false)
                                                        .updateIndex(index);
                                                  }),
                                                ),
                                              ),
                                            ),
                                    ),
                                    (qrGenerateds.isEmpty)
                                        ? const SizedBox()
                                        : Container(
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
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                    // const Padding(padding: EdgeInsets.only(top: 10)),
                    // SizedBox(
                    //   width: width,
                    //   height: 40,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       ButtonIconWidget(
                    //         width: width * 0.2,
                    //         height: 40,
                    //         icon: Icons.print_rounded,
                    //         title: '',
                    //         function: () async {
                    //           int indexSelected =
                    //               Provider.of<BankAccountProvider>(context,
                    //                       listen: false)
                    //                   .indexSelected;

                    //           String userId =
                    //               UserInformationHelper.instance.getUserId();
                    //           BluetoothPrinterDTO bluetoothPrinterDTO =
                    //               await LocalDatabase.instance
                    //                   .getBluetoothPrinter(userId);
                    //           if (bluetoothPrinterDTO.id.isNotEmpty) {
                    //             bool isPrinting = false;
                    //             if (!isPrinting) {
                    //               isPrinting = true;
                    //               DialogWidget.instance
                    //                   .showFullModalBottomContent(
                    //                       widget: const PrintingView());
                    //               await PrinterUtils.instance
                    //                   .print(qrGenerateds[indexSelected])
                    //                   .then((value) {
                    //                 Navigator.pop(context);
                    //                 isPrinting = false;
                    //               });
                    //             }
                    //           } else {
                    //             DialogWidget.instance.openMsgDialog(
                    //                 title: 'Không thể in',
                    //                 msg:
                    //                     'Vui lòng kết nối với máy in để thực hiện việc in.');
                    //           }
                    //         },
                    //         bgColor: Theme.of(context).cardColor,
                    //         textColor: DefaultTheme.ORANGE,
                    //       ),
                    //       const Padding(
                    //         padding: EdgeInsets.only(left: 10),
                    //       ),
                    //       ButtonIconWidget(
                    //         width: width * 0.2,
                    //         height: 40,
                    //         icon: Icons.photo_rounded,
                    //         title: '',
                    //         function: () {
                    //           int indexSelected =
                    //               Provider.of<BankAccountProvider>(context,
                    //                       listen: false)
                    //                   .indexSelected;
                    //           Navigator.pushNamed(
                    //             context,
                    //             Routes.QR_SHARE_VIEW,
                    //             arguments: {
                    //               'qrGeneratedDTO': qrGenerateds[indexSelected],
                    //               'action': 'SAVE'
                    //             },
                    //           );
                    //         },
                    //         bgColor: Theme.of(context).cardColor,
                    //         textColor: DefaultTheme.RED_CALENDAR,
                    //       ),
                    //       const Padding(
                    //         padding: EdgeInsets.only(left: 10),
                    //       ),
                    //       ButtonIconWidget(
                    //         width: width * 0.2,
                    //         height: 40,
                    //         icon: Icons.copy_rounded,
                    //         title: '',
                    //         function: () async {
                    //           int indexSelected =
                    //               Provider.of<BankAccountProvider>(context,
                    //                       listen: false)
                    //                   .indexSelected;
                    //           await FlutterClipboard.copy(ShareUtils.instance
                    //                   .getTextSharing(
                    //                       qrGenerateds[indexSelected]))
                    //               .then(
                    //             (value) => Fluttertoast.showToast(
                    //               msg: 'Đã sao chép',
                    //               toastLength: Toast.LENGTH_SHORT,
                    //               gravity: ToastGravity.CENTER,
                    //               timeInSecForIosWeb: 1,
                    //               backgroundColor:
                    //                   Theme.of(context).primaryColor,
                    //               textColor: Theme.of(context).hintColor,
                    //               fontSize: 15,
                    //               webBgColor: 'rgba(255, 255, 255)',
                    //               webPosition: 'center',
                    //             ),
                    //           );
                    //         },
                    //         bgColor: Theme.of(context).cardColor,
                    //         textColor: DefaultTheme.BLUE_TEXT,
                    //       ),
                    //       const Padding(
                    //         padding: EdgeInsets.only(left: 10),
                    //       ),
                    //       ButtonIconWidget(
                    //         width: width * 0.2,
                    //         height: 40,
                    //         icon: Icons.share_rounded,
                    //         title: '',
                    //         function: () {
                    //           int indexSelected =
                    //               Provider.of<BankAccountProvider>(context,
                    //                       listen: false)
                    //                   .indexSelected;
                    //           Navigator.pushNamed(
                    //             context,
                    //             Routes.QR_SHARE_VIEW,
                    //             arguments: {
                    //               'qrGeneratedDTO': qrGenerateds[indexSelected],
                    //             },
                    //           );
                    //         },
                    //         bgColor: Theme.of(context).cardColor,
                    //         textColor: DefaultTheme.GREEN,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const Padding(
                    //   padding: EdgeInsets.only(top: 10),
                    // ),
                    // SizedBox(
                    //   width: width,
                    //   height: 40,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       ButtonIconWidget(
                    //         width: width * 0.4 + 10,
                    //         height: 40,
                    //         icon: Icons.add_rounded,
                    //         title: 'QR giao dịch',
                    //         function: () {
                    //           if (bankAccounts.isNotEmpty &&
                    //               qrGenerateds.isNotEmpty) {
                    //             Navigator.of(context)
                    //                 .push(
                    //               MaterialPageRoute(
                    //                 builder: (context) => CreateQR(
                    //                   bankAccountDTO: bankAccounts[
                    //                       Provider.of<BankAccountProvider>(
                    //                               context,
                    //                               listen: false)
                    //                           .indexSelected],
                    //                 ),
                    //               ),
                    //             )
                    //                 .then((value) {
                    //               String userId = UserInformationHelper.instance
                    //                   .getUserId();
                    //               businessInformationBloc.add(
                    //                 BusinessInformationEventGetList(
                    //                     userId: userId),
                    //               );
                    //             });
                    //           } else {
                    //             DialogWidget.instance.openMsgDialog(
                    //                 title: 'Không thể tạo mã QR thanh toán',
                    //                 msg:
                    //                     'Thêm tài khoản ngân hàng để sử dụng chức năng này.');
                    //           }
                    //         },
                    //         textColor: DefaultTheme.WHITE,
                    //         bgColor: DefaultTheme.GREEN,
                    //       ),
                    //       const Padding(padding: EdgeInsets.only(left: 10)),
                    //       ButtonIconWidget(
                    //         width: width * 0.4 + 10,
                    //         height: 40,
                    //         icon: Icons.add_rounded,
                    //         title: 'TK ngân hàng',
                    //         function: () {
                    //           if (bankAccounts.isNotEmpty &&
                    //               qrGenerateds.isNotEmpty) {
                    //             Navigator.of(context)
                    //                 .push(
                    //               MaterialPageRoute(
                    //                 builder: (context) => CreateQR(
                    //                   bankAccountDTO: bankAccounts[
                    //                       Provider.of<BankAccountProvider>(
                    //                               context,
                    //                               listen: false)
                    //                           .indexSelected],
                    //                 ),
                    //               ),
                    //             )
                    //                 .then((value) {
                    //               String userId = UserInformationHelper.instance
                    //                   .getUserId();
                    //               businessInformationBloc.add(
                    //                 BusinessInformationEventGetList(
                    //                     userId: userId),
                    //               );
                    //             });
                    //           } else {
                    //             DialogWidget.instance.openMsgDialog(
                    //                 title: 'Không thể tạo mã QR thanh toán',
                    //                 msg:
                    //                     'Thêm tài khoản ngân hàng để sử dụng chức năng này.');
                    //           }
                    //         },
                    //         textColor: DefaultTheme.WHITE,
                    //         bgColor: DefaultTheme.GREEN,
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    Padding(
                      padding: EdgeInsets.only(
                        bottom: (PlatformUtils.instance.isAndroidApp())
                            ? 90
                            : (PlatformUtils.instance.isIOsApp() &&
                                    height <= 800)
                                ? 70
                                : 110,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget buildList(double maxListHeight, List<BankAccountDTO> banks,
      List<Color> colors, double listHeight, double sizeBox) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: StackedList(
        maxListHeight: maxListHeight,
        list: banks,
        colors: colors,
        scrollController: scrollController,
        height: listHeight,
        sizeBox: sizeBox,
      ),
    );
  }

  void getListBank(BuildContext context) {
    bankAccounts.clear();
    cardColors.clear();
    String userId = UserInformationHelper.instance.getUserId();
    bankCardBloc.add(
      BankCardEventGetList(
        userId: userId,
      ),
    );
  }

  void getListQR(BuildContext context, List<QRCreateDTO> list) {
    qrGenerateds.clear();
    qrBloc.add(QREventGenerateList(list: list));
  }

  void addQRWidget(double width, double height, List<QRGeneratedDTO> list) {
    if (qrGenerateds.isEmpty) {
      qrGenerateds.addAll(list);
      if (qrGenerateds.isNotEmpty) {
        for (int i = 0; i < qrGenerateds.length; i++) {
          final Widget qrWidget = UnconstrainedBox(
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
            ? Border.all(color: DefaultTheme.GREY_LIGHT, width: 0.5)
            : null,
        color: (isSelected) ? DefaultTheme.WHITE : DefaultTheme.GREY_LIGHT,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  void resetProvider(BuildContext context) {
    bankAccounts.clear();
    cardColors.clear();
    Provider.of<BankCardSelectProvider>(context, listen: false).reset();
  }
}

class StackedList extends StatefulWidget {
  final double maxListHeight;
  final List<BankAccountDTO> list;
  final List<Color> colors;
  final ScrollController scrollController;
  final double sizeBox;
  final double height;

  const StackedList({
    super.key,
    required this.maxListHeight,
    required this.list,
    required this.colors,
    required this.scrollController,
    required this.sizeBox,
    required this.height,
  });

  @override
  State<StatefulWidget> createState() => _StackedList();
}

class _StackedList extends State<StackedList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    // final double sizedBox = (widget.list.length * _maxHeight) * 0.75;
    // final double height = (sizedBox < _maxHeight)
    //     ? _maxHeight
    //     : (sizedBox > widget.maxListHeight)
    //         ? widget.maxListHeight
    //         : sizedBox;
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
                    const Text('Chưa có tài khoản ngân hàng được thêm.'),
                  ]),
                ),
              )
            : (widget.sizeBox <= widget.height)
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: SizedBox(
                      height: widget.height,
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
                              ),
                            );
                          },
                        ).toList(),
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
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                  ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        SizedBox(
          width: width,
          child: Row(
            children: [
              BoxLayout(
                width: width / 2 - 15,
                height: 40,
                bgColor: Theme.of(context).buttonColor,
                borderRadius: 5,
                enableShadow: true,
                child: InkWell(
                  onTap: () {
                    Provider.of<AddBankProvider>(context, listen: false)
                        .updateSelect(1);
                    Navigator.pushNamed(context, Routes.ADD_BANK_CARD,
                        arguments: {'pageIndex': 1});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add_rounded,
                        size: 15,
                        color: DefaultTheme.GREEN,
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Text(
                        'TK ngân hàng',
                        style: TextStyle(
                          color: DefaultTheme.GREEN,
                        ),
                      )
                    ],
                  ),
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
                  onTap: () {
                    if (QRScannerHelper.instance.getQrIntro()) {
                      Navigator.pushNamed(context, Routes.SCAN_QR_VIEW);
                    } else {
                      DialogWidget.instance.showFullModalBottomContent(
                        widget: const QRScanWidget(),
                        color: DefaultTheme.BLACK,
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.qr_code_scanner_rounded,
                        size: 15,
                        color: DefaultTheme.BLUE_TEXT,
                      ),
                      Padding(padding: EdgeInsets.only(left: 5)),
                      Text(
                        'Quét mã QR',
                        style: TextStyle(
                          color: DefaultTheme.BLUE_TEXT,
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

  Widget _buildCardItem(
      {required BuildContext context,
      required int index,
      required BankAccountDTO dto}) {
    final double width = MediaQuery.of(context).size.width;
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    });

    return (dto.id.isNotEmpty)
        ? InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.BANK_CARD_DETAIL_VEW,
                arguments: {
                  'bankId': dto.id,
                },
              );
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
                                color: DefaultTheme.WHITE,
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
                                color: DefaultTheme.WHITE,
                              ),
                            ),
                          ),
                          if (dto.isAuthenticated)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                color: DefaultTheme.GREEN,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: DefaultTheme.WHITE,
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
                                  style: const TextStyle(
                                    color: DefaultTheme.WHITE,
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
                                    color: DefaultTheme.WHITE,
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
                                    color: DefaultTheme.WHITE,
                                    size: 15,
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 5)),
                                  Text(
                                    'Tạo QR',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: DefaultTheme.WHITE,
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
