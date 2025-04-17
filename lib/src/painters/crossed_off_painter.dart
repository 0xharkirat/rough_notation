// lib/src/painters/crossed_off_painter.dart
import 'dart:math';
import 'package:flutter/material.dart';

class CrossedOffPainter extends CustomPainter {
  final Color color;
  final double progress;
  final double strokeWidth;
  final int seed;

  CrossedOffPainter({
    required this.color,
    required this.progress,
    required this.seed,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rand = Random(seed);
    final segments = rand.nextInt(6) + 4;

    Path buildDiagonal(bool reverse, bool flip) {
      final path = Path();
      final segmentWidth = size.width / segments;

      if (!reverse) {
        path.moveTo(flip ? size.width : 0, 0);
        for (int i = 1; i <= segments; i++) {
          final x = i * segmentWidth;
          final fx = flip ? size.width - x : x;
          final fy = (x * size.height / size.width);
          final jitterX = rand.nextDouble() * 4 - 2;
          final jitterY = rand.nextDouble() * 4 - 2;
          path.lineTo(fx + jitterX, fy + jitterY);
        }
      } else {
        path.moveTo(flip ? 0 : size.width, size.height);
        for (int i = 1; i <= segments; i++) {
          final x = i * segmentWidth;
          final fx = flip ? x : size.width - x;
          final fy = size.height - (x * size.height / size.width);
          final jitterX = rand.nextDouble() * 4 - 2;
          final jitterY = rand.nextDouble() * 4 - 2;
          path.lineTo(fx + jitterX, fy + jitterY);
        }
      }

      return path;
    }

    final quarter = progress.clamp(0.0, 1.0) * 4;

    if (quarter > 0) {
      final path = buildDiagonal(false, false);
      final clipWidth = size.width * quarter.clamp(0.0, 1.0);
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, 0, clipWidth, size.height + 20));
      canvas.drawPath(path, paint);
      canvas.restore();
    }

    if (quarter > 1) {
      final path = buildDiagonal(true, false);
      final clipWidth = size.width * (quarter - 1).clamp(0.0, 1.0);
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(size.width - clipWidth, 0, clipWidth, size.height + 20));
      canvas.drawPath(path, paint);
      canvas.restore();
    }

    if (quarter > 2) {
      final path = buildDiagonal(false, true);
      final clipWidth = size.width * (quarter - 2).clamp(0.0, 1.0);
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, 0, clipWidth, size.height + 20));
      canvas.drawPath(path, paint);
      canvas.restore();
    }

    if (quarter > 3) {
      final path = buildDiagonal(true, true);
      final clipWidth = size.width * (quarter - 3).clamp(0.0, 1.0);
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(size.width - clipWidth, 0, clipWidth, size.height + 20));
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CrossedOffPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.seed != seed;
  }
}