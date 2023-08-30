import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class GeneralDialog extends StatelessWidget {
  _handleOnPressedCallback(BuildContext context, Function? onPressed) {
    if (onPressed == null) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pop();
    } else {
      onPressed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  _handleOnPressedCallback(context, () {
                    Navigator.of(context).pop(true);
                  });
                },
                child: Text(
                  'Lúc khác',
                  style: TextStyle(color: AppColor.BLUE_TEXT),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Image.asset(
            "assets/images/photo_permission_guide.png",
            width: 229,
            height: 167,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.only(
              bottom: 16,
              left: 0,
              right: 0,
            ),
            child: Text(
              'Chưa cấp quyền truy cập',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: AppColor.textBlack,
              ),
              children: [
                TextSpan(text: 'Để chia sẻ hình ảnh, vui lòng cấp quyền cho '),
                TextSpan(
                  text: '"App VietQR"',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.textBlack,
                  ),
                ),
                TextSpan(text: ' truy cập ảnh, phương tiện và tệp tại mục '),
                TextSpan(
                  text: 'Cài đặt',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.textBlack,
                  ),
                ),
                TextSpan(text: ' của thiết bị.'),
              ],
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 250,
            child: MButtonWidget(
              title: 'Đi đến Cài đặt',
              isEnable: true,
              onTap: () => _handleOnPressedCallback(context, () async {
                Navigator.of(context).pop(true);
                await openAppSettings();
              }),
            ),
          ),
        ],
      ),
    );
  }
}
