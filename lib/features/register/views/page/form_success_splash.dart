import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../commons/constants/configurations/app_images.dart';
import '../../../../commons/constants/configurations/theme.dart';

class FormRegisterSuccessSplash extends StatefulWidget {
  // final Function() onEdit;
  // final Function() onHome;
  const FormRegisterSuccessSplash({
    super.key,
    // required this.onEdit,
    // required this.onHome,
  });

  @override
  State<FormRegisterSuccessSplash> createState() =>
      _FormRegisterSuccessSplashState();
}

class _FormRegisterSuccessSplashState extends State<FormRegisterSuccessSplash> {
  Timer? _timer;
  int _start = 3;

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
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              padding: const EdgeInsets.only(top: 40),
              child: Image.asset(
                AppImages.icRegisterSuccessful,
                width: 236,
                height: 304,
                fit: BoxFit.fitWidth,
              ),
            ),
            const DefaultTextStyle(
              style: TextStyle(
                color: AppColor.BLACK,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              child: Text(
                'Đăng ký tài khoản\nthành công!',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            // Container(
            //   child: DefaultTextStyle(
            //     style: TextStyle(fontSize: 15),
            //     child: MButtonWidget(
            //       title: 'Bạn có muốn cập nhật thông tin cá nhân',
            //       isEnable: true,
            //       height: 50,
            //       margin: EdgeInsets.only(left: 40, right: 40),
            //       colorEnableBgr: AppColor.WHITE,
            //       colorEnableText: AppColor.BLUE_TEXT,
            //       border: Border.all(width: 1, color: AppColor.BLUE_TEXT),
            //       // onTap: widget.onEdit,
            //     ),
            //   ),
            // ),
            // Container(
            //   child: DefaultTextStyle(
            //     style: TextStyle(fontSize: 15),
            //     child: MButtonWidget(
            //       title: 'Truy cập trang chủ VietQR VN',
            //       isEnable: true,
            //       margin: EdgeInsets.only(left: 40, right: 40),
            //       height: 50,
            //       // onTap: widget.onHome,
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: DefaultTextStyle(
                style: const TextStyle(fontSize: 15, color: AppColor.BLACK),
                child: RichText(
                  text: TextSpan(
                    text: 'Hệ thống tự động điều hướng sau ',
                    style: const TextStyle(fontSize: 15, color: AppColor.BLACK),
                    children: <TextSpan>[
                      TextSpan(
                        text: '$_start',
                        style:
                            const TextStyle(fontSize: 15, color: AppColor.BLUE_TEXT),
                      ),
                      const TextSpan(
                        text: ' giây',
                        style: TextStyle(fontSize: 15, color: AppColor.BLACK),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
