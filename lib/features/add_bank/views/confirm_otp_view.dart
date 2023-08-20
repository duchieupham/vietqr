import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/pin_code_input.dart';
import 'package:vierqr/services/providers/countdown_provider.dart';

class ConfirmOTPView extends StatefulWidget {
  final String phone;

  // final String requestId;
  // final BankCardRequestOTP dto;
  final TextEditingController otpController;
  final ValueChanged<String>? onChangeOTP;
  final Function() onResend;

  const ConfirmOTPView(
      {super.key,
      required this.phone,
      required this.otpController,
      this.onChangeOTP,
      required this.onResend});

  @override
  State<ConfirmOTPView> createState() => _ConfirmOTPViewState();
}

class _ConfirmOTPViewState extends State<ConfirmOTPView> {
  late CountdownProvider countdownProvider;

  @override
  void initState() {
    super.initState();
    countdownProvider = CountdownProvider(120);
    countdownProvider.countDown();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Nhập mã OTP từ MB gửi về số điện thoại ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: AppColor.BLACK,
                ),
              ),
              TextSpan(
                text: widget.phone,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColor.BLACK,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: PinCodeInput(
            obscureText: false,
            autoFocus: true,
            controller: widget.otpController,
            onChanged: widget.onChangeOTP,
            length: 8,
            textStyle: Styles.copyStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.BLUE_TEXT,
            ),
          ),
        ),
        const SizedBox(height: 12),
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
                          style: const TextStyle(color: AppColor.BLUE_TEXT),
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
                            color: AppColor.BLUE_TEXT,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              widget.otpController.clear();
                              countdownProvider.setValue(120);
                              countdownProvider.countDown();
                              widget.onResend();
                            },
                        ),
                      ],
                    ),
                  );
          },
        ),
      ],
    );
  }
}
