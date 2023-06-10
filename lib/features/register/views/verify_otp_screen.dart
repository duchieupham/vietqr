import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/widgets/button_widget.dart';
import 'package:vierqr/commons/widgets/divider_widget.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/events/register_event.dart';
import 'package:vierqr/models/account_login_dto.dart';
import 'package:vierqr/services/providers/countdown_provider.dart';
import 'package:vierqr/services/providers/register_provider.dart';

import 'pin_code_input.dart';

class VerifyOTPView extends StatefulWidget {
  final String phone;
  final AccountLoginDTO dto;

  const VerifyOTPView({
    super.key,
    required this.phone,
    required this.dto,
  });

  @override
  State<StatefulWidget> createState() => _VerifyOTPView();
}

class _VerifyOTPView extends State<VerifyOTPView> {
  final otpController = TextEditingController();
  late CountdownProvider countdownProvider;

  @override
  void initState() {
    super.initState();
    countdownProvider = CountdownProvider(120);
    countdownProvider.countDown();
  }

  String otpError = '';

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Consumer<VerifyOtpProvider>(
      builder: (context, provider, child) {
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
                          color: DefaultTheme.GREEN,
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
                                '. Vui lòng nhập mã để xác thực đăng ký tài khoản.'),
                      ],
                    ),
                  ),
                  //
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  PinCodeInput(
                    controller: otpController,
                    onChanged: provider.onChangePinCode,
                    clBorderErr: provider.otpError != null
                        ? DefaultTheme.error700
                        : null,
                    error: provider.otpError != null ? true : false,
                  ),
                  Text(
                    provider.otpError ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 20 / 12,
                      color: DefaultTheme.error700,
                    ),
                  )
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
                            const TextSpan(
                                text: 'Mã OTP có hiệu lực trong vòng '),
                            TextSpan(
                              text: value.toString(),
                              style: const TextStyle(color: DefaultTheme.GREEN),
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
                                color: DefaultTheme.GREEN,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  countdownProvider = CountdownProvider(120);
                                  // widget.bankCardBloc.add(
                                  //   BankCardEventRequestOTP(dto: widget.dto),
                                  // );
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
              textColor: DefaultTheme.WHITE,
              bgColor: provider.isButton
                  ? DefaultTheme.GREEN
                  : DefaultTheme.GREY_444B56,
              function: () async {
                final data =
                    await Provider.of<RegisterProvider>(context, listen: false)
                        .verifyOTP(otpController.text);

                if (data) {
                  if (!mounted) return;
                  context
                      .read<RegisterBloc>()
                      .add(RegisterEventSubmit(dto: widget.dto));
                } else {
                  provider.onOtpSubmit();
                }
              },
            ),
            const Padding(padding: EdgeInsets.only(bottom: 10)),
          ],
        );
      },
    );
  }
}
