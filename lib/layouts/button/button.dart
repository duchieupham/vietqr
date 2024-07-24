import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';
import 'package:vierqr/layouts/image/x_image.dart';

enum VietQRButtonType { gradient, outlined, solid, suggest, other }

enum VietQRButtonSize { small, medium, large }

class VietQRButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? child;
  final bool? onHover;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VietQRButtonType type;
  final VietQRButtonSize size;
  final List<BoxShadow>? shadow;
  final String? text;
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
    this.text,
    this.margin,
    this.type = VietQRButtonType.other,
    this.shadow,
    this.bgColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.size = VietQRButtonSize.medium,
    this.onHover,
    required this.isDisabled,
  });

  const VietQRButton.suggest({
    super.key,
    required this.onPressed,
    required this.text,
    this.child,
    this.padding,
    this.margin,
    this.bgColor,
    this.shadow,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.size = VietQRButtonSize.medium,
    this.onHover,
    this.isDisabled = false,
  }) : type = VietQRButtonType.suggest;

  const VietQRButton.solid({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.text,
    this.margin,
    this.bgColor,
    this.shadow,
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
    this.text,
    this.margin,
    this.shadow,
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
    this.text,
    this.margin,
    this.shadow,
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
      case VietQRButtonType.suggest:
        return InkWell(
          onTap: isDisabled ? null : onPressed,
          child: Container(
            width: width,
            height: height ??
                (size == VietQRButtonSize.large
                    ? 50
                    : size == VietQRButtonSize.medium
                        ? 40
                        : 30),
            margin: margin,
            padding: padding ?? const EdgeInsets.fromLTRB(12, 0, 22, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(colors: [
                  Color(0xFFD8ECF8),
                  Color(0xFFFFEAD9),
                  Color(0xFFF5C9D1),
                ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const XImage(
                  imagePath: 'assets/images/ic-suggest.png',
                  width: 30,
                ),
                Text(
                  text ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColor.BLACK,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
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
              margin: margin,
              padding: padding ??
                  EdgeInsets.all(size == VietQRButtonSize.large
                      ? 10
                      : size == VietQRButtonSize.medium
                          ? 8
                          : 6),
              decoration: BoxDecoration(
                // color: isDisabled
                //     ? AppColor.BLUE_BGR
                //     : bgColor ?? AppColor.BLUE_TEXT,
                gradient: isDisabled
                    ? VietQRTheme.gradientColor.disableLinear
                    : VietQRTheme.gradientColor.lilyLinear,
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
                boxShadow: shadow ?? [],
              ),
              child: child),
        );
      case VietQRButtonType.gradient:
        return InkWell(
          onTap: onPressed,
          child: Container(
              width: width,
              height: height ?? 50,
              margin: margin,
              padding: padding ??
                  EdgeInsets.all(size == VietQRButtonSize.large
                      ? 10
                      : size == VietQRButtonSize.medium
                          ? 8
                          : 6),
              decoration: BoxDecoration(
                gradient: isDisabled
                    ? VietQRTheme.gradientColor.disableLinear
                    : VietQRTheme.gradientColor.brightBlueLinear,
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
                boxShadow: shadow ?? [],
              ),
              child: child),
        );
      case VietQRButtonType.outlined:
        return InkWell(
          onTap: () {},
          child: Container(
              width: width,
              height: height ?? 50,
              margin: margin,
              padding: padding ??
                  EdgeInsets.all(size == VietQRButtonSize.large
                      ? 10
                      : size == VietQRButtonSize.medium
                          ? 8
                          : 6),
              decoration: BoxDecoration(
                color: isDisabled ? AppColor.BLUE_BGR : bgColor ?? Colors.white,
                borderRadius: BorderRadius.circular(borderRadius ?? 5),
                border: Border.all(
                  color: isDisabled ? AppColor.BLUE_BGR : AppColor.BLUE_TEXT,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                boxShadow: shadow ?? [],
              ),
              child: child),
        );
      default:
        return InkWell(
          onTap: onPressed,
          child: Container(
              width: width,
              height: height,
              margin: margin,
              padding: padding ??
                  EdgeInsets.all(size == VietQRButtonSize.large
                      ? 10
                      : size == VietQRButtonSize.medium
                          ? 8
                          : 6),
              decoration: BoxDecoration(
                color:
                    isDisabled ? AppColor.BLUE_BGR : bgColor ?? AppColor.WHITE,
                borderRadius: BorderRadius.circular(borderRadius ??
                    (size == VietQRButtonSize.large
                        ? 10
                        : size == VietQRButtonSize.medium
                            ? 8
                            : 6)),
                // border: Border.all(
                //   color: AppColor.BLUE_TEXT,
                //   width: 1,
                //   style: BorderStyle.solid,
                // ),
                boxShadow: isDisabled
                    ? []
                    : shadow ??
                        [
                          BoxShadow(
                            color: AppColor.BLACK.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: const Offset(0, 1),
                          ),
                        ],
              ),
              child: child),
        );
    }
  }
}
