import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/verify_email/views/key_active_free.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class VerifyEmailSuccessScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final String email;

  VerifyEmailSuccessScreen({
    required this.onContinue,
    required this.email,
    Key? key,
  }) : super(key: key);

  @override
  State<VerifyEmailSuccessScreen> createState() =>
      _VerifyEmailSuccessScreenState();
}

class _VerifyEmailSuccessScreenState extends State<VerifyEmailSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MButtonWidget(
          height: 50,
          title: 'Hoàn thành',
          margin: EdgeInsets.zero,
          isEnable: true,
          onTap: widget.onContinue,
          colorDisableBgr: AppColor.GREY_BUTTON,
        ),
      ),
      backgroundColor: AppColor.WHITE,
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: XImage(
                      imagePath: 'assets/images/logo-email.png',
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Xác thực Email thành công!',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(text: 'Thông tin email '),
                        TextSpan(
                          text: widget.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const TextSpan(
                          text: ' đã được xác thực bởi hệ thống VIETQR.VN',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const XImage(
                      imagePath: 'assets/images/ic-suggest.png',
                      width: 30,
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xFF458BF8),
                          Color(0xFFFF8021),
                          Color(0xFFFF3751),
                          Color(0xFFC958DB),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: Text(
                        'Gợi ý cho bạn',
                        style: TextStyle(
                          fontSize: 15,
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [
                                Color(0xFF458BF8),
                                Color(0xFFFF8021),
                                Color(0xFFFF3751),
                                Color(0xFFC958DB),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(const Rect.fromLTWH(0, 0, 200, 30)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    // Navigator.pushReplacementNamed(
                    //     context, Routes.KEY_ACTIVE_FREE);
                    NavigatorUtils.navigatePage(
                        context, const KeyActiveFreeScreen(),
                        routeName: KeyActiveFreeScreen.routeName);
                  },
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFD8ECF8),
                          Color(0xFFFFEAD9),
                          Color(0xFFF5C9D1),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          XImage(
                            imagePath: 'assets/images/ic-01-black.png',
                            width: 30,
                          ),
                          Text(
                            'Lấy mã kích hoạt dịch vụ VietQR ',
                            style: TextStyle(fontSize: 11),
                          ),
                          Text(
                            'miễn phí 01 tháng',
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(Routes.USER_INFO);
                  },
                  child: Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFD8ECF8),
                          Color(0xFFFFEAD9),
                          Color(0xFFF5C9D1),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          XImage(
                            imagePath: 'assets/images/ic-info-black.png',
                            width: 30,
                          ),
                          Text(
                            'Cập nhật thông tin cá nhân',
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          )
        ],
      ),
    );
  }
}
