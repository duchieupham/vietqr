import 'package:flutter/material.dart';
import 'package:vierqr/commons/constants/configurations/theme.dart';

class VerticalDashedLine extends StatelessWidget {
  final Color color;
  final double height;

  const VerticalDashedLine({
    Key? key,
    this.color = AppColor.GREY_DADADA,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: VerticalDashedLinePainter(color: color),
      ),
    );
  }
}

class VerticalDashedLinePainter extends CustomPainter {
  final Color color;

  VerticalDashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1 // Độ dày của đường gạch
      ..style = PaintingStyle.stroke;

    const dashHeight = 5.0; // Chiều dài mỗi đoạn gạch
    const dashSpace = 5.0; // Khoảng cách giữa các đoạn gạch

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(
            0,
            startY + dashHeight < size.height
                ? startY + dashHeight
                : size.height), // Đảm bảo không vượt quá kích thước chiều cao
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(VerticalDashedLinePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(VerticalDashedLinePainter oldDelegate) => false;
}
