import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/encrypt_utils.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/commons/utils/string_utils.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/pin_code_input.dart';
import 'package:vierqr/models/account_login_dto.dart';

import 'forgot_password_screen.dart';

class QuickLoginScreen extends StatefulWidget {
  final String userName;
  final String phone;
  final Function(AccountLoginDTO) onLogin;
  final GestureTapCallback? onQuickLogin;
  final TextEditingController pinController;
  final FocusNode passFocus;

  QuickLoginScreen({
    super.key,
    required this.userName,
    required this.phone,
    required this.onLogin,
    required this.onQuickLogin,
    required this.pinController,
    required this.passFocus,
  });

  @override
  State<QuickLoginScreen> createState() => _QuickLoginScreenState();
}

class _QuickLoginScreenState extends State<QuickLoginScreen> {
  bool isButtonLogin = false;

  onChangePin(value) {
    if (value.length >= 6) {
      isButtonLogin = true;
    } else {
      isButtonLogin = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: AppColor.GREY_BG,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 300,
                        padding:
                            const EdgeInsets.only(top: 70, left: 40, right: 40),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/bgr-header.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 30),
                            child: Container(
                              color: Colors.white.withOpacity(0.0),
                              height: 40,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 300,
                        padding:
                            const EdgeInsets.only(top: 70, left: 40, right: 40),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        'Xin chào, ${widget.userName}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        StringUtils.instance
                                            .formatPhoneNumberVN(widget.phone),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  height: 40,
                                  child: Image.asset(
                                    'assets/images/ic-viet-qr.png',
                                    height: 40,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Text(
                              'Vui lòng nhập mật khẩu để đăng nhập',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              height: 40,
                              alignment: Alignment.center,
                              child: PinCodeInput(
                                obscureText: true,
                                controller: widget.pinController,
                                autoFocus: true,
                                focusNode: widget.passFocus,
                                onChanged: onChangePin,
                                onCompleted: (value) {
                                  AccountLoginDTO dto = AccountLoginDTO(
                                    phoneNo: widget.phone,
                                    password: EncryptUtils.instance.encrypted(
                                      widget.phone,
                                      widget.pinController.text,
                                    ),
                                    device: '',
                                    fcmToken: '',
                                    platform: '',
                                    sharingCode: '',
                                  );
                                  widget.onLogin(dto);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: widget.onQuickLogin,
                                  child: const Text(
                                    'Đổi số điện thoại',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.BLUE_TEXT),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    NavigatorUtils.navigatePage(
                                      context,
                                      ForgotPasswordScreen(
                                        userName: widget.userName,
                                        phone: widget.phone,
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Quên mật khẩu?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.BLUE_TEXT),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            MButtonWidget(
              title: 'Đăng nhập',
              isEnable: widget.pinController.text.length >= 6,
              colorEnableText: widget.pinController.text.length >= 6
                  ? AppColor.WHITE
                  : AppColor.GREY_TEXT,
              onTap: () {
                AccountLoginDTO dto = AccountLoginDTO(
                  phoneNo: widget.phone,
                  password: EncryptUtils.instance.encrypted(
                    widget.phone,
                    widget.pinController.text,
                  ),
                  device: '',
                  fcmToken: '',
                  platform: '',
                  sharingCode: '',
                );
                widget.onLogin(dto);
              },
            ),
            SizedBox(height: height < 800 ? 0 : 16),
          ],
        ),
      ),
    );
  }
}
