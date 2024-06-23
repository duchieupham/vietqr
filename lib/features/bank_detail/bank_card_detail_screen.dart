import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/helper/app_data_helper.dart';
import 'package:vierqr/commons/mixin/events.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/page/info_page.dart';
import 'package:vierqr/features/bank_detail/page/share_bdsd_page.dart';
import 'package:vierqr/features/bank_detail/page/statistical_page.dart';
import 'package:vierqr/features/bank_detail/views/dialog_otp.dart';
import 'package:vierqr/features/trans_history/trans_history_screen.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/confirm_otp_bank_dto.dart';
import 'package:vierqr/models/qr_bank_detail.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/models/terminal_response_dto.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

import '../../services/providers/account_bank_detail_provider.dart';
import 'states/bank_card_state.dart';

class BankCardDetailScreen extends StatelessWidget {
  final String bankId;
  final int pageIndex;
  final bool isLoading;

  static String routeName = '/bank_card_detail_screen';

  const BankCardDetailScreen({
    super.key,
    required this.bankId,
    this.pageIndex = 0,
    this.isLoading = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BankCardBloc>(
      create: (BuildContext context) =>
          BankCardBloc(bankId, isLoading: isLoading),
      child: ChangeNotifierProvider(
          create: (_) => AccountBankDetailProvider(),
          child: BankCardDetailState(pageIndex: pageIndex)),
    );
  }
}

class BankCardDetailState extends StatefulWidget {
  final int pageIndex;

  const BankCardDetailState({super.key, this.pageIndex = 0});

  @override
  State<BankCardDetailState> createState() => _BankCardDetailState();
}

class _BankCardDetailState extends State<BankCardDetailState> {
  late BankCardBloc bankCardBloc;
  final ScrollController controllerTabBar = ScrollController();
  List<String> listTitle = [
    'Thông tin',
    'Giao dịch',
    'Thống kê',
    'Chia sẻ BĐSD'
  ];

  late PageController pageController;

  String get userId => SharePrefUtils.getProfile().userId;
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

  void initData(BuildContext context) {
    bankCardBloc
        .add(const BankCardGetDetailEvent(isLoading: true, isInit: true));
    bankCardBloc.add(GetMyListGroupEvent(userID: userId, offset: 0));
    bankCardBloc.add(GetMerchantEvent());
  }

  @override
  void initState() {
    super.initState();
    bankCardBloc = BlocProvider.of(context);
    _provider = Provider.of<AccountBankDetailProvider>(context, listen: false);
    pageController =
        PageController(initialPage: widget.pageIndex, keepPage: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
    });
  }

  _handleBack() {
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        title: 'Chi tiết TK ngân hàng',
        onPressed: _handleBack,
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
                _onShowDialogRequestOTP(
                    state.requestId ?? '',
                    state.bankDetailDTO?.bankAccount ?? '',
                    state.bankDetailDTO);
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
                if (widget.pageIndex != 0) {
                  _provider.changeCurrentPage(widget.pageIndex);
                  pageController.jumpToPage(widget.pageIndex);
                }

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
                return Center(child: CircularProgressIndicator());
              }
              return Consumer<AccountBankDetailProvider>(
                builder: (context, provider, _) {
                  final width = MediaQuery.of(context).size.width;
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width < 400 ? 4 : 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (listTitle.length == 3) const Spacer(),
                                  ...listTitle.map((title) {
                                    int index = listTitle.indexOf(title);
                                    return GestureDetector(
                                      onTap: () {
                                        pageController.jumpToPage(index);
                                        provider.changeCurrentPage(index);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: index == provider.currentPage
                                              ? AppColor.BLUE_TEXT
                                                  .withOpacity(0.3)
                                              : AppColor.TRANSPARENT,
                                        ),
                                        child: Text(
                                          title,
                                          maxLines: 1,
                                          style: TextStyle(
                                              color:
                                                  index == provider.currentPage
                                                      ? AppColor.BLUE_TEXT
                                                      : AppColor.BLACK),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  if (listTitle.length == 3) const Spacer(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: PageView(
                                controller: pageController,
                                physics: AlwaysScrollableScrollPhysics(),
                                onPageChanged: provider.changeCurrentPage,
                                children: [
                                  InfoDetailBankAccount(
                                    bloc: bankCardBloc,
                                    refresh: _refresh,
                                    dto: dto,
                                    isRegisterMerchant:
                                        state.isRegisterMerchant,
                                    merchantDTO: state.merchantDTO,
                                    qrGeneratedDTO: qrGeneratedDTO,
                                    bankId: state.bankId ?? '',
                                    onChangePage: () {
                                      provider.changeCurrentPage(2);
                                      pageController.jumpToPage(2);
                                    },
                                    onChangePageThongKe: () {
                                      provider.changeCurrentPage(1);
                                      pageController.jumpToPage(1);
                                    },
                                    updateQRGeneratedDTO: (qrBankDetail) {
                                      Map<String, dynamic> data = {};
                                      data['bankAccount'] = dto.bankAccount;
                                      data['userBankName'] = dto.userBankName;
                                      data['bankCode'] = dto.bankCode;
                                      data['amount'] = qrBankDetail.money
                                          .replaceAll(',', '');
                                      data['content'] = StringUtils.instance
                                          .removeDiacritic(
                                              qrBankDetail.content);
                                      bankCardBloc.add(
                                          BankCardGenerateDetailQR(dto: data));
                                    },
                                  ),
                                  TransHistoryScreen(
                                    bankUserId: dto.userId,
                                    bankId: state.bankId ?? '',
                                    // terminalDto: state.terminalDto ??
                                    //     TerminalDto(terminals: []),
                                    terminalAccountList: listTerminalAcc ?? [],
                                  ),
                                  StatisticalScreen(
                                    bankId: state.bankId ?? '',
                                    terminalDto: state.terminalDto,
                                    bankDetailDTO: state.bankDetailDTO,
                                  ),
                                  if (!dto.isHideBDSD)
                                    ShareBDSDPage(
                                      bankId: state.bankId ?? '',
                                      dto: dto,
                                      bloc: bankCardBloc,
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
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

  void _onShowDialogRequestOTP(
      String requestId, String bankAccount, AccountBankDetailDTO? dto) {
    showDialog(
      barrierDismissible: false,
      context: NavigationService.context!,
      builder: (BuildContext context) {
        return DialogOTPView(
          phone: dto?.phoneAuthenticated ?? '',
          onResend: () {
            Navigator.pop(context);
            bankCardBloc.add(BankCardEventUnRequestOTP(
                accountNumber: dto?.bankAccount ?? ''));
          },
          onChangeOTP: (value) {
            otpController.value = otpController.value.copyWith(text: value);
          },
          onTap: () {
            if (dto!.bankCode.contains('BIDV')) {
              ConfirmOTPUnlinkTypeBankDTO confirmDTO =
              ConfirmOTPUnlinkTypeBankDTO(
                  ewalletToken: '',
                  bankAccount: bankAccount,
                  bankCode: dto.bankCode);
              bankCardBloc.add(BankCardEventUnConfirmOTP(
                  dto: confirmDTO, unlinkType: dto.unlinkedType));
            } else {
              ConfirmOTPBankDTO confirmDTO = ConfirmOTPBankDTO(
                requestId: requestId,
                otpValue: otpController.text,
                applicationType: 'MOBILE',
                bankAccount: bankAccount,
              );
              bankCardBloc.add(BankCardEventUnConfirmOTP(
                  dto: confirmDTO, unlinkType: dto.unlinkedType));
            }
          },
        );
      },
    );
  }
}
