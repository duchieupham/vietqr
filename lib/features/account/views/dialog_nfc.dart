import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/utils/navigator_utils.dart';
import 'package:vierqr/layouts/m_button_widget.dart';

class DialogNFC extends StatelessWidget {
  final String msg;
  final GestureTapCallback? onTap;

  const DialogNFC({super.key, required this.msg, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/ic-warning.png',
                width: 80,
                height: 80,
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              const Text(
                'Không thể liên kết',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              const SizedBox(
                width: 250,
                height: 60,
                child: Text(
                  'Thẻ này đã được gán cho tài khoản VietQR khác. Vui lòng thử lại sau',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              MButtonWidget(
                title: 'Thử lại',
                isEnable: true,
                margin: EdgeInsets.zero,
                onTap: onTap,
              ),
              const SizedBox(height: 10),
              MButtonWidget(
                title: 'Trang chủ',
                margin: EdgeInsets.zero,
                colorEnableBgr: AppColor.BLUE_TEXT.withOpacity(0.4),
                colorEnableText: AppColor.BLUE_TEXT,
                isEnable: true,
                onTap: () {
                  NavigatorUtils.navigateToRoot(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
