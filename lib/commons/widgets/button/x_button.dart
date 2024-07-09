import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/commons/extensions/text_style_extension.dart';

import '../../constants/configurations/app_spacer.dart';

class XButton extends StatelessWidget {
  const XButton({
    super.key,
    this.buttonStyle = XButtonStyle.normal,
    this.leadingIcon,
    this.isForward = false,
    this.isDisable = false,
    this.isExpandWidth = false,
    this.borderRadius = 0.0,
    this.title,
    this.onTap,
    this.margin,
    this.padding,
    this.child,
  });

  final XButtonStyle buttonStyle;
  final Widget? leadingIcon;
  final Widget? child;
  final bool isForward;
  final bool isDisable;
  final bool isExpandWidth;
  final double borderRadius;
  final String? title;
  final Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  double get sizeIcon => 20;

  Color? get getBgColor {
    switch (buttonStyle) {
      case XButtonStyle.fill:
        if (isDisable) {
          return AppColor.GREY_BUTTON;
        }
        return AppColor.BLUE_LIGHT;
      default:
        return null;
    }
  }

  Color get getIcColor {
    switch (buttonStyle) {
      case XButtonStyle.fill:
        if (isDisable) {
          return AppColor.BLACK;
        }
        return AppColor.BLUE_TEXT;
      case XButtonStyle.gradiant:
        return AppColor.WHITE;
      default:
        return AppColor.BLUE_TEXT;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: padding ??
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: getBoxDecoration,
          child: child != null
              ? child!
              : isExpandWidth
                  ? renderExpandButton()
                  : renderSmallButton(),
        ),
      ),
    );
  }

  Widget renderExpandButton() {
    return Row(
      mainAxisSize: isExpandWidth ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[
                leadingIcon!,
                const SizedBox(width: AppSpacer.s8),
              ],
              if (title != null && title!.isNotEmpty) ...[
                Text(
                  title!,
                  style: AppFont.t.s12.blueText.copyWith(
                    color: getIcColor,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (isForward) ...[
          Icon(
            Icons.arrow_forward,
            size: sizeIcon,
            color: getIcColor,
          ),
        ]
      ],
    );
  }

  Widget renderSmallButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leadingIcon != null) ...[
          leadingIcon!,
          const SizedBox(width: AppSpacer.s8),
        ],
        if (title != null && title!.isNotEmpty) ...[
          Text(
            title!,
            style: AppFont.t.s12.blueText.copyWith(
              color: getIcColor,
            ),
          ),
        ],
      ],
    );
  }

  BoxDecoration get getBoxDecoration {
    BoxDecoration boxDecoration = const BoxDecoration();
    if (buttonStyle == XButtonStyle.fill) {
      boxDecoration = const BoxDecoration();
    }
    if (buttonStyle == XButtonStyle.outlet) {
      boxDecoration = BoxDecoration(
        border: Border.all(
          width: 1,
          color: AppColor.BLUE_LIGHT,
        ),
      );
    }
    if (buttonStyle == XButtonStyle.gradiant) {
      boxDecoration = const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.BLUE_LIGHT,
            AppColor.BLUE_TEXT,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      );
    }

    return boxDecoration.copyWith(
      borderRadius: BorderRadius.circular(borderRadius),
      color: getBgColor,
    );
  }
}

enum XButtonStyle { outlet, fill, normal, gradiant }
