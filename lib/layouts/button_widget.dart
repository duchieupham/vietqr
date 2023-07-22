import 'package:flutter/cupertino.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class MButtonWidget extends StatelessWidget {
  final String title;
  final GestureTapCallback? onTap;
  final bool isEnable;
  final EdgeInsetsGeometry? margin;
  final Color? colorEnableBgr;
  final Color? colorDisableBgr;
  final Color? colorEnableText;
  final Color? colorDisableText;
  final double? height;

  const MButtonWidget(
      {super.key,
      required this.title,
      this.margin,
      this.onTap,
      this.isEnable = false,
      this.colorEnableBgr,
      this.colorDisableBgr,
      this.colorEnableText,
      this.height,
      this.colorDisableText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnable ? onTap : null,
      child: Container(
        alignment: Alignment.center,
        margin:
            margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        height: height ?? 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isEnable
              ? colorEnableBgr ?? AppColor.BLUE_TEXT
              : colorDisableBgr ?? AppColor.WHITE,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isEnable
                ? colorEnableText ?? AppColor.WHITE
                : colorDisableText ?? AppColor.GREY_TEXT,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
