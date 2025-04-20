// lib/src/painters/arc_painter.dart

import 'dart:math';
import 'package:flutter/material.dart';

/// A model that represents a sketch-style arc with jittered edges.
///
/// Used specifically for drawing hand-drawn style circles or ellipses.
class SketchArc {
  /// The bounding box of the ellipse or circle.
  final Rect bounds;

  /// Start angle of the arc in radians.
  final double fromAngle;

  /// End angle of the arc in radians.
  final double toAngle;

  /// Animation start progress (from 0.0 to 1.0).
  final double fromProgress;

  /// Animation end progress (from 0.0 to 1.0).
  final double toProgress;

  /// Whether to draw in a clockwise direction.
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

/// Custom painter that draws animated sketch-style arcs (circles/ellipses).
///
/// Used by [RoughCircleAnnotation].
class ArcPainter extends CustomPainter {
  /// List of arcs to draw.
  final List<SketchArc> arcs;

  /// Current animation progress (0.0 to 1.0).
  final double progress;

  /// Stroke color.
  final Color color;

  /// Stroke width of the arc.
  final double strokeWidth;

  /// Seed to control randomness (for consistent jitter).
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
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    for (int i = 0; i < arcs.length; i++) {
      final arc = arcs[i];
      final rand = Random(seed + i);

      final totalSweep = arc.toAngle - arc.fromAngle;

      // Compute the local animation progress for this arc
      final effectiveProgress = ((progress - arc.fromProgress) /
              (arc.toProgress - arc.fromProgress))
          .clamp(0.0, 1.0);
      if (effectiveProgress <= 0) continue;

      // Center and radii
      final rX = arc.bounds.width / 2;
      final rY = arc.bounds.height / 2;
      final cx = arc.bounds.left + rX;
      final cy = arc.bounds.top + rY;

      const fullSteps = 120; // number of segments in full arc
      final path = Path();
      bool started = false;

      // Generate jittered arc path
      for (int j = 0; j <= fullSteps; j++) {
        final t = j / fullSteps;
        if (t > effectiveProgress) break;

        final angle = arc.fromAngle + (arc.clockwise ? 1 : -1) * totalSweep * t;

        // Add slight jitter to angle and radius
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

      // Close the path if animation is completed
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
