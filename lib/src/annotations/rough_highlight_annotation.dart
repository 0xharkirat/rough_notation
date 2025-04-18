// lib/src/annotations/rough_highlight_annotation.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rough_notation/src/annotations/rough_annotation.dart';
import 'package:rough_notation/src/painters/line_painter.dart';
import 'package:rough_notation/src/utils/colors.dart';

class RoughHighlightAnnotation extends RoughAnnotation {
  const RoughHighlightAnnotation({
    super.key,
    required super.child,
    super.color = kHighLightColor,

    super.padding,
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

    final width = size.width;
    final height = size.height;

    final from = Offset(0, height / 2);
    final to = Offset(width, height / 2);

    final lines = [
      SketchLine(start: from, end: to, fromProgress: 0.0, toProgress: 0.5),
      SketchLine(
        start: to,
        end: from.translate(10, Random(seed).nextDouble() * 25 - 12.5),
        fromProgress: 0.5,
        toProgress: 1.0,
      ),
    ];

    return CustomPaint(
      painter: LinePainter(
        strokeCap: StrokeCap.butt,
        lines: lines,
        color: color,
        progress: animation.value,
        seed: seed,
        strokeWidth: height,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding ?? 0.0),
        child: KeyedSubtree(key: childKey, child: child),
      ),
    );
  }
}
