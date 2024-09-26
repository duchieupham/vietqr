import 'package:flutter/material.dart';

class GradientBorderButton extends StatelessWidget {
  final Widget widget;
  final BorderRadius borderRadius;
  final double borderWidth;
  final Gradient gradient;
  final EdgeInsetsGeometry? margin;

  const GradientBorderButton({
    super.key,
    required this.widget,
    required this.borderRadius,
    required this.borderWidth,
    required this.gradient,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
        child: widget,
      ),
    );
  }
}
