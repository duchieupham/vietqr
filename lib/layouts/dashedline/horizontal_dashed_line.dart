import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class HorizontalDashedLine extends CustomPainter {
  final double dashWidth;
  final double dashSpace;
  final Color color;

  HorizontalDashedLine({
    required this.dashWidth,
    required this.dashSpace,
    this.color = AppColor.GREY_DADADA,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = size.height // The height of the line
      ..style = PaintingStyle.stroke;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // Assuming the line doesn't need to repaint
  }
}
