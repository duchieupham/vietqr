import 'dart:ui';

import 'package:flutter/material.dart';

class BlurLayout extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  final double? borderRadius;
  final double? opacity;
  final double? blur;

  const BlurLayout({
    Key? key,
    required this.width,
    required this.height,
    required this.child,
    this.borderRadius,
    this.opacity,
    this.blur,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        (borderRadius != null) ? borderRadius! : 20,
      ),
      child: BackdropFilter(
        filter: (blur != null)
            ? ImageFilter.blur(sigmaX: blur!, sigmaY: blur!)
            : ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              (borderRadius != null) ? borderRadius! : 20,
            ),
            color: Theme.of(context).cardColor.withOpacity(
                  (opacity != null) ? opacity! : 0.8,
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}
