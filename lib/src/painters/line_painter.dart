// lib/src/painters/underline_painter.dart
import 'dart:math';
import 'package:flutter/material.dart';

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

class LinePainter extends CustomPainter {
  final List<SketchLine> lines;
  final Color color;
  final double progress;
  final double strokeWidth;
  final int seed;
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
      if (progress < line.fromProgress) continue;

      final localProgress = ((progress - line.fromProgress) /
              (line.toProgress - line.fromProgress))
          .clamp(0.0, 1.0);

      final rand = Random(seed + i);

      final fullPath = _buildSketchPath(line, rand);

      final totalLength = fullPath.computeMetrics().fold(
        0.0,
        (sum, m) => sum + m.length,
      );
      final revealedLength = totalLength * localProgress;

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

  Path _buildSketchPath(SketchLine line, Random rand) {
    final dx = line.end.dx - line.start.dx;
    final dy = line.end.dy - line.start.dy;
    final segments = rand.nextInt(6) + 4;
    final path = Path()..moveTo(line.start.dx, line.start.dy);

    for (int i = 1; i <= segments; i++) {
      final t = i / segments;
      final x = line.start.dx + dx * t;
      final y = line.start.dy + dy * t + line.yOffset;
      final jitterX = rand.nextDouble() * 4 - 2;
      final jitterY = rand.nextDouble() * 4 - 2;
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
