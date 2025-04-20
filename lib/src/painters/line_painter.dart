// lib/src/painters/underline_painter.dart
import 'dart:math';
import 'package:flutter/material.dart';

/// Represents a single sketch-style line segment with optional progress range.
///
/// [fromProgress] and [toProgress] determine when this line should appear
/// during the animation timeline (values between 0.0 to 1.0).
class SketchLine {
  final Offset start;
  final Offset end;
  final double fromProgress;
  final double toProgress;
  final int yOffset;

  const SketchLine({
    required this.start,
    required this.end,
    this.fromProgress = 0.0,
    this.toProgress = 1.0,
    this.yOffset = 0,
  });
}

/// Custom painter responsible for drawing animated sketch-style lines.
///
/// Used by many annotations like underline, box, strike-through, etc.
class LinePainter extends CustomPainter {
  /// List of sketch lines to draw.
  final List<SketchLine> lines;

  /// Color of the lines.
  final Color color;

  /// Current animation progress from 0.0 to 1.0.
  final double progress;

  /// Stroke width of the lines.
  final double strokeWidth;

  /// Random seed to generate consistent jitter.
  final int seed;

  /// Stroke cap style for the line ends.
  final StrokeCap strokeCap;

  LinePainter({
    required this.color,
    required this.progress,
    this.strokeWidth = 2.0,
    this.seed = 0,
    required this.lines,
    this.strokeCap = StrokeCap.round,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = strokeCap;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      // Skip if progress hasn't reached this segment
      if (progress < line.fromProgress) continue;

      // Calculate local progress relative to the segment's range
      final localProgress = ((progress - line.fromProgress) /
              (line.toProgress - line.fromProgress))
          .clamp(0.0, 1.0);

      final rand = Random(seed + i);

      // Generate the sketchy path
      final fullPath = _buildSketchPath(line, rand);

      // Determine how much of the path to reveal
      final totalLength = fullPath.computeMetrics().fold(
        0.0,
        (sum, m) => sum + m.length,
      );
      final revealedLength = totalLength * localProgress;

      // Clip the full path to only draw the portion based on progress
      final clippedPath = Path();
      double currentLength = 0.0;
      for (final metric in fullPath.computeMetrics()) {
        final remaining = revealedLength - currentLength;
        final drawLength = remaining.clamp(0.0, metric.length);
        if (drawLength > 0) {
          clippedPath.addPath(metric.extractPath(0, drawLength), Offset.zero);
          currentLength += drawLength;
        } else {
          break;
        }
      }

      canvas.drawPath(clippedPath, paint);
    }
  }

  /// Builds a hand-drawn style path by breaking it into jittered segments.
  Path _buildSketchPath(SketchLine line, Random rand) {
    final dx = line.end.dx - line.start.dx;
    final dy = line.end.dy - line.start.dy;
    final segments = rand.nextInt(6) + 4; // Randomly split into 4–9 segments

    final path = Path()..moveTo(line.start.dx, line.start.dy);

    for (int i = 1; i <= segments; i++) {
      final t = i / segments;
      final x = line.start.dx + dx * t;
      final y = line.start.dy + dy * t + line.yOffset;

      final jitterX = rand.nextDouble() * 4 - 2; // jitter in X
      final jitterY = rand.nextDouble() * 4 - 2; // jitter in Y

      path.lineTo(x + jitterX, y + jitterY);
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.seed != seed ||
        oldDelegate.lines != lines;
  }
}
