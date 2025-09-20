import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class QrScannerOverlay extends StatelessWidget {
  const QrScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        shape: _QrScannerOverlayShape(),
      ),
    );
  }
}

class _QrScannerOverlayShape extends ShapeBorder {
  const _QrScannerOverlayShape();

  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const double scanAreaSize = 250.0;
    final double left = (rect.width - scanAreaSize) / 2;
    final double top = (rect.height - scanAreaSize) / 2;
    final Rect scanArea = Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize);

    return Path()
      ..addRect(rect)
      ..addRRect(RRect.fromRectAndRadius(scanArea, const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    const double scanAreaSize = 250.0;
    final double left = (rect.width - scanAreaSize) / 2;
    final double top = (rect.height - scanAreaSize) / 2;
    final Rect scanArea = Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize);

    // Draw overlay
    final Paint overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6);
    canvas.drawPath(getOuterPath(rect), overlayPaint);

    // Draw scan area border
    final Paint borderPaint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    final RRect scanAreaRRect = RRect.fromRectAndRadius(
      scanArea,
      const Radius.circular(12),
    );
    canvas.drawRRect(scanAreaRRect, borderPaint);

    // Draw corner indicators
    final Paint cornerPaint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 20.0;
    final double cornerRadius = 12.0;
    
    // Top-left corner
    canvas.drawLine(
      Offset(scanArea.left + cornerRadius, scanArea.top),
      Offset(scanArea.left + cornerRadius + cornerLength, scanArea.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanArea.left, scanArea.top + cornerRadius),
      Offset(scanArea.left, scanArea.top + cornerRadius + cornerLength),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(scanArea.right - cornerRadius - cornerLength, scanArea.top),
      Offset(scanArea.right - cornerRadius, scanArea.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanArea.right, scanArea.top + cornerRadius),
      Offset(scanArea.right, scanArea.top + cornerRadius + cornerLength),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(scanArea.left + cornerRadius, scanArea.bottom),
      Offset(scanArea.left + cornerRadius + cornerLength, scanArea.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanArea.left, scanArea.bottom - cornerRadius - cornerLength),
      Offset(scanArea.left, scanArea.bottom - cornerRadius),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(scanArea.right - cornerRadius - cornerLength, scanArea.bottom),
      Offset(scanArea.right - cornerRadius, scanArea.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(scanArea.right, scanArea.bottom - cornerRadius - cornerLength),
      Offset(scanArea.right, scanArea.bottom - cornerRadius),
      cornerPaint,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}