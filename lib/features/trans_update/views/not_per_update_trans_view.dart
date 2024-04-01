import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/app_images.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/button/m_button_icon_widget.dart';

class NotPerUpdateTransView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(AppImages.icTimeOutTrans, width: 120),
        Text(
          'Bạn không có quyền\ncập nhật thông tin cửa hàng\ncho giao dịch này.',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.BLACK,
          ),
        ),
        const Spacer(),
        MButtonIconWidget(
          icon: Icons.check,
          iconSize: 14,
          iconColor: AppColor.WHITE,
          title: 'Hoàn thành',
          onTap: () => Navigator.pop(context),
          border: Border.all(color: AppColor.BLUE_TEXT),
          bgColor: AppColor.BLUE_TEXT,
          textColor: AppColor.WHITE,
        ),
      ],
    );
  }
}
