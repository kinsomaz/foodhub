import 'package:flutter/material.dart';

class ZigZagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const double spaceBetweenZigzags =
        5.0; // Adjust this value to control spacing
    const double zigzagWidth =
        10.0; // Adjust this value to control the width of each zigzag

    double currentPosition = -zigzagWidth / 2; // Shift starting point
    while (currentPosition < size.width) {
      final Path path = Path()
        ..moveTo(currentPosition, size.height)
        ..lineTo(currentPosition + zigzagWidth / 2,
            size.height - spaceBetweenZigzags / 2)
        ..lineTo(currentPosition + zigzagWidth, size.height);

      canvas.drawPath(path, paint);
      currentPosition += zigzagWidth;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
