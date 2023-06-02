import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/box_layout.dart';

class IntroduceScreen extends StatelessWidget {
  IntroduceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logo-mb.png',
                    width: 120,
                    height: 120,
                  ),
                  Image.asset(
                    'assets/images/logo_vietgr_payment.png',
                    width: 120,
                    height: 120,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Đăng ký xong ngay',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: DefaultTheme.COLOR_141CD6),
                  ),
                  const Text(
                    'Tiền về liền tay',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: DefaultTheme.COLOR_141CD6),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Miễn phí chọn số tài khoản trùng số điện thoại',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: DefaultTheme.COLOR_F4272A),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nhận ngay 30.000 VND khi đăng ký thành công',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: DefaultTheme.COLOR_141CD6),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Cơ hội ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: DefaultTheme.COLOR_141CD6),
                        ),
                        TextSpan(
                          text: 'nhận thêm 10.000.000 VND++',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: DefaultTheme.COLOR_F4272A),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'khi giới thiệu bạn bè, người thân sử dụng App MBBank',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: DefaultTheme.COLOR_141CD6),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'App MBBank - miễn phí chuyển khoản liên ngân hàng trọn đời và lựa chọn tài khoản Số đẹp miễn phí',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: DefaultTheme.COLOR_141CD6),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              GestureDetector(
                onTap: _launchUrl,
                child: BoxLayout(
                  width: width / 2 - 40,
                  height: 40,
                  bgColor: DefaultTheme.WHITE,
                  borderRadius: 5,
                  enableShadow: true,
                  alignment: Alignment.center,
                  child: Text(
                    'Đăng ký ngay'.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: DefaultTheme.COLOR_141CD6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final Uri _url = Uri.parse('https://l.linklyhq.com/l/1nyVv');

  Future<void> _launchUrl() async {
    if (!await canLaunchUrl(_url)) {
      throw Exception('Could not launch $_url');
    } else {
      await launchUrl(_url, mode: LaunchMode.externalApplication);
    }
  }
}
