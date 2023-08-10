import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/utils/log.dart';
import 'package:vierqr/commons/utils/platform_utils.dart';
import 'package:vierqr/commons/widgets/dialog_widget.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Dịch vụ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 8,
        ),
        _buildListService(context)
      ],
    );
  }

  Widget _buildListService(BuildContext context) {
    return Wrap(
      runSpacing: 16,
      children: [
        _buildItemService(
            context, 'assets/images/ic-phone-money.png', 'Nạp tiền\nđiện thoại',
            () {
          Navigator.pushNamed(context, Routes.MOBILE_RECHARGE);
        }),
        _buildItemService(context, 'assets/images/ic-mb.png', 'Mở TK\nMB Bank',
            () {
          _launchUrl();
        }),
        _buildItemService(
            context, 'assets/images/ic-login-web.png', 'Đăng nhập\nweb', () {
          DialogWidget.instance.openMsgDialog(
            title: 'Tính năng đang bảo trì',
            msg: 'Vui lòng thử lại sau',
          );
        }),
        _buildItemService(
            context, 'assets/images/logo-vqr-k.png', 'VietQR Kiot\n', () async {
          if (PlatformUtils.instance.isAndroidApp()) {
            final intent = AndroidIntent(
                action: 'action_view',
                data: Uri.encodeFull(
                    'https://play.google.com/store/apps/details?id=com.vietqr.kiot&hl=en_US'),
                package: 'com.vietqr.kiot');
            intent.launch();
          } else if (PlatformUtils.instance.isIOsApp()) {
            await DialogWidget.instance.openMsgDialog(
              title: 'Thông báo',
              msg:
                  'Chúng tôi đang bảo trì VietQR Kiot cho nền tảng iOS. Tính năng này sẽ sớm phụ vụ quý khách.',
              function: () {
                Navigator.pop(context);
              },
            );
          }
        }),
        _buildItemService(
            context, 'assets/images/logo-telegram.png', 'Telegram', () async {
          Navigator.pushNamed(context, Routes.CONNECT_TELEGRAM);
        }),
        _buildItemService(context, 'assets/images/logo-lark.png', 'Lark',
            () async {
          Navigator.pushNamed(context, Routes.CONNECT_LARK);
        }),
      ],
    );
  }

  Future<void> _launchUrl() async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'https://play.google.com/store/search?q=mbbank&c=apps&hl=vi-VN';
    } else {
      url = 'https://apps.apple.com/vn/app/mb-bank/id1205807363?l=vi';
    }

    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  Widget _buildItemService(
      BuildContext context, String pathIcon, String title, VoidCallback onTap) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: getDeviceType() == 'phone' ? width / 5 - 7 : 70,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              pathIcon,
              height: 36,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  String getDeviceType() {
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return data.size.shortestSide < 600 ? 'phone' : 'tablet';
  }
}
