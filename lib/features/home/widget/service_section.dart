import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
import 'package:vierqr/commons/utils/log.dart';
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
    return Row(
      children: [
        _buildItemService(
            'assets/images/ic-phone-money.png', 'Nạp tiền\nđiện thoại', () {
          DialogWidget.instance.openMsgDialog(
            title: 'Tính năng đang bảo trì',
            msg: 'Vui lòng thử lại sau',
          );
          // Navigator.pushNamed(context, Routes.MOBILE_RECHARGE);
        }),
        _buildItemService('assets/images/ic-mb.png', 'Mở TK\nMB Bank', () {
          _launchUrl();
        }),
        _buildItemService('assets/images/ic-login-web.png', 'Đăng nhập\nweb',
            () {
          DialogWidget.instance.openMsgDialog(
            title: 'Tính năng đang bảo trì',
            msg: 'Vui lòng thử lại sau',
          );
        }),
      ],
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

  Widget _buildItemService(String pathIcon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
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
}
