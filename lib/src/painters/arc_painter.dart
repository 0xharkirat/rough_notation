// lib/src/painters/arc_painter.dart

import 'dart:math';
import 'package:flutter/material.dart';

class SketchArc {
  final Rect bounds;
  final double fromAngle; // radians
  final double toAngle; // radians
  final double fromProgress;
  final double toProgress;
  final bool clockwise;

  const SketchArc({
    required this.bounds,
    this.fromAngle = 0,
    this.toAngle = 2 * pi,
    this.fromProgress = 0,
    this.toProgress = 1,
    this.clockwise = true,
  });
}

class ArcPainter extends CustomPainter {
  final List<SketchArc> arcs;
  final double progress;
  final Color color;
  final double strokeWidth;
  final int seed;

  ArcPainter({
    required this.arcs,
    required this.progress,
    required this.color,
    required this.strokeWidth,
    required this.seed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < arcs.length; i++) {
      final arc = arcs[i];
      final rand = Random(seed + i);

      final totalSweep = arc.toAngle - arc.fromAngle;
      final effectiveProgress = ((progress - arc.fromProgress) /
              (arc.toProgress - arc.fromProgress))
          .clamp(0.0, 1.0);
      if (effectiveProgress <= 0) continue;

      final rX = arc.bounds.width / 2;
      final rY = arc.bounds.height / 2;
      final cx = arc.bounds.left + rX;
      final cy = arc.bounds.top + rY;

      final fullSteps = 120;
      final path = Path();

      bool started = false;

      for (int j = 0; j <= fullSteps; j++) {
        final t = j / fullSteps;
        if (t > effectiveProgress) break;

        final angle = arc.fromAngle +
            (arc.clockwise ? 1 : -1) * totalSweep * t;

        final jitterAngle = angle + (rand.nextDouble() - 0.5) * 0.04;
        final radiusJitterX = rX * (0.985 + rand.nextDouble() * 0.03);
        final radiusJitterY = rY * (0.985 + rand.nextDouble() * 0.03);

        final x = cx + radiusJitterX * cos(jitterAngle);
        final y = cy + radiusJitterY * sin(jitterAngle);

        if (!started) {
          path.moveTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
        }
      }

      if (progress == 1.0) {
        path.close();
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ArcPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        seed != oldDelegate.seed ||
        arcs != oldDelegate.arcs;
  }
}
