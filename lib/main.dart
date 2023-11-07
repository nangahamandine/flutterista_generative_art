import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: Scaffold(body: GenerativeHearts())));

class GenerativeHearts extends StatelessWidget {
  const GenerativeHearts({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: HeartPainter(),
        size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
      ),
    );
  }
}

class HeartPainter extends CustomPainter {
  final List<Color> orangeShades = [
    Colors.deepOrange.shade50,
    Colors.deepOrange.shade100,
    Colors.deepOrange.shade200,
    Colors.deepOrange.shade300,
    Colors.deepOrange.shade400,
    Colors.deepOrange.shade500,
    Colors.deepOrange.shade600,
    Colors.deepOrange.shade700,
    Colors.deepOrange.shade800,
    Colors.deepOrange.shade900,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Gradient gradient = RadialGradient(
      center: Alignment.center,
      radius: 0.5,
      colors: [Colors.grey.shade900, Colors.black],
      stops: const [0.0, 1.0],
    );

    Paint gradientPaint = Paint()..shader = gradient.createShader(
        Rect.fromCircle(center: size.center(Offset.zero), radius: size.width / 2));

    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), gradientPaint);

    final double baseOvalWidth = size.width * 0.25;
    final double baseOvalHeight = size.height * 0.25;
    const int layers = 5; // Number of heart layers
    final double layerSpacing = size.width * 0.03; // Spacing between each layer

    // Multiple layers of hearts
    for (int j = 0; j < layers; j++) {
      double ovalWidth = baseOvalWidth - j * layerSpacing;
      double ovalHeight = baseOvalHeight - j * layerSpacing;

      // To position art slightly above the center
      final Offset ovalCenter = size.center(Offset(0, -size.height * 0.05 - j * layerSpacing / 2));
      const int heartCount = 100;

      for (int i = 0; i < heartCount; i++) {
        double angle = (2 * pi / heartCount) * i;
        double x = ovalCenter.dx + ovalWidth * cos(angle);
        double y = ovalCenter.dy + ovalHeight * sin(angle);
        double rotationAngle = atan2(ovalHeight * cos(angle), -ovalWidth * sin(angle));

        // Size of the hearts proportional to the size of the oval
        double width = ovalWidth / 10;
        double height = width * 1.2;

        Rect rect = Rect.fromCenter(center: Offset(x, y), width: width, height: height);
        Paint paint = Paint()..color = orangeShades[(i + j) % orangeShades.length];

        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(rotationAngle);
        canvas.translate(-x, -y);
        drawHeart(canvas, rect, paint);
        canvas.restore();
      }
    }
  }

  void drawHeart(Canvas canvas, Rect rect, Paint paint) {
    Path path = Path();
    double width = rect.width;
    double height = rect.height;
    double x = rect.left;
    double y = rect.top;

    path.moveTo(x + width / 2, y + height / 4);
    path.cubicTo(x + width / 4, y, x, y + height / 2, x + width / 2, y + (3 * height / 4));
    path.cubicTo(x + width, y + height / 2, x + (3 * width / 4), y, x + width / 2, y + height / 4);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
