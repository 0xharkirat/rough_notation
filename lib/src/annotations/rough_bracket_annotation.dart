// lib/src/annotations/rough_bracket_annotation.dart

import 'package:flutter/material.dart';
import 'package:rough_notation/src/annotations/rough_annotation.dart';
import 'package:rough_notation/src/utils/colors.dart';
import 'package:rough_notation/src/painters/line_painter.dart';

/// Draws sketchy brackets (left, right, top, bottom) around a widget using hand-drawn-style lines.
///
/// The bracket is animated in 3 parts per side: short horizontal, long vertical/horizontal, and another short horizontal.
class RoughBracketAnnotation extends RoughAnnotation {
  const RoughBracketAnnotation({
    super.key,

    /// Widget to annotate.
    required super.child,

    /// Color of the bracket lines.
    super.color = kBracketColor,

    /// Width of the stroke.
    super.strokeWidth = 2.0,

    /// Duration of the animation.
    super.duration = const Duration(milliseconds: 800),

    /// Delay before the animation starts.
    super.delay = Duration.zero,

    /// Padding around the widget. Brackets are drawn outside this area.
    super.padding = 8.0,

    /// Which brackets to show. Supports 'left', 'right', 'top', 'bottom'.
    this.brackets = const ['left', 'right'],

    /// Optional group for grouped animations.
    super.group,

    /// Position in the animation sequence of a group.
    super.sequence,

    /// Optional controller to manually trigger animation.
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

    /// Define the rectangle that includes the widget and the padding.
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

    // Loop through each requested bracket side.
    for (int i = 0; i < totalBrackets; i++) {
      final side = brackets[i];

      // These determine where in the overall animation timeline this bracket appears.
      final bracketStart = i / totalBrackets;
      final bracketEnd = (i + 1) / totalBrackets;
      final unit = (bracketEnd - bracketStart) / 3;

      // Draw each bracket in 3 parts for a rough animated feel.
      switch (side) {
        case 'left':
          lines.addAll([
            /// Top horizontal inward
            SketchLine(
              start: Offset(left + 12, top),
              end: Offset(left, top),
              fromProgress: bracketStart,
              toProgress: bracketStart + unit,
            ),

            /// Vertical down
            SketchLine(
              start: Offset(left, top),
              end: Offset(left, bottom),
              fromProgress: bracketStart + unit,
              toProgress: bracketStart + 2 * unit,
            ),

            /// Bottom horizontal outward
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
            /// Top horizontal outward
            SketchLine(
              start: Offset(right - 12, top),
              end: Offset(right, top),
              fromProgress: bracketStart,
              toProgress: bracketStart + unit,
            ),

            /// Vertical down
            SketchLine(
              start: Offset(right, top),
              end: Offset(right, bottom),
              fromProgress: bracketStart + unit,
              toProgress: bracketStart + 2 * unit,
            ),

            /// Bottom horizontal inward
            SketchLine(
              start: Offset(right, bottom),
              end: Offset(right - 12, bottom),
              fromProgress: bracketStart + 2 * unit,
              toProgress: bracketEnd,
            ),
          ]);
          break;

        case 'top':
          lines.addAll([
            /// Left vertical downward
            SketchLine(
              start: Offset(left, top + 12),
              end: Offset(left, top),
              fromProgress: bracketStart,
              toProgress: bracketStart + unit,
            ),

            /// Horizontal across top
            SketchLine(
              start: Offset(left, top),
              end: Offset(right, top),
              fromProgress: bracketStart + unit,
              toProgress: bracketStart + 2 * unit,
            ),

            /// Right vertical upward
            SketchLine(
              start: Offset(right, top),
              end: Offset(right, top + 12),
              fromProgress: bracketStart + 2 * unit,
              toProgress: bracketEnd,
            ),
          ]);
          break;

        case 'bottom':
          lines.addAll([
            /// Left vertical upward
            SketchLine(
              start: Offset(left, bottom - 12),
              end: Offset(left, bottom),
              fromProgress: bracketStart,
              toProgress: bracketStart + unit,
            ),

            /// Horizontal across bottom
            SketchLine(
              start: Offset(left, bottom),
              end: Offset(right, bottom),
              fromProgress: bracketStart + unit,
              toProgress: bracketStart + 2 * unit,
            ),

            /// Right vertical downward
            SketchLine(
              start: Offset(right, bottom),
              end: Offset(right, bottom - 12),
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
