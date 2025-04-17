import 'dart:math';

import 'package:flutter/widgets.dart';

class HighlightPainter extends CustomPainter {
  final Color color;
  final double padding;
  final double progress;

  const HighlightPainter({
    required this.color,
    this.padding = 4.0,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final jitter = 0.5;
    final rand = Random();

    final left = -padding / 2 + rand.nextDouble() * jitter;
    final top = -padding / 2 + rand.nextDouble() * jitter;
    final right = size.width + padding + rand.nextDouble() * jitter;
    final bottom = size.height + padding + rand.nextDouble() * jitter;

    final rect = Rect.fromLTRB(left, top, right, bottom);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(4.0));

    final clippedWidth = rect.width * progress;

     canvas.save();
    canvas.clipRect(Rect.fromLTWH(left, top, clippedWidth, rect.height));
    canvas.drawRRect(rrect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant HighlightPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}
