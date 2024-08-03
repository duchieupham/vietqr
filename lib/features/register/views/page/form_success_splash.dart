import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vierqr/features/dashboard/dashboard_screen.dart';
import 'package:vierqr/features/home/home.dart';
import 'package:vierqr/layouts/button/button.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/splash_screen.dart';

import '../../../../commons/constants/configurations/app_images.dart';
import '../../../../commons/constants/configurations/theme.dart';

class FormRegisterSuccessSplash extends StatefulWidget {
  final VoidCallback onHome;
  const FormRegisterSuccessSplash({
    required this.onHome,
    super.key,
  });

  @override
  State<FormRegisterSuccessSplash> createState() =>
      _FormRegisterSuccessSplashState();
}

class _FormRegisterSuccessSplashState extends State<FormRegisterSuccessSplash> {
  Timer? _timer;
  int _start = 15;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timer.cancel();
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => DashBoardScreen(
          //       isFromLogin: true,
          //       isLogoutEnterHome: true,
          //     ),
          //     settings: RouteSettings(name: SplashScreen.routeName),
          //   ),
          // );
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(builder: (context) => DashBoardScreen()));
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              style: TextStyle(
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
                  style: const TextStyle(fontSize: 15, color: AppColor.BLACK),
                  children: <TextSpan>[
                    TextSpan(
                      text: '$_start',
                      style: const TextStyle(
                          fontSize: 15, color: AppColor.BLUE_TEXT),
                    ),
                    const TextSpan(
                      text: ' giây',
                      style: TextStyle(fontSize: 15, color: AppColor.BLACK),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: widget.onHome,
              child: Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    gradient: LinearGradient(
                        colors: [
                          Color(0xFFE1EFFF),
                          Color(0xFFE5F9FF),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: Center(
                  child: DefaultTextStyle(
                    style: TextStyle(
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
    );
  }
}
