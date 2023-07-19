import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/layouts/box_layout.dart';

class IntroduceScreen extends StatelessWidget {
  const IntroduceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
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
                  Text(
                    'Đăng ký xong ngay',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Theme.of(context).focusColor),
                  ),
                  Text(
                    'Tiền về liền tay',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Theme.of(context).focusColor),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Miễn phí chọn số tài khoản trùng số điện thoại',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColor.RED_MB),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nhận ngay 30.000 VND khi đăng ký thành công',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).focusColor),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Cơ hội ',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).focusColor),
                        ),
                        const TextSpan(
                          text: 'nhận thêm 10.000.000 VND++',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColor.RED_MB),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'khi giới thiệu bạn bè, người thân sử dụng App MBBank',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).focusColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'App MBBank - miễn phí chuyển khoản liên ngân hàng trọn đời và lựa chọn tài khoản Số đẹp miễn phí',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).focusColor),
                  ),
                ],
              ),
              const SizedBox(height: 36),
              BoxLayout(
                width: width / 2 - 40,
                height: 40,
                padding: const EdgeInsets.all(0),
                bgColor: Theme.of(context).cardColor,
                borderRadius: 5,
                enableShadow: true,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: _launchUrl,
                  child: Text(
                    'Đăng ký ngay'.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Theme.of(context).focusColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://l.linklyhq.com/l/1nyVv');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
