import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/pin_code_input.dart';
import 'package:vierqr/services/providers/countdown_provider.dart';

class DialogOTPView extends StatefulWidget {
  final String phone;

  final ValueChanged<String>? onChangeOTP;
  final Function() onResend;
  final Function() onTap;

  const DialogOTPView(
      {super.key,
      required this.phone,
      this.onChangeOTP,
      required this.onTap,
      required this.onResend});

  @override
  State<DialogOTPView> createState() => _DialogOTPViewState();
}

class _DialogOTPViewState extends State<DialogOTPView> {
  late CountdownProvider countdownProvider;
  final otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    countdownProvider = CountdownProvider(120);
    countdownProvider.countDown();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColor.WHITE,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.clear, color: Colors.transparent),
                    const Expanded(
                      child: DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.BLACK,
                        ),
                        child: Text(
                          'Xác thực OTP',
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: const Icon(Icons.clear),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 24),
                SizedBox(
                  height: 40,
                  child: PinCodeInput(
                    obscureText: false,
                    size: 32,
                    autoFocus: true,
                    controller: otpController,
                    onChanged: widget.onChangeOTP,
                    length: 8,
                    textStyle: Styles.copyStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColor.BLUE_TEXT,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
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
                                const TextSpan(
                                    text: 'Mã OTP có hiệu lực trong vòng '),
                                TextSpan(
                                  text: value.toString(),
                                  style: const TextStyle(
                                      color: AppColor.BLUE_TEXT),
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
                                const TextSpan(
                                    text: 'Không nhận được mã OTP? '),
                                TextSpan(
                                  text: 'Gửi lại',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: AppColor.BLUE_TEXT,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      otpController.clear();
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
                const SizedBox(height: 10),
                MButtonWidget(
                  colorEnableBgr: AppColor.BLUE_TEXT,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  isEnable: true,
                  title: 'Xác thực',
                  onTap: widget.onTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
