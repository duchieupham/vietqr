import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/route.dart';
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
        }),
        _buildItemService('assets/images/ic-mb.png', 'Mở TK\nMB Bank', () {
          Navigator.pushNamed(context, Routes.INTRODUCE_SCREEN);
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
              height: 42,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}
