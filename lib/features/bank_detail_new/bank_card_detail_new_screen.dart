import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/helper/app_data_helper.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/image_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/measure_size.dart';
import 'package:vierqr/commons/widgets/widget_qr.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/states/bank_card_state.dart';
import 'package:vierqr/features/bank_detail_new/widgets/bank_card_detail_app_bar.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/qr_bank_detail.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/account_bank_detail_provider.dart';

class BankCardDetailNewScreen extends StatelessWidget {
  final String bankId;
  final bool isLoading;

  static String routeName = '/bank_card_detail_screen';
  const BankCardDetailNewScreen({
    super.key,
    required this.bankId,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BankCardBloc>(
      create: (BuildContext context) =>
          BankCardBloc(bankId, isLoading: isLoading),
      child: ChangeNotifierProvider(
          create: (_) => AccountBankDetailProvider(),
          child: BankCardDetailNewState()),
    );
  }
}

class BankCardDetailNewState extends StatefulWidget {
  const BankCardDetailNewState({super.key});

  @override
  State<BankCardDetailNewState> createState() => _BankCardDetailNewStateState();
}

class _BankCardDetailNewStateState extends State<BankCardDetailNewState> {
  String get userId => SharePrefUtils.getProfile().userId;
  late BankCardBloc bankCardBloc;
  late QRGeneratedDTO qrGeneratedDTO = QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '');
  late AccountBankDetailDTO dto = AccountBankDetailDTO();
  late List<TerminalAccountDTO> listTerminalAcc = [];
  final otpController = TextEditingController();
  late AccountBankDetailProvider _provider;
  List<String> listTitle = [
    'Chi tiết',
    'Giao dịch',
    'Thống kê',
  ];
  int _selectedIndex = 0;

  Future<void> _refresh() async {
    bankCardBloc.add(const BankCardGetDetailEvent());
    bankCardBloc.add(GetMyListGroupEvent(userID: userId, offset: 0));
  }

  void initData(BuildContext context) {
    bankCardBloc
        .add(const BankCardGetDetailEvent(isLoading: true, isInit: true));
    bankCardBloc.add(GetMyListGroupEvent(userID: userId, offset: 0));
    bankCardBloc.add(GetMerchantEvent());
  }

  ValueNotifier<double> heightNotifier = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    bankCardBloc = BlocProvider.of(context);
    _provider = Provider.of<AccountBankDetailProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 100,
        color: AppColor.BLACK,
        child: Text(
          'bottom ne',
          style: TextStyle(color: AppColor.WHITE),
        ),
      ),
      body: StreamBuilder<bool>(
        stream: notificationController.stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              bankCardBloc.add(const BankCardGetDetailEvent());
            }
          }
          return BlocConsumer<BankCardBloc, BankCardState>(
            listener: (context, state) async {
              if (state.status == BlocStatus.LOADING) {
                DialogWidget.instance.openLoadingDialog();
              }

              if (state.status == BlocStatus.UNLOADING) {
                Navigator.pop(context);
              }

              if (state.request == BankDetailType.UN_LINK_BIDV) {
                eventBus.fire(GetListBankScreen());
                bankCardBloc.add(const BankCardGetDetailEvent());
              }
              if (state.request == BankDetailType.REQUEST_OTP) {
                // _onShowDialogRequestOTP(
                //     state.requestId ?? '',
                //     state.bankDetailDTO?.bankAccount ?? '',
                //     state.bankDetailDTO);
              }

              if (state.request == BankDetailType.OTP) {
                Navigator.of(context).pop();
                bankCardBloc.add(const BankCardGetDetailEvent());
                eventBus.fire(GetListBankScreen());
              }

              if (state.request == BankDetailType.DELETED) {
                eventBus.fire(GetListBankScreen());
                Fluttertoast.showToast(
                  msg: 'Đã xoá TK ngân hàng',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Theme.of(context).hintColor,
                  fontSize: 15,
                );

                Navigator.pop(context, true);
              }

              if (state.request == BankDetailType.SUCCESS) {
                if (state.bankDetailDTO != null) {
                  dto = state.bankDetailDTO!;
                }

                if (dto.isHideBDSD && state.isInit) listTitle.removeLast();
                // if (widget.pageIndex != 0) {
                //   _provider.changeCurrentPage(widget.pageIndex);
                //   pageController.jumpToPage(widget.pageIndex);
                // }

                if (AppDataHelper.instance
                    .checkExitsBankAccount(dto.bankAccount)) {
                  QRDetailBank qrDetail = AppDataHelper.instance
                      .getQrcodeByBankAccount(dto.bankAccount);
                  if (qrDetail.money.isNotEmpty && qrDetail.money != '0') {
                    qrGeneratedDTO = QRGeneratedDTO(
                      bankCode: dto.bankCode,
                      bankName: dto.bankName,
                      bankAccount: dto.bankAccount,
                      userBankName: dto.userBankName,
                      amount: qrDetail.money,
                      content: qrDetail.content,
                      qrCode: qrDetail.qrCode,
                      imgId: dto.imgId,
                    );
                  } else {
                    qrGeneratedDTO = QRGeneratedDTO(
                      bankCode: dto.bankCode,
                      bankName: dto.bankName,
                      bankAccount: dto.bankAccount,
                      userBankName: dto.userBankName,
                      amount: '',
                      content: '',
                      qrCode: dto.qrCode,
                      imgId: dto.imgId,
                    );
                  }
                } else {
                  qrGeneratedDTO = QRGeneratedDTO(
                    bankCode: dto.bankCode,
                    bankName: dto.bankName,
                    bankAccount: dto.bankAccount,
                    userBankName: dto.userBankName,
                    amount: '',
                    content: '',
                    qrCode: dto.qrCode,
                    imgId: dto.imgId,
                  );
                }
              }
              if (state.request == BankDetailType.GET_LIST_GROUP) {
                if (state.terminalAccountDto != null) {
                  listTerminalAcc = state.terminalAccountDto!;
                }
              }

              if (state.request == BankDetailType.CREATE_QR) {
                Navigator.of(context).pop();
                if (state.qrGeneratedDTO!.amount.isNotEmpty &&
                    state.qrGeneratedDTO!.amount != '0') {
                  qrGeneratedDTO = state.qrGeneratedDTO!;

                  QRDetailBank qrDetailBank = QRDetailBank(
                      money: qrGeneratedDTO.amount,
                      content: qrGeneratedDTO.content,
                      qrCode: qrGeneratedDTO.qrCode,
                      bankAccount: qrGeneratedDTO.bankAccount);
                  AppDataHelper.instance.addListQRDetailBank(qrDetailBank);
                }
              }
              if (state.request == BankDetailType.ERROR) {
                await DialogWidget.instance.openMsgDialog(
                  title: 'Thông báo',
                  msg: state.msg ?? '',
                );
              }
            },
            builder: (context, state) {
              if (state.status == BlocStatus.LOADING_PAGE) {
                return const Center(child: CircularProgressIndicator());
              }
              return Consumer<AccountBankDetailProvider>(
                builder: (context, provider, _) {
                  final width = MediaQuery.of(context).size.width;
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 150,
                    // decoration: const BoxDecoration(
                    //   gradient: LinearGradient(
                    //     colors: [
                    //       Color(0xFFE1EFFF),
                    //       Color(0xFFE5F9FF),
                    //     ],
                    //     begin: Alignment.centerLeft,
                    //     end: Alignment.centerRight,
                    //   ),
                    // ),
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          padding: const EdgeInsets.only(top: 50, bottom: 0),
                          // color: AppColor.TRANSPARENT,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFE1EFFF),
                                Color(0xFFE5F9FF),
                              ],
                              end: Alignment.centerRight,
                              begin: Alignment.centerLeft,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                ),
                              ),
                              // Spacer(),
                              const SizedBox(
                                width: 10,
                              ),
                              ...listTitle.map(
                                (title) {
                                  int index = listTitle.indexOf(title);
                                  bool isSelected = _selectedIndex == index;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedIndex = index;
                                      });
                                      print(title);
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 80,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 4),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: isSelected
                                            ? const LinearGradient(
                                                colors: [
                                                  Color(0xFF00C6FF),
                                                  Color(0xFF0072FF),
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                            : null,
                                      ),
                                      child: Text(
                                        title,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : AppColor.GREY_TEXT,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            // height: 200,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFE1EFFF),
                                  Color(0xFFE5F9FF),
                                ],
                                end: Alignment.centerRight,
                                begin: Alignment.centerLeft,
                              ),
                            ),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  child: Stack(
                                    children: [
                                      ValueListenableBuilder<double>(
                                        valueListenable: heightNotifier,
                                        builder: (context, value, child) {
                                          return Column(
                                            children: [
                                              const SizedBox(height: 200),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xFFE1EFFF),
                                                      Color(0xFFE5F9FF),
                                                    ],
                                                    end: Alignment.centerRight,
                                                    begin: Alignment.centerLeft,
                                                  ),
                                                ),
                                                child: Container(
                                                  width: double.infinity,
                                                  height: value,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(30),
                                                      topRight:
                                                          Radius.circular(30),
                                                    ),
                                                    color: AppColor.WHITE
                                                        .withOpacity(0.6),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Column(
                                          children: [
                                            Container(
                                              // width: 320,
                                              margin: const EdgeInsets.fromLTRB(
                                                  30, 0, 30, 0),
                                              height: 400,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: AppColor.WHITE,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    spreadRadius: 1,
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10),
                                                    width: double.infinity,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          height: 40,
                                                          width: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: AppColor
                                                                .TRANSPARENT,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                qrGeneratedDTO
                                                                    .userBankName,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                qrGeneratedDTO
                                                                    .bankAccount,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            FlutterClipboard.copy(
                                                                    '${qrGeneratedDTO.userBankName}\n${qrGeneratedDTO.bankAccount}')
                                                                .then(
                                                              (value) =>
                                                                  Fluttertoast
                                                                      .showToast(
                                                                msg:
                                                                    'Đã sao chép',
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                textColor: Theme.of(
                                                                        context)
                                                                    .hintColor,
                                                                fontSize: 15,
                                                                webBgColor:
                                                                    'rgba(255, 255, 255, 0.5)',
                                                                webPosition:
                                                                    'center',
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            height: 30,
                                                            width: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              color: AppColor
                                                                  .GREY_F0F4FA,
                                                            ),
                                                            child: const XImage(
                                                              imagePath:
                                                                  'assets/images/ic-save-blue.png',
                                                              width: 30,
                                                              height: 30,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Container(
                                                    height: 250,
                                                    width: 250,
                                                    child: QrImageView(
                                                      padding: EdgeInsets.zero,
                                                      data:
                                                          qrGeneratedDTO.qrCode,
                                                      size: 80,
                                                      backgroundColor:
                                                          AppColor.WHITE,
                                                      embeddedImage: AssetImage(
                                                          'assets/images/ic-viet-qr-small.png'),
                                                      embeddedImageStyle:
                                                          const QrEmbeddedImageStyle(
                                                        size: Size(30, 30),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const SizedBox(width: 30),
                                                      Image.asset(
                                                          'assets/images/logo_vietgr_payment.png',
                                                          height: 40),
                                                      Image.asset(
                                                          'assets/images/ic-napas247.png',
                                                          height: 40),
                                                      const SizedBox(width: 30),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20),
                                                ],
                                              ),
                                            ),
                                            MeasureSize(
                                              onChange: (size) {
                                                final widgetHeight =
                                                    size.height;
                                                // double calculateHeight =
                                                //     constraints.maxHeight - 200;

                                                double itemheight =
                                                    constraints.maxHeight - 400;

                                                if (itemheight > widgetHeight) {
                                                  heightNotifier.value =
                                                      constraints.maxHeight -
                                                          200;
                                                } else if (itemheight <=
                                                    widgetHeight) {
                                                  heightNotifier.value =
                                                      (constraints.maxHeight -
                                                              200) +
                                                          (widgetHeight -
                                                              itemheight);
                                                }
                                                // heightNotifier.value =
                                                //     calculateHeight;
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 30),
                                                child: Column(
                                                  children: [
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Container(
                                                            height: 40,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100),
                                                              gradient:
                                                                  const LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xFFE1EFFF),
                                                                  Color(
                                                                      0xFFE5F9FF),
                                                                ],
                                                                begin: Alignment
                                                                    .centerLeft,
                                                                end: Alignment
                                                                    .centerRight,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image(
                                                                  height: 30,
                                                                  image: AssetImage(
                                                                      'assets/images/ic-add-money-content.png'),
                                                                ),
                                                                Text(
                                                                  'Thêm số tiền và nội dung',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          height: 40,
                                                          width: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            gradient:
                                                                const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                    0xFFE1EFFF),
                                                                Color(
                                                                    0xFFE5F9FF),
                                                              ],
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                            ),
                                                          ),
                                                          child: const Image(
                                                            image: AssetImage(
                                                                'assets/images/ic-effect.png'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

//////////////////////////

                        // Expanded(
                        //   child: Stack(
                        //     // fit: StackFit.expand,
                        //     children: [
                        //       Positioned.fill(
                        //         child: Container(
                        //           width: double.infinity,
                        //           // height: constraints.maxHeight,
                        //           decoration: BoxDecoration(
                        //             borderRadius: const BorderRadius.only(
                        //               topLeft: Radius.circular(30),
                        //               topRight: Radius.circular(30),
                        //             ),
                        //             color: AppColor.WHITE.withOpacity(0.6),
                        //           ),
                        //           child: BackdropFilter(
                        //               filter: ImageFilter.blur(
                        //                   sigmaX: 25, sigmaY: 25)),
                        //         ),
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Align(
                        //             alignment: Alignment.center,
                        //             child: Stack(
                        //               children: [
                        //                 Column(
                        //                   children: [
                        //                     Container(
                        //                       // width: 320,
                        //                       margin: EdgeInsets.fromLTRB(
                        //                           30, 0, 30, 0),
                        //                       height: 400,
                        //                       decoration: BoxDecoration(
                        //                         color: AppColor.WHITE,
                        //                         boxShadow: [
                        //                           BoxShadow(
                        //                             color: Colors.grey
                        //                                 .withOpacity(0.4),
                        //                             spreadRadius: 2,
                        //                             blurRadius: 10,
                        //                             offset: const Offset(5, 5),
                        //                           ),
                        //                         ],
                        //                         borderRadius:
                        //                             BorderRadius.circular(15),
                        //                       ),
                        //                       child: Column(
                        //                         crossAxisAlignment:
                        //                             CrossAxisAlignment.center,
                        //                         mainAxisAlignment:
                        //                             MainAxisAlignment.start,
                        //                         children: [
                        //                           const SizedBox(height: 10),
                        //                           Container(
                        //                             padding: const EdgeInsets
                        //                                 .symmetric(
                        //                                 horizontal: 10),
                        //                             width: double.infinity,
                        //                             child: Row(
                        //                               mainAxisAlignment:
                        //                                   MainAxisAlignment
                        //                                       .spaceBetween,
                        //                               children: [
                        //                                 Container(
                        //                                   padding:
                        //                                       const EdgeInsets
                        //                                           .all(4),
                        //                                   height: 40,
                        //                                   width: 40,
                        //                                   decoration:
                        //                                       BoxDecoration(
                        //                                     borderRadius:
                        //                                         BorderRadius
                        //                                             .circular(
                        //                                                 100),
                        //                                     color: AppColor
                        //                                         .TRANSPARENT,
                        //                                   ),
                        //                                 ),
                        //                                 Expanded(
                        //                                   child: Column(
                        //                                     crossAxisAlignment:
                        //                                         CrossAxisAlignment
                        //                                             .center,
                        //                                     mainAxisAlignment:
                        //                                         MainAxisAlignment
                        //                                             .center,
                        //                                     children: [
                        //                                       Text(
                        //                                         qrGeneratedDTO
                        //                                             .userBankName,
                        //                                         style: const TextStyle(
                        //                                             fontSize:
                        //                                                 12,
                        //                                             fontWeight:
                        //                                                 FontWeight
                        //                                                     .bold),
                        //                                       ),
                        //                                       Text(
                        //                                         qrGeneratedDTO
                        //                                             .bankAccount,
                        //                                         overflow:
                        //                                             TextOverflow
                        //                                                 .ellipsis,
                        //                                         style:
                        //                                             const TextStyle(
                        //                                                 fontSize:
                        //                                                     12),
                        //                                       ),
                        //                                     ],
                        //                                   ),
                        //                                 ),
                        //                                 InkWell(
                        //                                   onTap: () {
                        //                                     FlutterClipboard.copy(
                        //                                             '${qrGeneratedDTO.userBankName}\n${qrGeneratedDTO.bankAccount}')
                        //                                         .then(
                        //                                       (value) =>
                        //                                           Fluttertoast
                        //                                               .showToast(
                        //                                         msg:
                        //                                             'Đã sao chép',
                        //                                         toastLength: Toast
                        //                                             .LENGTH_SHORT,
                        //                                         gravity:
                        //                                             ToastGravity
                        //                                                 .CENTER,
                        //                                         timeInSecForIosWeb:
                        //                                             1,
                        //                                         backgroundColor:
                        //                                             Theme.of(
                        //                                                     context)
                        //                                                 .primaryColor,
                        //                                         textColor: Theme.of(
                        //                                                 context)
                        //                                             .hintColor,
                        //                                         fontSize: 15,
                        //                                         webBgColor:
                        //                                             'rgba(255, 255, 255, 0.5)',
                        //                                         webPosition:
                        //                                             'center',
                        //                                       ),
                        //                                     );
                        //                                   },
                        //                                   child: Container(
                        //                                     padding:
                        //                                         const EdgeInsets
                        //                                             .all(4),
                        //                                     height: 30,
                        //                                     width: 30,
                        //                                     decoration:
                        //                                         BoxDecoration(
                        //                                       borderRadius:
                        //                                           BorderRadius
                        //                                               .circular(
                        //                                                   100),
                        //                                       color: AppColor
                        //                                           .GREY_F0F4FA,
                        //                                     ),
                        //                                     child: const XImage(
                        //                                       imagePath:
                        //                                           'assets/images/ic-save-blue.png',
                        //                                       width: 30,
                        //                                       height: 30,
                        //                                       fit: BoxFit.cover,
                        //                                     ),
                        //                                   ),
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                           ),
                        //                           const SizedBox(height: 12),
                        //                           Container(
                        //                             height: 250,
                        //                             width: 250,
                        //                             child: QrImageView(
                        //                               padding: EdgeInsets.zero,
                        //                               data:
                        //                                   qrGeneratedDTO.qrCode,
                        //                               size: 80,
                        //                               backgroundColor:
                        //                                   AppColor.WHITE,
                        //                               embeddedImage: AssetImage(
                        //                                   'assets/images/ic-viet-qr-small.png'),
                        //                               embeddedImageStyle:
                        //                                   const QrEmbeddedImageStyle(
                        //                                 size: Size(30, 30),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           const Spacer(),
                        //                           Row(
                        //                             mainAxisAlignment:
                        //                                 MainAxisAlignment
                        //                                     .spaceBetween,
                        //                             children: [
                        //                               const SizedBox(width: 30),
                        //                               Image.asset(
                        //                                   'assets/images/logo_vietgr_payment.png',
                        //                                   height: 40),
                        //                               Image.asset(
                        //                                   'assets/images/ic-napas247.png',
                        //                                   height: 40),
                        //                               const SizedBox(width: 30),
                        //                             ],
                        //                           ),
                        //                           const SizedBox(height: 20),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                     Container(
                        //                       height: 40,
                        //                       margin: EdgeInsets.symmetric(
                        //                           horizontal: 30, vertical: 20),
                        //                       child: Row(
                        //                         mainAxisAlignment:
                        //                             MainAxisAlignment
                        //                                 .spaceBetween,
                        //                         children: [
                        //                           Expanded(
                        //                             child: Container(
                        //                               height: 40,
                        //                               decoration: BoxDecoration(
                        //                                 borderRadius:
                        //                                     BorderRadius
                        //                                         .circular(100),
                        //                                 gradient:
                        //                                     const LinearGradient(
                        //                                   colors: [
                        //                                     Color(0xFFE1EFFF),
                        //                                     Color(0xFFE5F9FF),
                        //                                   ],
                        //                                   begin: Alignment
                        //                                       .centerLeft,
                        //                                   end: Alignment
                        //                                       .centerRight,
                        //                                 ),
                        //                               ),
                        //                               child: Row(
                        //                                 mainAxisAlignment:
                        //                                     MainAxisAlignment
                        //                                         .center,
                        //                                 crossAxisAlignment:
                        //                                     CrossAxisAlignment
                        //                                         .center,
                        //                                 children: [
                        //                                   Image(
                        //                                     height: 30,
                        //                                     image: AssetImage(
                        //                                         'assets/images/ic-add-money-content.png'),
                        //                                   ),
                        //                                   Text(
                        //                                     'Thêm số tiền và nội dung',
                        //                                     style: TextStyle(
                        //                                         fontSize: 13),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           const SizedBox(width: 12),
                        //                           Container(
                        //                             padding:
                        //                                 const EdgeInsets.all(4),
                        //                             height: 40,
                        //                             width: 40,
                        //                             decoration: BoxDecoration(
                        //                               borderRadius:
                        //                                   BorderRadius.circular(
                        //                                       100),
                        //                               gradient:
                        //                                   const LinearGradient(
                        //                                 colors: [
                        //                                   Color(0xFFE1EFFF),
                        //                                   Color(0xFFE5F9FF),
                        //                                 ],
                        //                                 begin: Alignment
                        //                                     .centerLeft,
                        //                                 end: Alignment
                        //                                     .centerRight,
                        //                               ),
                        //                             ),
                        //                             child: const Image(
                        //                               image: AssetImage(
                        //                                   'assets/images/ic-effect.png'),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       // decoration: BoxDecoration(
                        //                       //   gradient: LinearGradient(
                        //                       // colors: [
                        //                       //   Color(0xFFE1EFFF),
                        //                       //   Color(0xFFE5F9FF),
                        //                       // ],
                        //                       //     begin: Alignment.centerLeft,
                        //                       //     end: Alignment.centerRight,
                        //                       //   ),
                        //                       // ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
