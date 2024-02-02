import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  final double width;

  DottedLinePainter(this.width);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey[400]!
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    double dashWidth = width;
    double dashSpace = 2;

    double startY = 1;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
