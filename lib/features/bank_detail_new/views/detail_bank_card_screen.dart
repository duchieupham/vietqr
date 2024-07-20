import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/helper/app_data_helper.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/commons/widgets/measure_size.dart';
import 'package:vierqr/commons/widgets/repaint_boundary_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/states/bank_card_state.dart';
import 'package:vierqr/features/bank_detail_new/widgets/animation_graph_widget.dart';
import 'package:vierqr/features/bank_detail_new/widgets/bank_detail_appbar.dart';
import 'package:vierqr/features/bank_detail_new/widgets/option_widget.dart';
import 'package:vierqr/features/bank_detail_new/widgets/qr_widget.dart';
import 'package:vierqr/features/bank_detail_new/widgets/service_vietqr_widget.dart';
import 'package:vierqr/features/bank_detail_new/widgets/suggestion_widget.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/qr_bank_detail.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/account_bank_detail_provider.dart';

// ignore: must_be_immutable
class DetailBankCardScreen extends StatefulWidget {
  final String bankId;
  final bool isLoading;

  final int selectedIndex;
  final Function(int) onSelectTab;
  final Function(bool) onScroll;
  final GlobalKey globalKey;

  DetailBankCardScreen({
    super.key,
    required this.bankId,
    required this.selectedIndex,
    required this.onSelectTab,
    required this.onScroll,
    this.isLoading = true,
    required this.globalKey,
  });

  @override
  State<DetailBankCardScreen> createState() => _DetailBankCardScreenState();
}

class _DetailBankCardScreenState extends State<DetailBankCardScreen> {
  ValueNotifier<double> heightNotifier = ValueNotifier<double>(0.0);
  ValueNotifier<bool> isScrollToChart = ValueNotifier<bool>(false);

  ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);
  final GlobalKey _animatedBarKey = GlobalKey();

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

  Future<void> _refresh() async {
    bankCardBloc.add(const BankCardGetDetailEvent());
    bankCardBloc.add(GetMyListGroupEvent(userID: userId, offset: 0));
  }

  void initData(BuildContext context) async {
    scrollController.addListener(
      () {
        widget.onScroll(scrollController.offset == 0.0);
        final RenderBox renderBox =
            _animatedBarKey.currentContext?.findRenderObject() as RenderBox;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero);
          final size = renderBox.size;
          final scrollPosition = scrollController.position;
          isScrollToChart.value = position.dy >= scrollPosition.pixels &&
              position.dy <=
                  scrollPosition.pixels + scrollPosition.viewportDimension;
        }
      },
    );
    bankCardBloc
        .add(const BankCardGetDetailEvent(isLoading: true, isInit: true));
    // bankCardBloc.add(GetMyListGroupEvent(userID: userId, offset: 0));
    // bankCardBloc.add(GetMerchantEvent());
  }

  @override
  void initState() {
    super.initState();
    bankCardBloc = getIt.get<BankCardBloc>(
        param1: widget.bankId, param2: widget.isLoading);
    _provider = Provider.of<AccountBankDetailProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        initData(context);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            bankCardBloc.add(const BankCardGetDetailEvent());
          }
        }
        return BlocConsumer<BankCardBloc, BankCardState>(
          bloc: bankCardBloc,
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

              ///tắt BĐSD
              // if (dto.isHideBDSD && state.isInit) listTitle.removeLast();

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
            // if (state.status == BlocStatus.LOADING_PAGE) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            return Expanded(
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
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      child: Stack(
                        children: [
                          _buildExpandedWidget(),
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              qrGeneratedDTO.qrCode.isNotEmpty
                                  ? RepaintBoundaryWidget(
                                      globalKey: widget.globalKey,
                                      builder: (key) {
                                        return QrWidget(
                                          dto: qrGeneratedDTO,
                                        );
                                      },
                                    )
                                  : const QrLoadingWidget(),
                              MeasureSize(
                                onChange: (size) {
                                  final widgetHeight = size.height;

                                  double itemheight =
                                      constraints.maxHeight - 400;

                                  if (itemheight > widgetHeight) {
                                    heightNotifier.value =
                                        constraints.maxHeight - 200;
                                  } else if (itemheight <= widgetHeight) {
                                    heightNotifier.value =
                                        (constraints.maxHeight - 200) +
                                            (widgetHeight - itemheight);
                                  }
                                },
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0xFFE1EFFF),
                                                    Color(0xFFE5F9FF),
                                                  ],
                                                  begin: Alignment.centerLeft,
                                                  end: Alignment.centerRight,
                                                ),
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  print(
                                                      'them so tien va noi dung');
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image(
                                                      height: 30,
                                                      image: AssetImage(
                                                          'assets/images/ic-add-money-content.png'),
                                                    ),
                                                    Text(
                                                      'Thêm số tiền và nội dung',
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFFE1EFFF),
                                                  Color(0xFFE5F9FF),
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                            ),
                                            child: const Image(
                                              image: AssetImage(
                                                  'assets/images/ic-effect.png'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    SuggestionWidget(
                                      bloc: bankCardBloc,
                                      dto: dto,
                                    ),
                                    const SizedBox(height: 20),
                                    OptionWidget(
                                      bloc: bankCardBloc,
                                      bankId: state.bankId ?? '',
                                      dto: dto,
                                    ),
                                    const SizedBox(height: 20),
                                    const ServiceVietqrWidget(),
                                    const SizedBox(height: 20),
                                    AnimationGraphWidget(
                                      scrollNotifer: isScrollToChart,
                                      key: _animatedBarKey,
                                    ),
                                    const SizedBox(height: 120),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
      stream: notificationController.stream,
    );
  }

  Widget _buildExpandedWidget() {
    return ValueListenableBuilder<double>(
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
                height: value + 10,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: AppColor.WHITE.withOpacity(0.6),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
