// lib/src/annotations/rough_highlight_annotation.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rough_notation/src/annotations/rough_annotation.dart';
import 'package:rough_notation/src/painters/line_painter.dart';
import 'package:rough_notation/src/utils/colors.dart';

/// A sketchy highlight-style annotation behind a widget.
///
/// Mimics the effect of a highlighter marker drawn across the text or widget.
/// This effect is animated in two strokes:
/// 1. Forward left-to-right
/// 2. Reverse stroke with jitter to give it a natural feel
class RoughHighlightAnnotation extends RoughAnnotation {
  const RoughHighlightAnnotation({
    super.key,

    /// The widget to highlight.
    required super.child,

    /// Highlight fill color.
    super.color = kHighLightColor,

    /// Optional padding around the child.
    super.padding,

    /// Total animation duration.
    super.duration = const Duration(milliseconds: 800),

    /// Delay before the animation starts.
    super.delay = Duration.zero,

    /// Optional controller to trigger animation manually.
    super.controller,

    /// Group identifier (for sequencing).
    super.group,

    /// Sequence index within group.
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

    // Line is drawn across the vertical center of the widget
    final from = Offset(0, height / 2);
    final to = Offset(width, height / 2);

    final lines = [
      /// Forward stroke — left to right
      SketchLine(start: from, end: to, fromProgress: 0.0, toProgress: 0.5),

      /// Reverse stroke — adds randomness to simulate natural brush stroke
      SketchLine(
        start: to,
        end: from.translate(10, Random(seed).nextDouble() * 25 - 12.5),
        fromProgress: 0.5,
        toProgress: 1.0,
      ),
    ];

    return CustomPaint(
      painter: LinePainter(
        lines: lines,
        color: color,
        progress: animation.value,
        seed: seed,

        /// Use flat edge for highlight line (like a marker)
        strokeCap: StrokeCap.butt,

        /// Make the line as tall as the widget itself
        strokeWidth: height,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding ?? 0.0),
        child: KeyedSubtree(key: childKey, child: child),
      ),
    );
  }
}
