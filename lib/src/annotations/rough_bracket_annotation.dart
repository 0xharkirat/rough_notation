// lib/src/annotations/rough_bracket_annotation.dart

import 'package:flutter/material.dart';
import 'package:rough_notation/src/annotations/rough_annotation.dart';
import 'package:rough_notation/src/utils/colors.dart';
import 'package:rough_notation/src/painters/line_painter.dart';

class RoughBracketAnnotation extends RoughAnnotation {
  const RoughBracketAnnotation({
    super.key,
    required super.child,
    super.color = kBracketColor,
    super.strokeWidth = 2.0,
    super.duration = const Duration(milliseconds: 800),
    super.delay = Duration.zero,
    super.padding = 8.0,
    this.brackets = const ['left', 'right'],
    super.group,
    super.sequence,
    super.controller,
  });

  final List<String> brackets;

  @override
  Widget buildWithAnimation(
    BuildContext context,
    Animation<double> animation,
    GlobalKey<State<StatefulWidget>> childKey,
    int seed,
  ) {
    final renderBox = childKey.currentContext?.findRenderObject() as RenderBox?;
    final size = renderBox?.size ?? Size.zero;

    final paddingValue = padding ?? 0.0;
    final rect = Rect.fromLTWH(
      -paddingValue,
      -paddingValue,
      size.width + paddingValue * 2,
      size.height + paddingValue * 2,
    );

    final double left = rect.left;
    final double top = rect.top;
    final double right = rect.right;
    final double bottom = rect.bottom;
    

    final lines = <SketchLine>[];

    final totalBrackets = brackets.length;

    for (int i = 0; i < totalBrackets; i++) {
      final side = brackets[i];
      final bracketStart = i / totalBrackets;
      final bracketEnd = (i + 1) / totalBrackets;
      final unit = (bracketEnd - bracketStart) / 3;

      switch (side) {
        case 'left':
          lines.addAll([
            SketchLine(
              start: Offset(left + 12, top),
              end: Offset(left, top),
              fromProgress: bracketStart,
              toProgress: bracketStart + unit,
            ),
            SketchLine(
              start: Offset(left, top),
              end: Offset(left, bottom),
              fromProgress: bracketStart + unit,
              toProgress: bracketStart + 2 * unit,
            ),
            SketchLine(
              start: Offset(left, bottom),
              end: Offset(left + 12, bottom),
              fromProgress: bracketStart + 2 * unit,
              toProgress: bracketEnd,
            ),
          ]);
          break;
        case 'right':
          lines.addAll([
            SketchLine(
              start: Offset(right - 12, top), end: Offset(right, top),
              fromProgress: bracketStart,
              toProgress: bracketStart + unit,
            ),
            SketchLine(
              start: Offset(right, top), end: Offset(right, bottom),
              fromProgress: bracketStart + unit,
              toProgress: bracketStart + 2 * unit,
            ),
            SketchLine(
              start: Offset(right, bottom), end: Offset(right - 12, bottom),
              fromProgress: bracketStart + 2 * unit,
              toProgress: bracketEnd,
            ),
          ]);
          break;
        case 'top':
          lines.addAll([
            SketchLine(
             start: Offset(left, top + 12), end: Offset(left, top),
              fromProgress: bracketStart,
              toProgress: bracketStart + unit,
            ),
            SketchLine(
              start: Offset(left, top), end: Offset(right, top),
              fromProgress: bracketStart + unit,
              toProgress: bracketStart + 2 * unit,
            ),
            SketchLine(
              start: Offset(right, top), end: Offset(right, top + 12),
              fromProgress: bracketStart + 2 * unit,
              toProgress: bracketEnd,
            ),
          ]);
          break;
        case 'bottom':
          lines.addAll([
            SketchLine(
              start: Offset(left, bottom - 12), end: Offset(left, bottom),
              fromProgress: bracketStart,
              toProgress: bracketStart + unit,
            ),
            SketchLine(
              start: Offset(left, bottom), end: Offset(right, bottom),
              fromProgress: bracketStart + unit,
              toProgress: bracketStart + 2 * unit,
            ),
            SketchLine(
              start: Offset(right, bottom), end: Offset(right, bottom - 12),
              fromProgress: bracketStart + 2 * unit,
              toProgress: bracketEnd,
            ),
          ]);
          break;
      }
    }

    return CustomPaint(
      foregroundPainter: LinePainter(
        lines: lines,
        color: color,
        strokeWidth: strokeWidth,
        progress: animation.value,
        seed: seed,
      ),
      child: KeyedSubtree(key: childKey, child: child),
    );
  }
}
