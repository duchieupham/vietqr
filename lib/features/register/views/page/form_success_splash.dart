import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/di/injection/injection.dart';
import 'package:vierqr/features/login/blocs/login_bloc.dart';
import 'package:vierqr/features/register/blocs/register_bloc.dart';
import 'package:vierqr/features/register/states/register_state.dart';
// import 'package:vierqr/features/dashboard/dashboard_screen.dart';
// import 'package:vierqr/features/home/home.dart';
// import 'package:vierqr/layouts/button/button.dart';
// import 'package:vierqr/layouts/m_button_widget.dart';
// import 'package:vierqr/services/providers/register_provider.dart';
// import 'package:vierqr/splash_screen.dart';

import '../../../../commons/constants/configurations/app_images.dart';
import '../../../../commons/constants/configurations/theme.dart';

class FormRegisterSuccessSplash extends StatefulWidget {
  const FormRegisterSuccessSplash({
    super.key,
  });

  @override
  State<FormRegisterSuccessSplash> createState() =>
      _FormRegisterSuccessSplashState();
}

class _FormRegisterSuccessSplashState extends State<FormRegisterSuccessSplash> {
  final RegisterBloc _registerBloc = getIt.get<RegisterBloc>();
  Timer? _timer;
  int _start = 15;
  bool _onHomeCalled = false;
  // late final LoginBloc _bloc = getIt.get<LoginBloc>(param1: context);
  String phoneNum = '';
  String password = '';

  @override
  void initState() {
    super.initState();
    // _startTimer();
  }

  // void _startTimer() {
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         timer.cancel();
  //         if (!_onHomeCalled) {
  //           Navigator.popUntil(context, ((route) {
  //             if (route.settings.name != null &&
  //                 route.settings.name == Routes.REGISTER) {
  //               return true;
  //             } else {
  //               return false;
  //             }
  //           }));
  //           backToPreviousPage(context, true, state);
  //         }
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  void backToPreviousPage(
      BuildContext context, bool isRegisterSuccess, RegisterState state) {
    Navigator.pop(context, {
      'phone': state.phoneNumber.replaceAll(' ', ''),
      'password': state.password
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      bloc: _registerBloc,
      listener: (context, state) {
        const oneSec = Duration(seconds: 1);
        _timer = Timer.periodic(
          oneSec,
          (Timer timer) {
            if (_start == 0) {
              timer.cancel();
              if (!_onHomeCalled) {
                Navigator.popUntil(context, ((route) {
                  if (route.settings.name != null &&
                      route.settings.name == Routes.REGISTER) {
                    return true;
                  } else {
                    return false;
                  }
                }));
                backToPreviousPage(context, true, state);
              }
            } else {
              setState(() {
                _start--;
              });
            }
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              color: AppColor.WHITE,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 90),
                    child: Image.asset(
                      AppImages.icLogoVietQr,
                      width: 160,
                      height: 66,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Image.asset(
                      AppImages.icRegisterSuccessful,
                      width: 236,
                      height: 200,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(
                      color: AppColor.BLACK,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF9CD740),
                          Color(0xFF2BACE6),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: const Text(
                        'Đăng ký thành công!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  DefaultTextStyle(
                    style: const TextStyle(fontSize: 15, color: AppColor.BLACK),
                    child: RichText(
                      text: TextSpan(
                        text: 'Hệ thống tự động điều hướng sau ',
                        style: const TextStyle(
                            fontSize: 15, color: AppColor.BLACK),
                        children: <TextSpan>[
                          TextSpan(
                            text: '$_start',
                            style: const TextStyle(
                                fontSize: 15, color: AppColor.BLUE_TEXT),
                          ),
                          const TextSpan(
                            text: ' giây',
                            style:
                                TextStyle(fontSize: 15, color: AppColor.BLACK),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        _onHomeCalled = true;
                      });
                      Navigator.popUntil(context, ((route) {
                        if (route.settings.name != null &&
                            route.settings.name == Routes.REGISTER) {
                          return true;
                        } else {
                          return false;
                        }
                      }));
                      backToPreviousPage(context, true, state);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const LinearGradient(
                              colors: [
                                Color(0xFFE1EFFF),
                                Color(0xFFE5F9FF),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight)),
                      child: Center(
                        child: DefaultTextStyle(
                          style: const TextStyle(
                            color: AppColor.BLACK,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
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
                              'Trang chủ VietQR.VN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   child: DefaultTextStyle(
                  //     style: TextStyle(fontSize: 15),
                  //     child: MButtonWidget(
                  //       title: 'Truy cập trang chủ VietQR VN',
                  //       isEnable: true,
                  //       margin: EdgeInsets.only(left: 40, right: 40),
                  //       height: 50,
                  //       onTap: widget.onHome,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
