import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

enum VietQRButtonType { gradient, outlined, solid }

enum VietQRButtonSize { small, medium, large }

class VietQRButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool? onHover;
  final double? padding;
  final VietQRButtonType type;
  final VietQRButtonSize size;
  final Color? bgColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final bool isDisabled;

  const VietQRButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.type = VietQRButtonType.gradient,
    this.bgColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.size = VietQRButtonSize.medium,
    this.onHover,
    required this.isDisabled,
  });

  const VietQRButton.solid({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.bgColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.size = VietQRButtonSize.medium,
    this.onHover,
    required this.isDisabled,
  }) : type = VietQRButtonType.solid;
  const VietQRButton.outlined({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.bgColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.size = VietQRButtonSize.medium,
    this.onHover,
    required this.isDisabled,
  }) : type = VietQRButtonType.outlined;
  const VietQRButton.gradient({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.bgColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.size = VietQRButtonSize.medium,
    this.onHover,
    required this.isDisabled,
  }) : type = VietQRButtonType.gradient;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case VietQRButtonType.solid:
        return InkWell(
          onHover: (onHover) {},
          onTap: isDisabled ? null : onPressed,
          child: Container(
              width: width,
              height: height ??
                  (size == VietQRButtonSize.large
                      ? 50
                      : size == VietQRButtonSize.medium
                          ? 40
                          : 30),
              padding: EdgeInsets.all(padding ??
                  (size == VietQRButtonSize.large
                      ? 10
                      : size == VietQRButtonSize.medium
                          ? 8
                          : 6)),
              decoration: BoxDecoration(
                // color: isDisabled
                //     ? AppColor.BLUE_BGR
                //     : bgColor ?? AppColor.BLUE_TEXT,
                gradient: isDisabled
                    ? VietQRTheme.gradientColor.disableLinear
                    : VietQRTheme.gradientColor.lilyLinear,
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
                // border: Border.all(
                //   color: AppColor.BLUE_TEXT,
                //   width: 1,
                //   style: isDisabled ? BorderStyle.none : BorderStyle.solid,
                // ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Color.fromRGBO(21, 126, 52, 0.8),
                //     offset: isDisabled ? Offset(0, 0) : Offset(0, 3),
                //   ),
                // ],
              ),
              child: child),
        );
      case VietQRButtonType.gradient:
        return InkWell(
          onTap: onPressed,
          child: Container(
              width: width,
              height: height ?? 50,
              padding: EdgeInsets.all(padding ??
                  (size == VietQRButtonSize.large
                      ? 10
                      : size == VietQRButtonSize.medium
                          ? 8
                          : 6)),
              decoration: BoxDecoration(
                gradient: isDisabled
                    ? VietQRTheme.gradientColor.disableLinear
                    : VietQRTheme.gradientColor.brightBlueLinear,
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
                // boxShadow: [
                //   BoxShadow(
                //     color: Color.fromRGBO(21, 126, 52, 0.8),
                //     offset: isDisabled ? Offset(0, 0) : Offset(0, 3),
                //   ),
                // ],
              ),
              child: child),
        );
      case VietQRButtonType.outlined:
        return InkWell(
          onTap: () {},
          child: Container(
              width: width,
              height: height ?? 50,
              padding: EdgeInsets.all(padding ??
                  (size == VietQRButtonSize.large
                      ? 10
                      : size == VietQRButtonSize.medium
                          ? 8
                          : 6)),
              decoration: BoxDecoration(
                color: isDisabled ? AppColor.BLUE_BGR : bgColor ?? Colors.white,
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
                border: Border.all(
                  color: isDisabled ? AppColor.BLUE_BGR : AppColor.BLUE_TEXT,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Color.fromRGBO(21, 126, 52, 0.8),
                //     offset: isDisabled ? Offset(0, 0) : Offset(0, 3),
                //   ),
                // ],
              ),
              child: child),
        );
      default:
        return InkWell(
          onTap: onPressed,
          child: Container(
              width: width,
              height: height,
              padding: EdgeInsets.all(padding ??
                  (size == VietQRButtonSize.large
                      ? 10
                      : size == VietQRButtonSize.medium
                          ? 8
                          : 6)),
              decoration: BoxDecoration(
                color: isDisabled
                    ? AppColor.BLUE_BGR
                    : bgColor ?? AppColor.BLUE_TEXT,
                borderRadius: BorderRadius.circular(borderRadius ??
                    (size == VietQRButtonSize.large
                        ? 10
                        : size == VietQRButtonSize.medium
                            ? 8
                            : 6)),
                border: Border.all(
                  color: AppColor.BLUE_TEXT,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: Color.fromRGBO(21, 126, 52, 0.8),
                //     offset: Offset(0, 3),
                //   ),
                // ],
              ),
              child: child),
        );
    }
  }
}
