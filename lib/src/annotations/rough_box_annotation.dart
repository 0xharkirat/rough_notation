// lib/src/annotations/rough_box_annotation.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rough_notation/src/annotations/rough_annotation.dart';
import 'package:rough_notation/src/utils/colors.dart';
import '../painters/line_painter.dart';

class RoughBoxAnnotation extends RoughAnnotation {
  const RoughBoxAnnotation({
    super.key,
    required super.child,
    super.color = kBoxColor,
    super.strokeWidth = 2.0,
    super.duration = const Duration(milliseconds: 1200),
    super.delay = Duration.zero,
    super.padding,
    this.looseCorners = true,
    super.group,
    super.sequence,
    super.controller,
  });

  final bool looseCorners;

  Offset _jittered(Offset original, Random rand) {
    if (!looseCorners) return original;
    return original.translate(
      rand.nextDouble() * 6 - 3,
      rand.nextDouble() * 6 - 3,
    );
  }

  @override
  Widget buildWithAnimation(
    BuildContext context,
    Animation<double> animation,
    GlobalKey<State<StatefulWidget>> childKey,
    int seed,
  ) {
    final renderBox = childKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;
    final width = size.width + (padding ?? 0);
    final height = size.height + (padding ?? 0);

    final rand = Random(seed);

    final lines = [
      // Round 1
      SketchLine(
        start: _jittered(Offset(0, 0), rand),
        end: _jittered(Offset(width, 0), rand),
        fromProgress: 0.0,
        toProgress: 0.125,
      ),
      SketchLine(
        start: _jittered(Offset(width, 0), rand),
        end: _jittered(Offset(width, height), rand),
        fromProgress: 0.125,
        toProgress: 0.25,
      ),
      SketchLine(
        start: _jittered(Offset(width, height), rand),
        end: _jittered(Offset(0, height), rand),
        fromProgress: 0.25,
        toProgress: 0.375,
      ),
      SketchLine(
        start: _jittered(Offset(0, height), rand),
        end: _jittered(Offset(0, 0), rand),
        fromProgress: 0.375,
        toProgress: 0.5,
      ),
      // Round 2
      SketchLine(
        start: _jittered(Offset(0, 0), rand),
        end: _jittered(Offset(width, 0), rand),
        fromProgress: 0.5,
        toProgress: 0.625,
      ),
      SketchLine(
        start: _jittered(Offset(width, 0), rand),
        end: _jittered(Offset(width, height), rand),
        fromProgress: 0.625,
        toProgress: 0.75,
      ),
      SketchLine(
        start: _jittered(Offset(width, height), rand),
        end: _jittered(Offset(0, height), rand),
        fromProgress: 0.75,
        toProgress: 0.875,
      ),
      SketchLine(
        start: _jittered(Offset(0, height), rand),
        end: _jittered(Offset(0, 0), rand),
        fromProgress: 0.875,
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
