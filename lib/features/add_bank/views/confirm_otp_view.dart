import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/pin_code_input.dart';
import 'package:vierqr/models/bank_type_dto.dart';
import 'package:vierqr/services/providers/countdown_provider.dart';

class ConfirmOTPView extends StatefulWidget {
  final String phone;

  // final String requestId;
  final BankTypeDTO dto;
  final TextEditingController otpController;
  final ValueChanged<String>? onChangeOTP;
  final Function() onResend;

  const ConfirmOTPView(
      {super.key,
      required this.phone,
      required this.otpController,
      required this.dto,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Xác thực liên kết TK ngân hàng',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Nhập mã OTP từ ${widget.dto.bankCode} gửi về SĐT ',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: AppColor.BLACK,
                ),
              ),
              TextSpan(
                text: '${formatPhoneNumber(widget.phone)}.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: <Color>[
                        Color(0xFF00B8F5),
                        Color(0xFF0A7AFF),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(
                      const Rect.fromLTWH(0.0, 0.0, 300.0, 100.0),
                    ),
                ),
              ),
            ],
          ),
        ),
        // SizedBox(
        //   height: 40,
        //   child: PinCodeInput(
        //     obscureText: false,
        //     autoFocus: true,
        //     controller: widget.otpController,
        //     onChanged: widget.onChangeOTP,
        //     length: widget.dto.bankCode.contains('BIDV') ? 6 : 8,
        //     textStyle: Styles.copyStyle(
        //       fontSize: 16,
        //       fontWeight: FontWeight.w600,
        //       color: AppColor.BLUE_TEXT,
        //     ),
        //   ),
        // ),
        SizedBox(
          height: 50,
          child: PinCodeInput(
            obscureText: true,
            autoFocus: true,
            controller: widget.otpController,
            onChanged: widget.onChangeOTP,
            length: widget.dto.bankCode.contains('BIDV') ? 6 : 8,
            textStyle: Styles.copyStyle(
              fontSize: 35,
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
                        const TextSpan(text: 'Mã OTP hết hạn sau '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: VietQRTheme.gradientColor
                                  .lilyLinear, 
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              formatDuration(
                                  value as int), // Format value to mm:ss
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColor
                                    .BLUE_TEXT, 
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: ' giây.'),
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
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: AppColor.BLUE_TEXT,
                            height: 1.4,
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
        // ValueListenableBuilder(
        //   valueListenable: countdownProvider,
        //   builder: (_, value, child) {
        //     return (value != 0)
        //         ? RichText(
        //             textAlign: TextAlign.center,
        //             text: TextSpan(
        //               style: TextStyle(
        //                 color: Theme.of(context).hintColor,
        //                 fontSize: 15,
        //               ),
        //               children: [
        //                 const TextSpan(text: 'Mã OTP hết hạn sau '),
        //                 TextSpan(
        //                   text: value.toString(),
        //                   style: const TextStyle(color: AppColor.BLUE_TEXT),
        //                 ),
        //                 const TextSpan(text: 's.'),
        //               ],
        //             ),
        //           )
        //         : RichText(
        //             textAlign: TextAlign.center,
        //             text: TextSpan(
        //               style: TextStyle(
        //                 color: Theme.of(context).hintColor,
        //                 fontSize: 15,
        //               ),
        //               children: [
        //                 const TextSpan(text: 'Không nhận được mã OTP? '),
        //                 TextSpan(
        //                   text: 'Gửi lại',
        //                   style: const TextStyle(
        //                     decoration: TextDecoration.underline,
        //                     color: AppColor.BLUE_TEXT,
        //                   ),
        //                   recognizer: TapGestureRecognizer()
        //                     ..onTap = () {
        //                       widget.otpController.clear();
        //                       countdownProvider.setValue(120);
        //                       countdownProvider.countDown();
        //                       widget.onResend();
        //                     },
        //                 ),
        //               ],
        //             ),
        //           );
        //   },
        // ),
      ],
    );
  }

  String formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String formatPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d{4})'),
        (Match m) => '${m[1]} ${m[2]} ${m[3]}');
  }
}
