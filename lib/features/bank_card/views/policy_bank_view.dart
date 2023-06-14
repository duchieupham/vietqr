import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/features/bank_card/states/bank_card_state.dart';
import 'package:vierqr/features/bank_card/widgets/confirm_otp.dart';
import 'package:vierqr/features/web_view/views/custom_web_view.dart';
import 'package:vierqr/models/bank_account_dto.dart';
import 'package:vierqr/models/bank_card_insert_dto.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/models/register_authentication_dto.dart';
import 'package:vierqr/services/providers/add_bank_provider.dart';
import 'package:vierqr/services/shared_references/user_information_helper.dart';

class PolicyBankView extends StatelessWidget {
  final TextEditingController bankAccountController;
  final TextEditingController nameController;
  final TextEditingController nationalController;
  final TextEditingController phoneAuthenController;
  final PageController pageController;

  static bool isOpenOTP = false;

  const PolicyBankView({
    super.key,
    required this.bankAccountController,
    required this.nameController,
    required this.nationalController,
    required this.phoneAuthenController,
    required this.pageController,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return BlocProvider(
      create: (BuildContext context) => BankCardBloc(),
      child: BlocConsumer<BankCardBloc, BankCardState>(
        listener: (context, state) {
          if (state is BankCardReuqestOTPLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is BankCardRequestOTPSuccessState) {
            Navigator.pop(context);
            if (!isOpenOTP) {
              isOpenOTP = true;
              DialogWidget.instance
                  .showModalBottomContent(
                    widget: ConfirmOTPView(
                      phone: phoneAuthenController.text,
                      bankCardBloc: context.read<BankCardBloc>(),
                      dto: state.dto,
                      requestId: state.requestId,
                    ),
                    height: height * 0.5,
                  )
                  .then((value) => isOpenOTP = false);
            }
          }
          if (state is BankCardRequestOTPFailedState) {
            Navigator.pop(context);
            DialogWidget.instance.openMsgDialog(
              title: 'Xác thực thất bại',
              msg: state.message,
              function: () {
                _animatedToPage(2);
                Navigator.pop(context);
              },
            );
          }
          if (state is BankCardConfirmOTPLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is BankCardConfirmOTPSuccessState) {
            Navigator.pop(context);
            String bankId =
                Provider.of<AddBankProvider>(context, listen: false).bankId;
            if (bankId.trim().isEmpty) {
              BankTypeDTO bankTypeDTO =
                  Provider.of<AddBankProvider>(context, listen: false)
                      .bankTypeDTO;
              String userId = UserInformationHelper.instance.getUserId();
              String formattedName = StringUtils.instance.removeDiacritic(
                  StringUtils.instance
                      .capitalFirstCharacter(nameController.text));
              BankCardInsertDTO dto = BankCardInsertDTO(
                bankTypeId: bankTypeDTO.id,
                userId: userId,
                userBankName: formattedName,
                bankAccount: bankAccountController.text,
                type: Provider.of<AddBankProvider>(context, listen: false).type,
                branchId: Provider.of<AddBankProvider>(context, listen: false)
                    .branchChoiceInsertDTO
                    .branchId,
                nationalId: nationalController.text,
                phoneAuthenticated: phoneAuthenController.text,
              );
              context.read<BankCardBloc>().add(BankCardEventInsert(dto: dto));
            } else {
              RegisterAuthenticationDTO dto = RegisterAuthenticationDTO(
                bankId: bankId,
                nationalId: nationalController.text,
                phoneAuthenticated: phoneAuthenController.text,
                bankAccountName: nameController.text,
                bankAccount: bankAccountController.text,
              );
              context
                  .read<BankCardBloc>()
                  .add(BankCardEventRegisterAuthentication(dto: dto));
            }
          }
          if (state is BankCardConfirmOTPFailedState) {
            Navigator.pop(context);
            DialogWidget.instance.openMsgDialog(
              title: 'Lỗi',
              msg: state.message,
            );
          }
          if (state is BankCardUpdateAuthenticateSuccessState) {
            phoneAuthenController.clear();
            nameController.clear();
            nationalController.clear();
            bankAccountController.clear();
            Navigator.pop(context);
          }
          if (state is BankCardUpdateAuthenticateFailedState) {
            DialogWidget.instance.openMsgDialog(
              title: 'Không thể liên kết',
              msg: state.msg,
            );
          }
          if (state is BankCardInsertSuccessfulState) {
            BankTypeDTO bankTypeDTO =
                Provider.of<AddBankProvider>(context, listen: false)
                    .bankTypeDTO;
            BankAccountDTO dto = BankAccountDTO(
              imgId: bankTypeDTO.imageId,
              bankCode: bankTypeDTO.bankCode,
              bankName: bankTypeDTO.bankName,
              bankAccount: bankAccountController.text,
              userBankName: nameController.text,
              id: '',
              type: Provider.of<AddBankProvider>(context, listen: false).type,
              branchId: '',
              branchName: '',
              businessId: '',
              businessName: '',
              isAuthenticated: false,
            );
            Navigator.pop(context);
            phoneAuthenController.clear();
            nameController.clear();
            nationalController.clear();
            bankAccountController.clear();
            Navigator.of(context).pushReplacementNamed(
              Routes.BANK_CARD_GENERATED_VIEW,
              arguments: {'bankAccountDTO': dto},
            );
          }
          if (state is BankCardInsertFailedState) {
            DialogWidget.instance.openMsgDialog(
                title: 'Không thể thêm tài khoản', msg: state.message);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      width: width,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontSize: 16,
                            height: 1.5,
                          ),
                          children: [
                            const TextSpan(text: 'Kính gửi Quý Khách hàng,\n'),
                            const TextSpan(text: 'MBBank và Bluecom ('),
                            TextSpan(
                              text: 'vietqr.vn',
                              style: const TextStyle(
                                color: DefaultTheme.GREEN,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await DialogWidget.instance
                                      .showModalBottomContent(
                                    context: context,
                                    height: height * 0.8,
                                    widget: CustomWebView(
                                      url: 'https://vietqr.vn',
                                      title: 'VietQR',
                                      height: height * 0.8,
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(
                                text:
                                    ') xin gửi đến Quý Khách Điều khoản và điều kiện sử dụng dịch vụ nhận biến động số dư trên tài khoản số "'),
                            TextSpan(
                              text: bankAccountController.text,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(
                                text:
                                    '" của Quý khách mở tại ngân hàng MBBank. Căn cứ theo Hợp đồng Hợp tác số 01/2023/HĐDV/MB-BLUECOM ký ngày 09 tháng 03 năm 2023. Chi tiết tại đường link: '),
                            TextSpan(
                              text: 'https://vietqr.vn/mbbank-dkdv/',
                              style: const TextStyle(
                                color: DefaultTheme.GREEN,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await DialogWidget.instance
                                      .showModalBottomContent(
                                    context: context,
                                    height: height * 0.8,
                                    widget: CustomWebView(
                                      url: 'https://vietqr.vn/mbbank-dkdv/',
                                      title: 'Điều khoản dịch vụ',
                                      height: height * 0.8,
                                    ),
                                  );
                                },
                            ),
                            const TextSpan(
                                text:
                                    '\n\nQuý Khách vui lòng xác nhận đã đọc, hiểu và đồng ý sử dụng dịch vụ bằng cách nhập mã OTP do ngân hàng TMCP Quân đội gửi đến số điện thoại của Quý khách. Xin cảm ơn Quý Khách đã sử dụng dịch vụ của chúng tôi.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 20)),
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: Consumer<AddBankProvider>(
                        builder: (context, provider, child) {
                          return Checkbox(
                            activeColor: DefaultTheme.GREEN,
                            value: provider.isAgreeWithPolicy,
                            shape: const CircleBorder(),
                            onChanged: (bool? value) {
                              provider.updateAgreeWithPolicy(value!);
                            },
                          );
                        },
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    const Text(
                      'Tôi đã đọc và đồng ý với các điều khoản',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Consumer<AddBankProvider>(
                builder: (context, provider, child) {
                  return ButtonWidget(
                    width: width - 40,
                    text: 'Xác thực',
                    textColor: DefaultTheme.WHITE,
                    bgColor: (provider.isAgreeWithPolicy)
                        ? DefaultTheme.GREEN
                        : DefaultTheme.GREY_TOP_TAB_BAR,
                    function: () async {
                      if (provider.isAgreeWithPolicy) {
                        String formattedName = StringUtils.instance
                            .removeDiacritic(StringUtils.instance
                                .capitalFirstCharacter(nameController.text));
                        BankCardRequestOTP dto = BankCardRequestOTP(
                          nationalId: nationalController.text,
                          accountNumber: bankAccountController.text,
                          accountName: formattedName,
                          applicationType: 'MOBILE',
                          phoneNumber: phoneAuthenController.text,
                        );
                        context
                            .read<BankCardBloc>()
                            .add(BankCardEventRequestOTP(dto: dto));
                      }
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _animatedToPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutQuart,
    );
  }
}
