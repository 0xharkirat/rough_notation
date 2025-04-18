// lib/src/annotations/rough_crossedoff_annotation.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rough_notation/src/annotations/rough_annotation.dart';
import 'package:rough_notation/src/utils/colors.dart';
import '../painters/line_painter.dart';

class RoughCrossedOffAnnotation extends RoughAnnotation {
  const RoughCrossedOffAnnotation({
    super.key,
    required super.child,
    super.color = kCrossedOffColor,
    super.strokeWidth = 2.0,
    super.duration = const Duration(milliseconds: 1000),
    super.delay = Duration.zero,
    super.padding,
    super.group,
    super.sequence,
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

    final random = Random(seed);
    final offset1 = random.nextInt(5) - 2;
    final offset2 = random.nextInt(5) - 2;

    final lines = [
      SketchLine(
        start: Offset(0, 0),
        end: Offset(width, height),
        fromProgress: 0.0,
        toProgress: 0.25,
      ),
      SketchLine(
        start: Offset(width, height),
        end: Offset(0.0 + offset1, 0.0 + offset2),
        fromProgress: 0.25,
        toProgress: 0.5,
      ),
      SketchLine(
        start: Offset(width, 0),
        end: Offset(0, height),
        fromProgress: 0.5,
        toProgress: 0.75,
      ),
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
