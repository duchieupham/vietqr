import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/layouts/pin_code_input.dart';
import 'package:vierqr/services/providers/verify_otp_provider.dart';

class VerifyOTPView extends StatefulWidget {
  final String phone;
  final Function(int) onChangePage;
  final Future<dynamic> Function(String) onVerifyOTP;
  final Future<void> onResendOTP;

  const VerifyOTPView({
    super.key,
    required this.phone,
    required this.onChangePage,
    required this.onVerifyOTP,
    required this.onResendOTP,
  });

  @override
  State<StatefulWidget> createState() => _VerifyOTPView();
}

class _VerifyOTPView extends State<VerifyOTPView> with WidgetsBindingObserver {
  final otpController = TextEditingController();
  late CountDownOTPNotifier countdownProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    countdownProvider = CountDownOTPNotifier(120);
    countdownProvider.countDown();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    countdownProvider.onHideApp(state);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<VerifyOtpProvider>(
      create: (_) => VerifyOtpProvider(),
      child: Consumer<VerifyOtpProvider>(
        builder: (_, provider, child) {
          return Stack(
            children: [
              Column(
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
                            Provider.of<VerifyOtpProvider>(context,
                                    listen: false)
                                .reset();
                          },
                          child: Container(
                            width: 80,
                            alignment: Alignment.centerRight,
                            child: const Text(
                              'Đóng',
                              style: TextStyle(
                                color: AppColor.BLUE_TEXT,
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
                              const TextSpan(
                                  text:
                                      'Mã OTP từ MB được gửi về số điện thoại '),
                              TextSpan(
                                text: widget.phone,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        PinCodeInput(
                          controller: otpController,
                          onChanged: provider.onChangePinCode,
                          clBorderErr: provider.otpError != null
                              ? AppColor.error700
                              : null,
                          error: provider.otpError != null ? true : false,
                        ),
                        Text(
                          provider.otpError ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 20 / 12,
                            color: AppColor.error700,
                          ),
                        )
                      ],
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: countdownProvider,
                    builder: (_, value, child) {
                      if ((value != 0)) {
                        return RichText(
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
                                style:
                                    const TextStyle(color: AppColor.BLUE_TEXT),
                              ),
                              const TextSpan(text: 's.'),
                            ],
                          ),
                        );
                      } else {
                        return RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontSize: 15,
                            ),
                            children: [
                              const TextSpan(text: 'Không nhận được mã OTP? '),
                              if (countdownProvider.resendOtp <= 0)
                                const TextSpan()
                              else
                                TextSpan(
                                  text:
                                      'Gửi lại (${countdownProvider.resendOtp})',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: AppColor.BLUE_TEXT,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      countdownProvider.resendCountDown();
                                      otpController.clear();
                                      await widget.onResendOTP;
                                      // await register.phoneAuthentication(
                                      //     widget.phone);
                                    },
                                ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 10)),
                  ButtonWidget(
                    width: width,
                    text: 'Xác thực',
                    textColor: AppColor.WHITE,
                    bgColor: provider.isButton
                        ? AppColor.BLUE_TEXT
                        : AppColor.GREY_444B56,
                    function: () async {
                      provider.updateLoading(true);
                      final data = await widget.onVerifyOTP(otpController.text);

                      if (data is bool) {
                        if (!mounted) return;
                        provider.updateLoading(false);
                        Navigator.of(context).pop();
                        widget.onChangePage(1);
                      } else if (data is String) {
                        provider.onOtpSubmit(data, () {
                          countdownProvider.setValue(0);
                        });
                      }
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 20)),
                ],
              ),
              Visibility(
                visible: provider.isLoading,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.BLUE_TEXT,
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
