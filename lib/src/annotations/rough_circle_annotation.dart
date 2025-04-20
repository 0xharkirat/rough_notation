// lib/src/annotations/rough_circle_annotation.dart

import 'dart:math';
import 'package:flutter/material.dart';

import 'package:rough_notation/src/annotations/rough_annotation.dart';
import 'package:rough_notation/src/painters/arc_painter.dart';
import 'package:rough_notation/src/utils/colors.dart';

/// Draws a rough, hand-drawn style animated circle around a widget.
///
/// This annotation uses two `SketchArc`s rendered by `ArcPainter`
/// to simulate the hand-drawn, double-stroke effect seen in the original Rough Notation JS library.
class RoughCircleAnnotation extends RoughAnnotation {
  const RoughCircleAnnotation({
    super.key,

    /// The widget to be surrounded by a sketchy circle.
    required super.child,

    /// The color of the circle strokes.
    super.color = kCircleColor,

    /// Stroke width for the circle lines.
    super.strokeWidth = 2,

    /// Optional padding around the annotated widget.
    super.padding,

    /// Duration of the animation.
    super.duration = const Duration(milliseconds: 800),

    /// Optional delay before animation starts.
    super.delay = Duration.zero,

    /// Optional manual controller for external trigger.
    super.controller,

    /// Group name for sequencing this annotation with others.
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

    /// Main bounds around the widget with padding applied.
    final bounds = Rect.fromLTWH(
      -(padding ?? 0) / 2,
      -(padding ?? 0) / 2,
      size.width + (padding ?? 0),
      size.height + (padding ?? 0),
    );

    /// Offset for the second arc to simulate sketchy double lines.
    final offset = 2.0;

    /// Slightly offset bounds for the second arc to add a hand-drawn feel.
    final offsetBounds = Rect.fromLTWH(
      bounds.left + offset,
      bounds.top + offset,
      bounds.width,
      bounds.height,
    );

    final arcs = [
      /// First arc from 0 to 50% of the animation.
      SketchArc(
        bounds: bounds,
        fromAngle: 0,
        toAngle: 2 * pi,
        fromProgress: 0.0,
        toProgress: 0.5,
      ),

      /// Second arc from 50% to 100%, slightly offset.
      SketchArc(
        bounds: offsetBounds,
        fromAngle: 0,
        toAngle: 2 * pi,
        fromProgress: 0.5,
        toProgress: 1.0,
      ),
    ];

    return CustomPaint(
      foregroundPainter: ArcPainter(
        arcs: arcs,
        color: color,
        strokeWidth: strokeWidth,
        seed: seed,
        progress: animation.value,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding ?? 0),
        child: KeyedSubtree(key: childKey, child: child),
      ),
    );
  }
}
