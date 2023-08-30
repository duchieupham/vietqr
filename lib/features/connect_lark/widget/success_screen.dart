import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_button_widget.dart';
import 'package:vierqr/layouts/m_app_bar.dart';

class ConnectLarkSuccess extends StatelessWidget {
  const ConnectLarkSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MAppBar(title: 'Kết nối Lark'),
      body: _buildBlankWidget(context),
    );
  }

  Widget _buildBlankWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Spacer(),
          Image.asset(
            'assets/images/logo-lark.png',
            width: 80,
            height: 80,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            'Kết nối thành công',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Cảm ơn quý khách đã sử dụng dịch vụ\nVietQR VN của chúng tôi',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          MButtonWidget(
            title: 'Hoàn tất',
            isEnable: true,
            margin: EdgeInsets.zero,
            colorEnableText: AppColor.WHITE,
            onTap: () async {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
