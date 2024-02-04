import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:vierqr/features/dashboard/blocs/auth_provider.dart';
import 'package:vierqr/features/dashboard/widget/background_app_bar_home.dart';
import 'package:vierqr/features/trans_history/trans_history_screen.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/confirm_otp_bank_dto.dart';
import 'package:vierqr/models/qr_bank_detail.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import '../../services/providers/account_bank_detail_provider.dart';
import 'states/bank_card_state.dart';

class BankCardDetailScreen extends StatelessWidget {
  final String bankId;

  static String routeName = '/bank_card_detail_screen';

  const BankCardDetailScreen({super.key, required this.bankId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BankCardBloc>(
      create: (BuildContext context) => BankCardBloc(bankId),
      child: const BankCardDetailState(),
    );
  }
}

class BankCardDetailState extends StatefulWidget {
  const BankCardDetailState({super.key});

  @override
  State<BankCardDetailState> createState() => _BankCardDetailState();
}

class _BankCardDetailState extends State<BankCardDetailState> {
  late BankCardBloc bankCardBloc;
  final ScrollController controllerTabar = ScrollController();
  List<String> listTitle = [
    'Thông tin',
    'Thống kê',
    'Giao dịch',
    'Chia sẻ BĐSD'
  ];
  List<String> listTitle1 = [
    'Thông tin',
    'Thống kê',
    'Giao dịch',
  ];
  final PageController pageController = PageController();
  String userId = UserHelper.instance.getUserId();
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
  final otpController = TextEditingController();

  Future<void> _refresh() async {
    bankCardBloc.add(const BankCardGetDetailEvent());
  }

  void initData(BuildContext context) {
    bankCardBloc.add(const BankCardGetDetailEvent());
  }

  @override
  void initState() {
    super.initState();
    bankCardBloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData(context);
    });
  }

  _handleBack() {
    eventBus.fire(GetListBankScreen());
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
      body: ChangeNotifierProvider(
        create: (_) => AccountBankDetailProvider(),
        child: Consumer<AccountBankDetailProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder<bool>(
                      stream: notificationController.stream,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
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

                            if (state.request == BankDetailType.UN_LINK) {
                              showDialog(
                                barrierDismissible: false,
                                context: NavigationService
                                    .navigatorKey.currentContext!,
                                builder: (BuildContext context) {
                                  return DialogOTPView(
                                    phone: dto.phoneAuthenticated,
                                    onResend: () {
                                      bankCardBloc.add(BankCardEventUnlink(
                                          accountNumber: dto.bankAccount));
                                    },
                                    onChangeOTP: (value) {
                                      otpController.value = otpController.value
                                          .copyWith(text: value);
                                    },
                                    onTap: () {
                                      ConfirmOTPBankDTO confirmDTO =
                                          ConfirmOTPBankDTO(
                                        requestId: state.requestId ?? '',
                                        otpValue: otpController.text,
                                        applicationType: 'MOBILE',
                                        bankAccount:
                                            state.bankDetailDTO?.bankAccount,
                                      );
                                      bankCardBloc.add(
                                          BankCardEventUnConfirmOTP(
                                              dto: confirmDTO));
                                    },
                                  );
                                },
                              );
                            }

                            if (state.request == BankDetailType.OTP) {
                              Navigator.of(context).pop();
                              bankCardBloc.add(const BankCardGetDetailEvent());
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
                              if (dto.userId !=
                                  UserHelper.instance.getUserId()) {
                                listTitle.removeLast();
                              }
                              if (AppDataHelper.instance
                                  .checkExitsBankAccount(dto.bankAccount)) {
                                QRDetailBank qrDetail = AppDataHelper.instance
                                    .getQrcodeByBankAccount(dto.bankAccount);
                                if (qrDetail.money.isNotEmpty &&
                                    qrDetail.money != '0') {
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
                                AppDataHelper.instance
                                    .addListQRDetailBank(qrDetailBank);
                              }
                            }
                            if (state.request == BankDetailType.ERROR) {
                              await DialogWidget.instance.openMsgDialog(
                                title: 'Không thể xoá tài khoản',
                                msg: state.msg ?? '',
                              );
                            }

                            if (state.status != BlocStatus.NONE ||
                                state.request != BankDetailType.NONE) {
                              bankCardBloc.add(UpdateEvent());
                            }
                          },
                          builder: (context, state) {
                            if (state.bankDetailDTO == null) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    controller: controllerTabar,
                                    child: Row(
                                      children: listTitle.map((title) {
                                        int index = listTitle.indexOf(title);
                                        return GestureDetector(
                                          onTap: () {
                                            pageController.jumpToPage(index);
                                            provider.changeCurrentPage(index);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 6),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color:
                                                  index == provider.currentPage
                                                      ? AppColor.BLUE_TEXT
                                                          .withOpacity(0.3)
                                                      : AppColor.TRANSPARENT,
                                            ),
                                            child: Text(
                                              title,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: index ==
                                                          provider.currentPage
                                                      ? AppColor.BLUE_TEXT
                                                      : AppColor.BLACK),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Expanded(
                                  child: PageView(
                                    controller: pageController,
                                    onPageChanged: (index) {
                                      if (index == 3) {
                                        controllerTabar.animateTo(
                                          controllerTabar
                                              .position.maxScrollExtent,
                                          curve: Curves.easeOut,
                                          duration:
                                              const Duration(milliseconds: 300),
                                        );
                                      } else if (index == 0) {
                                        controllerTabar.animateTo(
                                          controllerTabar
                                              .position.minScrollExtent,
                                          curve: Curves.easeOut,
                                          duration:
                                              const Duration(milliseconds: 300),
                                        );
                                      }
                                      provider.changeCurrentPage(index);
                                    },
                                    children: [
                                      InfoDetailBankAccount(
                                        bloc: bankCardBloc,
                                        refresh: _refresh,
                                        dto: dto,
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
                                          data['userBankName'] =
                                              dto.userBankName;
                                          data['bankCode'] = dto.bankCode;
                                          data['amount'] = qrBankDetail.money
                                              .replaceAll(',', '');
                                          data['content'] = StringUtils.instance
                                              .removeDiacritic(
                                                  qrBankDetail.content);
                                          bankCardBloc.add(
                                              BankCardGenerateDetailQR(
                                                  dto: data));
                                        },
                                      ),
                                      Statistical(bankId: state.bankId ?? ''),
                                      TransHistoryScreen(
                                          bankId: state.bankId ?? ''),
                                      if (dto.userId ==
                                          UserHelper.instance.getUserId())
                                        ShareBDSDPage(
                                          bankId: state.bankId ?? '',
                                          dto: dto,
                                          bloc: bankCardBloc,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Consumer<AuthProvider>(builder: (context, page, child) {
      return BackgroundAppBarHome(
        file: page.file,
        url: page.settingDTO.themeImgUrl,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                    )),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Center(
                    child: Text(
                      'Chi tiết TK ngân hàng',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Container(
                  width: 60,
                  height: 50,
                  margin: const EdgeInsets.only(right: 20),
                  child: CachedNetworkImage(
                    imageUrl: page.settingDTO.logoUrl,
                    height: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
