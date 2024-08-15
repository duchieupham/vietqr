import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/commons/widgets/pin_code_input.dart';
import 'package:vierqr/features/dashboard/blocs/dashboard_bloc.dart';
import 'package:vierqr/features/dashboard/events/dashboard_event.dart';
import 'package:vierqr/features/register/views/page/form_success_splash.dart';
import 'package:vierqr/features/verify_email/blocs/verify_email_bloc.dart';
import 'package:vierqr/features/verify_email/events/verify_email_event.dart';
import 'package:vierqr/features/verify_email/states/verify_email_state.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/register_app_bar.dart';
import 'package:vierqr/navigator/app_navigator.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';
import 'package:vierqr/services/providers/register_provider.dart';

class ConfirmOtpRegisterScreen extends StatefulWidget {
  String email;
  bool isFocus;
  ConfirmOtpRegisterScreen({
    super.key,
    required this.email,
    required this.isFocus,
  });

  @override
  State<ConfirmOtpRegisterScreen> createState() =>
      _ConfirmOtpRegisterScreenState();
}

class _ConfirmOtpRegisterScreenState extends State<ConfirmOtpRegisterScreen> {
  final EmailBloc _bloc = getIt.get<EmailBloc>();
  final repassFocus = FocusNode();
  bool _confirmOTP = true;
  late Timer _timer;
  int _remainingSeconds = 600; // 10 minutes in seconds
  bool _isTimerExpired = false;
  final TextEditingController _otpController = TextEditingController();
  bool _onHomeCalled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _resetTimer() {
    if (mounted) {
      setState(() {
        _remainingSeconds = 600; // Reset to 10 minutes
        _isTimerExpired = false;
      });
    }
    _timer.cancel();
    _startTimer();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secondsRemaining = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secondsRemaining.toString().padLeft(2, '0')}';
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        if (mounted) {
          setState(() {
            _remainingSeconds--;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isTimerExpired = true;
          });
        }
        _timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailBloc, EmailState>(
      bloc: _bloc,
      listener: (context, state) {
        if (state is SendOTPFailedState) {
          Fluttertoast.showToast(
            msg: 'Gửi mã OTP thất bại',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }
        if (state is ConfirmOTPStateSuccessfulState) {
          Fluttertoast.showToast(
            msg: 'Xác nhận OTP thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
          NavigationService.push(Routes.REGISTER_SPLASH_SCREEN);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => FormRegisterSuccessSplash(
          //           // onHome: () {
          //           //   _onHomeCalled = true;
          //           //   Navigator.of(context).pop();
          //           //   Navigator.of(context).pop();
          //           //   Navigator.of(context).pop();
          //           //   Navigator.of(context).pop();
          //           //   backToPreviousPage(context, true);
          //           // },
          //           )),
          // );

          getIt.get<DashBoardBloc>().add(GetUserInformation());
          // getIt.get<BankBloc>().add(GetVerifyEmail());
          // print(SharePrefUtils.getProfile().verify);
        }
        if (state is ConfirmOTPStateFailedState) {
          setState(() {
            _confirmOTP = false;
            _otpController.text = '';
            widget.isFocus = true;
          });
          Fluttertoast.showToast(
            msg: 'Xác nhận OTP thất bại',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }

        if (state is ConfirmOTPStateFailedTimeOutState) {
          setState(() {
            _confirmOTP = false;
          });
          Fluttertoast.showToast(
            msg: 'Mã OTP đã hết hiệu lực',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Theme.of(context).cardColor,
            textColor: Theme.of(context).hintColor,
            fontSize: 15,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.WHITE,
          appBar: RegisterAppBar(
            title: '',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Thông tin xác thực đã được gửi đến email ',
                            style: TextStyle(
                              color: AppColor.BLACK,
                              fontSize: 15,
                            ),
                          ),
                          TextSpan(
                            text: widget.email,
                            style:const TextStyle(
                              fontSize: 15,
                              color: AppColor.BLACK,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 40),
                      child: Focus(
                        onFocusChange: (value) {
                          setState(() {
                            widget.isFocus = value;
                          });
                        },
                        child: PinCodeInput(
                          obscureText: true,
                          controller: _otpController,
                          autoFocus: widget.isFocus,
                          focusNode: repassFocus,
                          onChanged: (text) {},
                          onCompleted: (value) {
                            Map<String, dynamic> param = {
                              'otp': _otpController.text,
                              'userId': SharePrefUtils.getProfile().userId,
                              'email': widget.email,
                            };
                            _bloc.add(ConfirmOTPEvent(param: param));
                          },
                        ),
                      ),
                    ),
                    const Text(
                      'Mã OTP có hiệu lực trong vòng',
                      style: TextStyle(fontSize: 12),
                    ),
                    _isTimerExpired
                        ? GestureDetector(
                            onTap: () {
                              _resetTimer();
                              Map<String, dynamic> param = {
                                'recipient': widget.email,
                                'userId': SharePrefUtils.getProfile().userId,
                              };
                              _bloc.add(SendOTPAgainEvent(param: param));
                            },
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF00C6FF),
                                  Color(0xFF0072FF),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Text(
                                'Gửi lại mã OTP?',
                                style: TextStyle(
                                  fontSize: 20,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.transparent,
                                  decorationThickness: 2,
                                  foreground: Paint()
                                    ..shader = const LinearGradient(
                                      colors: [
                                        Color(0xFF00C6FF),
                                        Color(0xFF0072FF),
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(
                                        const Rect.fromLTWH(0, 0, 200, 30)),
                                ),
                              ),
                            ),
                          )
                        : ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFF00C6FF),
                                Color(0xFF0072FF),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: Text(
                              _formatTime(_remainingSeconds),
                              style: TextStyle(
                                fontSize: 20,
                                decorationThickness: 2,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [
                                      Color(0xFF00C6FF),
                                      Color(0xFF0072FF),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ).createShader(
                                      const Rect.fromLTWH(0, 0, 200, 30)),
                              ),
                            ),
                          ),
                    const Spacer(),
                  ],
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom == 0
                    ? 0
                    : MediaQuery.of(context).viewInsets.bottom,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: VietQRButton.gradient(
                        onPressed: () {
                          Map<String, dynamic> param = {
                            'otp': _otpController.text,
                            'userId': SharePrefUtils.getProfile().userId,
                            'email': widget.email,
                          };
                          _bloc.add(ConfirmOTPEvent(param: param));
                        },
                        isDisabled: !(_otpController.text.length == 6),
                        size: VietQRButtonSize.large,
                        child: Center(
                          child: Text(
                            'Xác thực OTP',
                            style: TextStyle(
                              color: (_otpController.text.length == 6)
                                  ? AppColor.WHITE
                                  : AppColor.BLACK,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(Routes.REGISTER_SPLASH_SCREEN);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => FormRegisterSuccessSplash(

                          //           )),
                          // );
                          // Future.delayed(const Duration(seconds: 15), () {
                          //   if (!_onHomeCalled) {
                          //     Navigator.of(context).pop();
                          //     Navigator.of(context).pop();
                          //     Navigator.of(context).pop();
                          //     Navigator.of(context).pop();
                          //     backToPreviousPage(context, true);
                          //   }
                          // });
                        },
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [
                              Color(0xFF00C6FF),
                              Color(0xFF0072FF),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ).createShader(bounds),
                          child: const Text(
                            'Bỏ qua',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void backToPreviousPage(BuildContext context, bool isRegisterSuccess) {
    Navigator.pop(context, {
      'phone': Provider.of<RegisterProvider>(context, listen: false)
          .phoneNoController
          .text,
      'password': Provider.of<RegisterProvider>(context, listen: false)
          .passwordController
          .text,
    });
  }
}
