import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/commons/widgets/textfield_widget.dart';
import 'package:vierqr/features/bank_card/blocs/bank_card_bloc.dart';
import 'package:vierqr/features/bank_card/events/bank_card_event.dart';
import 'package:vierqr/layouts/border_layout.dart';
import 'package:vierqr/models/bank_card_request_otp.dart';
import 'package:vierqr/models/confirm_otp_bank_dto.dart';
import 'package:vierqr/services/providers/countdown_provider.dart';

class ConfirmOTPView extends StatefulWidget {
  final String requestId;
  final String phone;
  final BankCardBloc bankCardBloc;
  final BankCardRequestOTP dto;

  const ConfirmOTPView({
    super.key,
    required this.requestId,
    required this.phone,
    required this.bankCardBloc,
    required this.dto,
  });

  @override
  State<StatefulWidget> createState() => _ConfirmOTPView();
}

class _ConfirmOTPView extends State<ConfirmOTPView> {
  final _formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();
  late CountdownProvider countdownProvider;

  @override
  void initState() {
    super.initState();
    countdownProvider = CountdownProvider(120);
    countdownProvider.countDown();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          height: 50,
          child: Row(
            children: [
              const SizedBox(
                width: 80,
                height: 50,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'Xác thực OTP',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 80,
                  alignment: Alignment.centerRight,
                  child: const Text(
                    'Đóng',
                    style: TextStyle(
                      color: AppColor.GREEN,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        DividerWidget(width: width),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Padding(padding: EdgeInsets.only(top: 30)),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 15,
                  ),
                  children: [
                    const TextSpan(text: 'Mã OTP được gửi tới SĐT '),
                    TextSpan(
                      text: widget.phone,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                        text:
                            '. Vui lòng nhập mã để xác thực liên kết tài khoản ngân hàng.'),
                  ],
                ),
              ),
              //
              const Padding(padding: EdgeInsets.only(top: 30)),
              Form(
                key: _formKey,
                child: BorderLayout(
                  width: width,
                  isError: false,
                  child: TextFieldWidget(
                    titleWidth: 130,
                    width: width,
                    isObscureText: false,
                    hintText: 'Nhập mã OTP',
                    autoFocus: false,
                    fontSize: 15,
                    controller: otpController,
                    inputType: TextInputType.text,
                    keyboardAction: TextInputAction.done,
                    onChange: (text) {},
                  ),
                ),
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: countdownProvider,
          builder: (_, value, child) {
            return (value != 0)
                ? RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 15,
                      ),
                      children: [
                        const TextSpan(text: 'Mã OTP có hiệu lực trong vòng '),
                        TextSpan(
                          text: value.toString(),
                          style: const TextStyle(color: AppColor.GREEN),
                        ),
                        const TextSpan(text: 's.'),
                      ],
                    ),
                  )
                : RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 15,
                      ),
                      children: [
                        const TextSpan(text: 'Không nhận được mã OTP? '),
                        TextSpan(
                          text: 'Gửi lại',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColor.GREEN,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              otpController.clear();
                              countdownProvider.setValue(120);
                              countdownProvider.countDown();
                              widget.bankCardBloc.add(
                                BankCardEventRequestOTP(dto: widget.dto),
                              );
                            },
                        ),
                      ],
                    ),
                  );
          },
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        ButtonWidget(
          width: width,
          text: 'Xác thực',
          textColor: AppColor.WHITE,
          bgColor: AppColor.GREEN,
          function: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (otpController.text.isNotEmpty) {
              ConfirmOTPBankDTO confirmDTO = ConfirmOTPBankDTO(
                requestId: widget.requestId,
                otpValue: otpController.text,
                applicationType: 'MOBILE',
              );
              widget.bankCardBloc.add(BankCardEventConfirmOTP(dto: confirmDTO));
            }
          },
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
      ],
    );
  }
}
