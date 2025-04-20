// lib/src/annotations/rough_underline_annotation.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rough_notation/src/annotations/rough_annotation.dart';
import 'package:rough_notation/src/utils/colors.dart';
import '../painters/line_painter.dart';

/// A hand-drawn style underline annotation.
///
/// This annotation draws two jittery lines below the widget: one forward,
/// one backward (slightly offset for sketchy effect).
class RoughUnderlineAnnotation extends RoughAnnotation {
  const RoughUnderlineAnnotation({
    super.key,

    /// The widget to annotate.
    required super.child,

    /// Color of the underline stroke.
    super.color = kUnderlineColor,

    /// Width of the underline stroke.
    super.strokeWidth = 2.0,

    /// Total duration of the animation.
    super.duration = const Duration(milliseconds: 800),

    /// Delay before the animation starts.
    super.delay = Duration.zero,

    /// Padding below the child widget for drawing the underline.
    super.padding,

    /// Group name for sequencing animations.
    super.group,

    /// Sequence index within the group.
    super.sequence,

    /// Optional controller to manually control the animation.
    super.controller,
  }) : super();

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

    // Position the underline slightly below the widget
    final baseY = height + (padding ?? 0) / 2;

    // Random Y offset to simulate sketchy effect on second line
    final yOffset = Random(seed + 3).nextInt(7) - 3;

    final lines = [
      /// First stroke: left to right straight line
      SketchLine(
        start: Offset(0, baseY),
        end: Offset(width, baseY),
        fromProgress: 0.0,
        toProgress: 0.5,
      ),

      /// Second stroke: right to left with vertical jitter
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
        padding: EdgeInsets.only(bottom: padding ?? 0.0),
        child: KeyedSubtree(key: childKey, child: child),
      ),
    );
  }
}
