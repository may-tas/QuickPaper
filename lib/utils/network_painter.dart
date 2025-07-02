import 'package:flutter/material.dart';

class NetworkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha((0.1 * 255).toInt())
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final random = DateTime.now().millisecondsSinceEpoch;
    final points = List.generate(
      10,
      (i) => Offset(
        (random + i * 50) % size.width,
        (random + i * 70) % size.height,
      ),
    );

    for (var i = 0; i < points.length; i++) {
      for (var j = i + 1; j < points.length; j++) {
        canvas.drawLine(points[i], points[j], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
