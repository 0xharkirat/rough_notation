// lib/src/annotations/rough_crossedoff_annotation.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rough_notation/src/annotations/rough_annotation.dart';
import 'package:rough_notation/src/utils/colors.dart';
import '../painters/line_painter.dart';

/// Draws an animated "crossed-off" (X) annotation over a widget.
///
/// The annotation appears in two strokes:
/// 1. From top-left to bottom-right
/// 2. From top-right to bottom-left
///
/// Each stroke is doubled with a reverse line to create a sketchy, hand-drawn effect.
class RoughCrossedOffAnnotation extends RoughAnnotation {
  const RoughCrossedOffAnnotation({
    super.key,

    /// The widget to be crossed off.
    required super.child,

    /// Color of the cross lines.
    super.color = kCrossedOffColor,

    /// Stroke width of the lines.
    super.strokeWidth = 2.0,

    /// Total animation duration.
    super.duration = const Duration(milliseconds: 1000),

    /// Delay before the animation starts.
    super.delay = Duration.zero,

    /// Optional padding around the child.
    super.padding,

    /// Optional controller for manual triggering.
    super.controller,

    /// Group name for animation sequencing.
    super.group,

    /// Sequence order within the group.
    super.sequence,
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

    final random = Random(seed);

    /// Slight randomness to simulate sketchy reverse strokes
    final offset1 = random.nextInt(5) - 2;
    final offset2 = random.nextInt(5) - 2;

    final lines = [
      /// First stroke: top-left → bottom-right
      SketchLine(
        start: Offset(0, 0),
        end: Offset(width, height),
        fromProgress: 0.0,
        toProgress: 0.25,
      ),

      /// Reverse of first stroke with slight offset
      SketchLine(
        start: Offset(width, height),
        end: Offset(0.0 + offset1, 0.0 + offset2),
        fromProgress: 0.25,
        toProgress: 0.5,
      ),

      /// Second stroke: top-right → bottom-left
      SketchLine(
        start: Offset(width, 0),
        end: Offset(0, height),
        fromProgress: 0.5,
        toProgress: 0.75,
      ),

      /// Reverse of second stroke with slight offset
      SketchLine(
        start: Offset(0, height),
        end: Offset(width + offset2, 0.0 + offset1),
        fromProgress: 0.75,
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
        padding: EdgeInsets.all(padding ?? 0.0),
        child: KeyedSubtree(key: childKey, child: child),
      ),
    );
  }
}
