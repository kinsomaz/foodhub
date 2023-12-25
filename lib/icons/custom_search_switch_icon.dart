import 'package:flutter/material.dart';

class CustomSearchSwitchIcon extends StatelessWidget {
  const CustomSearchSwitchIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: MyPainter(),
      size: const Size(22, 20),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Create a paint object for drawing
    final Paint paint = Paint();

    // Draw the strokes and shapes
    paint.color = Colors.transparent; // No fill
    paint.strokeWidth = 2;
    paint.strokeCap = StrokeCap.round;

    // Draw the first stroke line
    paint.color = const Color(0xFFFE724C);
    canvas.drawLine(
        const Offset(1.85918, 16.1233), const Offset(8.38818, 16.1233), paint);

    // Draw the second stroke line with opacity
    paint.color = const Color(0xFFFE724C).withOpacity(0.25);
    canvas.drawLine(
        const Offset(8.38814, 16.1233), const Offset(20.1401, 16.1233), paint);

    // Draw the first filled circle
    paint.color = const Color(0xFFFE724C);
    paint.strokeWidth = 1.5;
    canvas.drawCircle(const Offset(7.7061, 16), 3, paint);

    // Draw the third stroke line
    paint.color = const Color(0xFFFE724C);
    paint.strokeWidth = 2;
    canvas.drawLine(
        const Offset(13.6113, 3.87671), const Offset(20.1403, 3.87671), paint);

    // Draw the fourth stroke line with opacity
    paint.color = const Color(0xFFFE724C).withOpacity(0.25);
    canvas.drawLine(
        const Offset(1.85938, 3.87671), const Offset(13.6114, 3.87671), paint);

    // Draw the second filled circle with offset
    paint.color = const Color(0xFFFE724C);
    paint.strokeWidth = 1.5;
    canvas.drawCircle(const Offset(14.593, 4), 3, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
