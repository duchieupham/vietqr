import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vierqr/features/personal/views/user_edit_view.dart';
import 'package:vierqr/services/providers/user_edit_provider.dart';

import '../../../../commons/constants/configurations/app_images.dart';
import '../../../../commons/constants/configurations/theme.dart';
import '../../../../layouts/m_button_widget.dart';

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
    const oneSec = const Duration(seconds: 1);
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

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.WHITE,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 90),
              child: Image.asset(
                AppImages.icLogoVietQr,
                width: 160,
                height: 66,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 90),
              child: Image.asset(
                AppImages.icRegisterSuccessful,
                width: 236,
                height: 304,
                fit: BoxFit.fitWidth,
              ),
            ),
            DefaultTextStyle(
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
            SizedBox(
              height: 70,
            ),
            Container(
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 15),
                child: MButtonWidget(
                  title: 'Bạn có muốn cập nhật thông tin cá nhân',
                  isEnable: true,
                  height: 50,
                  margin: EdgeInsets.only(left: 40, right: 40),
                  colorEnableBgr: AppColor.WHITE,
                  colorEnableText: AppColor.BLUE_TEXT,
                  border: Border.all(width: 1, color: AppColor.BLUE_TEXT),
                  // onTap: widget.onEdit,
                ),
              ),
            ),
            Container(
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 15),
                child: MButtonWidget(
                  title: 'Truy cập trang chủ VietQR VN',
                  isEnable: true,
                  margin: EdgeInsets.only(left: 40, right: 40),
                  height: 50,
                  // onTap: widget.onHome,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: DefaultTextStyle(
                style: TextStyle(fontSize: 15, color: AppColor.BLACK),
                child: RichText(
                  text: TextSpan(
                    text: 'Hệ thống tự động điều hướng sau ',
                    style: TextStyle(fontSize: 15, color: AppColor.BLACK),
                    children: <TextSpan>[
                      TextSpan(
                        text: '$_start',
                        style:
                            TextStyle(fontSize: 15, color: AppColor.BLUE_TEXT),
                      ),
                      TextSpan(
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
