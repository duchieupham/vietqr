import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.scanWindow,
    this.borderRadius = 12.0,
    this.cornerRadius = 40.0, // Radius of the curved corners
    this.cornerThickness = 3.0, // Thickness of the curved corners
  });

  final Rect scanWindow;
  final double borderRadius;
  final double cornerRadius;
  final double cornerThickness;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // canvas.drawPath(backgroundWithCutout, backgroundPaint);
    // canvas.drawRRect(borderRect, borderPaint);

    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = cornerThickness;

    // Top-left corner (draw an arc)
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(scanWindow.left + cornerRadius, scanWindow.top + cornerRadius),
        radius: cornerRadius,
      ),
      -pi, // Start at 180 degrees (left side)
      pi / 2, // Sweep 90 degrees clockwise
      false,
      cornerPaint,
    );

    // Top-right corner (draw an arc)
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(scanWindow.right - cornerRadius, scanWindow.top + cornerRadius),
        radius: cornerRadius,
      ),
      -pi / 2, // Start at 270 degrees (top side)
      pi / 2, // Sweep 90 degrees clockwise
      false,
      cornerPaint,
    );

    // Bottom-left corner (draw an arc)
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(scanWindow.left + cornerRadius, scanWindow.bottom - cornerRadius),
        radius: cornerRadius,
      ),
      pi / 2, // Start at 90 degrees (bottom side)
      pi / 2, // Sweep 90 degrees clockwise
      false,
      cornerPaint,
    );

    // Bottom-right corner (draw an arc)
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(scanWindow.right - cornerRadius, scanWindow.bottom - cornerRadius),
        radius: cornerRadius,
      ),
      0, // Start at 0 degrees (right side)
      pi / 2, // Sweep 90 degrees clockwise
      false,
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) {
    return scanWindow != oldDelegate.scanWindow ||
        borderRadius != oldDelegate.borderRadius;
  }
}