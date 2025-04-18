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
    super.padding = 6.0,
    this.brackets = const ['left', 'right'],
    super.group,
    super.sequence,
    super.controller,
  });

 
  final List<String> brackets;
  
  @override
  Widget buildWithAnimation(BuildContext context, Animation<double> animation, GlobalKey<State<StatefulWidget>> childKey, int seed) {
    final renderBox =
            childKey.currentContext?.findRenderObject() as RenderBox?;
        final size = renderBox?.size ?? Size.zero;

        final width = size.width + (padding ?? 0) * 2;
        final height = size.height + (padding ?? 0) * 2;
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
                  start: Offset(12, 0),
                  end: Offset(0, 0),
                  fromProgress: bracketStart,
                  toProgress: bracketStart + unit,
                ),
                SketchLine(
                  start: Offset(0, 0),
                  end: Offset(0, height),
                  fromProgress: bracketStart + unit,
                  toProgress: bracketStart + 2 * unit,
                ),
                SketchLine(
                  start: Offset(0, height),
                  end: Offset(12, height),
                  fromProgress: bracketStart + 2 * unit,
                  toProgress: bracketEnd,
                ),
              ]);
              break;
            case 'right':
              lines.addAll([
                SketchLine(
                  start: Offset(width - 12, 0),
                  end: Offset(width, 0),
                  fromProgress: bracketStart,
                  toProgress: bracketStart + unit,
                ),
                SketchLine(
                  start: Offset(width, 0),
                  end: Offset(width, height),
                  fromProgress: bracketStart + unit,
                  toProgress: bracketStart + 2 * unit,
                ),
                SketchLine(
                  start: Offset(width, height),
                  end: Offset(width - 12, height),
                  fromProgress: bracketStart + 2 * unit,
                  toProgress: bracketEnd,
                ),
              ]);
              break;
            case 'top':
              lines.addAll([
                SketchLine(
                  start: Offset(0, 12),
                  end: Offset(0, 0),
                  fromProgress: bracketStart,
                  toProgress: bracketStart + unit,
                ),
                SketchLine(
                  start: Offset(0, 0),
                  end: Offset(width, 0),
                  fromProgress: bracketStart + unit,
                  toProgress: bracketStart + 2 * unit,
                ),
                SketchLine(
                  start: Offset(width, 0),
                  end: Offset(width, 12),
                  fromProgress: bracketStart + 2 * unit,
                  toProgress: bracketEnd,
                ),
              ]);
              break;
            case 'bottom':
              lines.addAll([
                SketchLine(
                  start: Offset(0, height - 12),
                  end: Offset(0, height),
                  fromProgress: bracketStart,
                  toProgress: bracketStart + unit,
                ),
                SketchLine(
                  start: Offset(0, height),
                  end: Offset(width, height),
                  fromProgress: bracketStart + unit,
                  toProgress: bracketStart + 2 * unit,
                ),
                SketchLine(
                  start: Offset(width, height),
                  end: Offset(width, height - 12),
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
          child: Padding(
            padding: EdgeInsets.all(padding ?? 0.0),
            child: KeyedSubtree(key: childKey, child: child),
          ),
        );
 
  }
 

  
  
}
