// lib/src/annotations/rough_underline_annotation.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rough_notation/src/annotations/rough_annotation.dart';
import 'package:rough_notation/src/utils/colors.dart';
import '../painters/line_painter.dart';

class RoughUnderlineAnnotation extends RoughAnnotation {
  const RoughUnderlineAnnotation({
    super.key,
    required super.child,
    super.color = kUnderlineColor,
    super.strokeWidth = 2.0,
    super.duration = const Duration(milliseconds: 800),
    super.delay = Duration.zero,
    super.padding,
    super.group,
    super.sequence,
    super.controller,
  }) : super();
  
  @override
  Widget buildWithAnimation(BuildContext context, Animation<double> animation, GlobalKey<State<StatefulWidget>> childKey, int seed) {

    final renderBox =
            childKey.currentContext?.findRenderObject() as RenderBox?;
        final size = renderBox?.size ?? Size.zero;
        final width = size.width;
        final height = size.height;
        final baseY = height + (padding ?? 0) / 2;
        final yOffset = Random(seed + 3).nextInt(7) - 3;

        final lines = [
          SketchLine(
            start: Offset(0, baseY),
            end: Offset(width, baseY),
            fromProgress: 0.0,
            toProgress: 0.5,
          ),
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
