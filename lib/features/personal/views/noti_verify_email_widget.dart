import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/features/verify_email/verify_email_screen.dart';
import 'package:vierqr/features/verify_email/views/key_active_free.dart';
import 'package:vierqr/layouts/image/x_image.dart';
import 'package:vierqr/services/local_storage/shared_preference/shared_pref_utils.dart';

class NotiVerifyEmailWidget extends StatefulWidget {
  final bool isVerify;
  const NotiVerifyEmailWidget({super.key, required this.isVerify});

  @override
  State<NotiVerifyEmailWidget> createState() => _NotiVerifyEmailWidgetState();
}

class _NotiVerifyEmailWidgetState extends State<NotiVerifyEmailWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isVerify
        ? InkWell(
            onTap: () {
              NavigatorUtils.navigatePage(context, KeyActiveFreeScreen(),
                  routeName: KeyActiveFreeScreen.routeName);
            },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: [
                    Color(0xFFE1EFFF),
                    Color(0xFFE5F9FF),
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    const XImage(
                      imagePath: 'assets/images/ic-infinity.png',
                      width: 40,
                    ),
                    SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nhận ngay ưu đãi sử dụng dịch vụ',
                          style: TextStyle(fontSize: 11),
                        ),
                        Row(
                          children: [
                            Text(
                              'không giới hạn của VietQR',
                              style: TextStyle(fontSize: 11),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF00C6FF),
                                  Color(0xFF0072FF),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Text(
                                ' miễn phí 01 tháng.',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  // decoration:
                                  //     TextDecoration.underline,
                                  // decorationColor:
                                  //     Colors.transparent,
                                  // decorationThickness: 2,
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
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        : InkWell(
            onTap: () {
              NavigatorUtils.navigatePage(context, VerifyEmailScreen(),
                  routeName: VerifyEmailScreen.routeName);
            },
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(colors: [
                    Color(0xFFE1EFFF),
                    Color(0xFFE5F9FF),
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Row(
                  children: [
                    const XImage(
                      imagePath: 'assets/images/logo-email.png',
                      width: 40,
                    ),
                    SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Xác thực thông tin Email của bạn',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.arrow_circle_right_outlined,
                              color: AppColor.BLUE_TEXT.withOpacity(0.8),
                            )
                          ],
                        ),
                        Text(
                          'Nhận ngay ưu đãi sử dụng dịch vụ',
                          style: TextStyle(fontSize: 11),
                        ),
                        Row(
                          children: [
                            Text(
                              'không giới hạn của VietQR',
                              style: TextStyle(fontSize: 11),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFF00C6FF),
                                  Color(0xFF0072FF),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds),
                              child: Text(
                                ' miễn phí 01 tháng.',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
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
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
