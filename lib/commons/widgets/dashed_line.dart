import 'package:flutter/material.dart';

class VerticalDashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: VerticalDashedLinePainter(),
    );
  }
}

class VerticalDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black45
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dashHeight = 2; // Chiều dài mỗi đoạn gạch
    final dashSpace = 2; // Khoảng cách giữa các đoạn gạch

    final path = Path();
    double startPoint = 0;
    while (startPoint < size.height) {
      path.moveTo(0, startPoint);
      path.lineTo(0, startPoint + dashHeight);
      startPoint += dashHeight + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(VerticalDashedLinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(VerticalDashedLinePainter oldDelegate) => false;
}
