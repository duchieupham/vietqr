import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final double? width;

  //height default 50
  final String text;
  final Color textColor;
  final Color bgColor;
  final VoidCallback function;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final bool enableShadow;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  const ButtonWidget({
    super.key,
    this.width,
    required this.text,
    required this.textColor,
    required this.bgColor,
    required this.function,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.margin,
    this.padding,
    this.enableShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: Container(
        width: width,
        height: (height != null) ? height : 50,
        margin: margin,
        padding: padding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: enableShadow
              ? [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ]
              : null,
          borderRadius: BorderRadius.circular(
              (borderRadius != null) ? borderRadius! : 15),
          color: bgColor,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: textColor, fontSize: fontSize ?? 16),
        ),
      ),
    );
  }
}
