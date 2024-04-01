import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class MButtonIconWidget extends StatelessWidget {
  final double? width, height;
  final IconData? icon;
  final String title;
  final VoidCallback onTap;
  final Color? bgColor, textColor, iconColor;
  final double? textSize, iconSize;
  final double borderRadius;
  final EdgeInsets padding;
  final BoxBorder? border;
  final String? pathIcon;

  const MButtonIconWidget({
    super.key,
    this.width,
    this.height = 40,
    this.icon,
    required this.title,
    required this.onTap,
    this.bgColor,
    this.textColor = AppColor.BLACK,
    this.iconColor,
    this.textSize = 12,
    this.borderRadius = 5,
    this.iconSize,
    this.border,
    this.padding = const EdgeInsets.fromLTRB(6, 5, 12, 5),
    this.pathIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (pathIcon != null)
              Image.asset(
                pathIcon!,
                width: iconSize ?? 25,
              )
            else ...[
              Icon(icon, color: iconColor, size: iconSize),
              const SizedBox(width: 6),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: textSize,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
