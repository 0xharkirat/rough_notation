// lib/src/painters/underline_painter.dart
import 'dart:math';
import 'package:flutter/material.dart';

enum LinePainterType { underline, strikeThrough }

class LinePainter extends CustomPainter {
  final Color color;
  final double progress;
  final double strokeWidth;
  final int seed;
  final LinePainterType type;

  LinePainter({
    required this.color,
    required this.progress,
    this.strokeWidth = 2.0,
    this.seed = 0,
    this.type = LinePainterType.underline,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final baselineY = type == LinePainterType.underline 
      ? size.height - 5 
      : size.height / 2 + 2;
    final width = size.width;

    final rand1 = Random(seed); // first stroke
    final rand2 = Random(seed + 1); // second stroke (slightly different seed)



    Path buildPath(Random rand, bool reverse, {int yOffset = 0}) {
      final path = Path();
      final segments = rand.nextInt(6) + 4;
      // print segments for debugging

      final segmentWidth = width / segments;

      if (!reverse) {
        path.moveTo(0, baselineY);
        for (int i = 1; i <= segments; i++) {
          final x = i * segmentWidth;
          final jitterY = rand.nextDouble() * 4 - 2;
          path.lineTo(x, baselineY + yOffset + jitterY);
        }
      } else {
        path.moveTo(width, baselineY);
        for (int i = 1; i <= segments; i++) {
          final x = width - (i * segmentWidth);
          final jitterY = rand.nextDouble() * 4 - 2;
          path.lineTo(x, baselineY + yOffset + jitterY);
        }
      }

      return path;
    }

    final randYOffset = Random(seed + 3).nextInt(7) - 3;
    final firstPath = buildPath(rand1, false); // left to right
    final secondPath = buildPath(
      rand2,
      true,
      yOffset: randYOffset,
    ); // right to left

    // Split animation
    final stroke1Progress = (progress.clamp(0.0, 0.5)) * 2;
    final stroke2Progress = ((progress - 0.5).clamp(0.0, 0.5)) * 2;

    // First stroke
    if (stroke1Progress > 0) {
      final clipWidth = width * stroke1Progress;
      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, 0, clipWidth, size.height + 20));
      canvas.drawPath(firstPath, paint);
      canvas.restore();
    }

    // Second stroke
    if (stroke2Progress > 0) {
      final clipWidth = width * stroke2Progress;
      canvas.save();
      canvas.clipRect(
        Rect.fromLTWH(width - clipWidth, 0, clipWidth, size.height + 20),
      );
      canvas.drawPath(secondPath, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.seed != seed ||
        oldDelegate.type != type;
  }
}
