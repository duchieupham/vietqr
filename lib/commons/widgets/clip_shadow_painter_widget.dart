import 'package:flutter/material.dart';

class ClipShadowPainterWidget extends CustomPainter {
  const ClipShadowPainterWidget({
    required this.clipper,
    required this.shadows,
  });

  final CustomClipper<Path> clipper;
  final List<BoxShadow> shadows;

  @override
  void paint(Canvas canvas, Size size) {
    for (final shadow in shadows) {
      final spreadSize = Size(
        size.width + shadow.spreadRadius * 2,
        size.height + shadow.spreadRadius * 2,
      );
      final clipPath = clipper.getClip(spreadSize).shift(
            Offset(
              shadow.offset.dx - shadow.spreadRadius,
              shadow.offset.dy - shadow.spreadRadius,
            ),
          );
      final paint = shadow.toPaint();
      canvas.drawPath(clipPath, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}