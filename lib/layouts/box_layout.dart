import 'package:flutter/material.dart';

class BoxLayout extends StatelessWidget {
  final double width;
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;
  final double? height;
  final Color? bgColor;
  final bool? enableShadow;
  final Alignment? alignment;
  final EdgeInsets? margin;

  const BoxLayout({
    super.key,
    required this.width,
    required this.child,
    this.padding,
    this.borderRadius,
    this.height,
    this.bgColor,
    this.enableShadow,
    this.alignment,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      margin: margin,
      padding: (padding != null)
          ? padding
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: (bgColor != null) ? bgColor! : Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular((borderRadius != null) ? borderRadius! : 15),
        boxShadow: (enableShadow != null && enableShadow!)
            ? [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(1, 2),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}
