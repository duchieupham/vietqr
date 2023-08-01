import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/enums/enum_type.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_detail/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_detail/events/bank_card_event.dart';
import 'package:vierqr/features/bank_detail/page/info_page.dart';
import 'package:vierqr/features/bank_detail/page/statistical_page.dart';
import 'package:vierqr/features/bank_detail/page/transaction_page.dart';
import 'package:vierqr/features/bank_detail/views/dialog_otp.dart';
import 'package:vierqr/layouts/m_app_bar.dart';
import 'package:vierqr/main.dart';
import 'package:vierqr/models/account_bank_detail_dto.dart';
import 'package:vierqr/models/confirm_otp_bank_dto.dart';
import 'package:vierqr/models/qr_generated_dto.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

import '../../services/providers/account_bank_detail_provider.dart';
import 'states/bank_card_state.dart';

class BankCardDetailScreen extends StatelessWidget {
  final String bankId;

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
  List<String> listTitle = ['Thông tin', 'Thống kê', 'Giao dịch'];
  final PageController pageController = PageController();
  String userId = UserInformationHelper.instance.getUserId();
  late QRGeneratedDTO qrGeneratedDTO = const QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '');

  late AccountBankDetailDTO dto = AccountBankDetailDTO(
    id: '',
    bankAccount: '',
    userBankName: '',
    bankCode: '',
    bankName: '',
    imgId: '',
    type: 0,
    userId: '',
    bankTypeId: '',
    bankTypeStatus: 0,
    nationalId: '',
    qrCode: '',
    phoneAuthenticated: '',
    businessDetails: [],
    transactions: [],
    authenticated: false,
    caiValue: '',
  );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(title: 'Chi tiết ngân hàng'),
      body: ChangeNotifierProvider(
        create: (_) => AccountBankDetailProvider(),
        child: Consumer<AccountBankDetailProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: listTitle.map((title) {
                      int index = listTitle.indexOf(title);
                      return GestureDetector(
                        onTap: () {
                          pageController.animateToPage(index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease);
                          provider.changeCurrentPage(index);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          padding: const EdgeInsets.only(bottom: 4, top: 12),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: index == provider.currentPage
                                          ? AppColor.BLUE_TEXT
                                          : Colors.transparent))),
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
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
                            return PageView(
                              controller: pageController,
                              onPageChanged: (index) {
                                provider.changeCurrentPage(index);
                              },
                              children: [
                                InfoDetailBankAccount(
                                  bloc: bankCardBloc,
                                  refresh: _refresh,
                                  dto: dto,
                                  qrGeneratedDTO: qrGeneratedDTO,
                                  bankId: state.bankId ?? '',
                                ),
                                Statistical(bankId: state.bankId ?? ''),
                                Transaction(
                                  bloc: bankCardBloc,
                                  refresh: _refresh,
                                  dto: dto,
                                  bankId: state.bankId ?? '',
                                )
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
}
