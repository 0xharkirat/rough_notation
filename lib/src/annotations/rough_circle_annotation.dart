// lib/src/annotations/rough_circle_annotation.dart

import 'dart:math';
import 'package:flutter/material.dart';

import 'package:rough_notation/src/annotations/rough_annotation.dart';
import 'package:rough_notation/src/painters/arc_painter.dart';
import 'package:rough_notation/src/utils/colors.dart';

class RoughCircleAnnotation extends RoughAnnotation {
  const RoughCircleAnnotation({
    super.key,
    required super.child,
    super.color = kCircleColor,
    super.strokeWidth = 2,
    super.padding = 6.0,
    super.duration = const Duration(milliseconds: 800),
    super.delay = Duration.zero,
    super.controller,
    super.group,
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

    final bounds = Rect.fromLTWH(
      -padding! / 2,
      -padding! / 2,
      size.width + padding!,
      size.height + padding!,
    );

    final offset = 2.0;
    final offsetBounds = Rect.fromLTWH(
      bounds.left + offset,
      bounds.top + offset,
      bounds.width,
      bounds.height,
    );

    final arcs = [
      SketchArc(
        bounds: bounds,
        fromAngle: 0,
        toAngle: 2 * pi,
        fromProgress: 0.0,
        toProgress: 0.5,
      ),
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
        padding: EdgeInsets.all(padding!),
        child: KeyedSubtree(key: childKey, child: child),
      ),
    );
  }
}
