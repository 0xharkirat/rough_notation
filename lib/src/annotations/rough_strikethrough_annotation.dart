// lib/src/annotations/rough_strikethrough_annotation.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rough_notation/src/annotations/rough_annotation.dart';
import 'package:rough_notation/src/utils/colors.dart';
import '../painters/line_painter.dart';

/// A sketchy hand-drawn strikethrough annotation.
///
/// This annotation draws two jittery strokes across the vertical center
/// of the widget to simulate a strikethrough effect.
class RoughStrikethroughAnnotation extends RoughAnnotation {
  const RoughStrikethroughAnnotation({
    super.key,

    /// The widget to annotate with strikethrough.
    required super.child,

    /// Color of the strikethrough stroke.
    super.color = kStrikeThroughColor,

    /// Width of the strikethrough stroke.
    super.strokeWidth = 2.0,

    /// Total animation duration.
    super.duration = const Duration(milliseconds: 800),

    /// Delay before the animation starts.
    super.delay = Duration.zero,

    /// Optional padding around the child widget.
    super.padding,

    /// Group name (for grouped animation).
    super.group,

    /// Sequence index within group.
    super.sequence,

    /// Optional manual controller for triggering animation.
    super.controller,
  });

  @override
  Widget buildWithAnimation(
    BuildContext context,
    Animation<double> animation,
    GlobalKey<State<StatefulWidget>> childKey,
    int seed,
  ) {
    final renderBox = childKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    final width = size.width;
    final height = size.height;

    // Draw line across vertical center of the widget
    final baseY = height / 2;

    // Add jitter to the second line to make it sketchy
    final yOffset = Random(seed + 3).nextInt(7) - 3;

    final lines = [
      /// First stroke: straight line from left to right
      SketchLine(
        start: Offset(0, baseY),
        end: Offset(width, baseY),
        fromProgress: 0.0,
        toProgress: 0.5,
      ),

      /// Second stroke: reversed with vertical jitter
      SketchLine(
        start: Offset(width, baseY),
        end: Offset(0, baseY + yOffset),
        fromProgress: 0.5,
        toProgress: 1.0,
      ),
    ];

    return CustomPaint(
      foregroundPainter: LinePainter(
        lines: lines,
        color: color,
        strokeWidth: strokeWidth,
        progress: animation.value,
        seed: seed,
      ),
      child: Padding(
        padding:
            padding != null
                ? EdgeInsets.symmetric(vertical: padding!)
                : EdgeInsets.zero,
        child: KeyedSubtree(key: childKey, child: child),
      ),
    );
  }
}
