// lib/src/annotations/rough_bracket_annotation.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:rough_notation/src/utils/colors.dart';
import 'package:rough_notation/src/painters/line_painter.dart';

class RoughBracketAnnotation extends StatefulWidget {
  const RoughBracketAnnotation({
    super.key,
    required this.child,
    this.color = kBracketColor,
    this.strokeWidth = 2.0,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.padding = 6.0,
    this.brackets = const ['left', 'right'],
    this.group,
    this.sequence,
    this.controller,
  });

  final Widget child;
  final Color color;
  final double strokeWidth;
  final Duration duration;
  final Duration delay;
  final double padding;
  final List<String> brackets;
  final String? group;
  final int? sequence;
  final RoughAnnotationController? controller;

  @override
  State<RoughBracketAnnotation> createState() => _RoughBracketAnnotationState();
}

class _RoughBracketAnnotationState extends State<RoughBracketAnnotation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late final int _seed;
  final GlobalKey _childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _seed = DateTime.now().microsecondsSinceEpoch;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    if (widget.group != null) {
      RoughAnnotationRegistry.register(
        widget.group!,
        widget.sequence ?? 0,
        _startAnimation,
        _reset,
      );
    } else if (widget.controller != null) {
      widget.controller!.bind(start: _startAnimation, reset: _reset);
    } else {
      Future.delayed(widget.delay, () => _controller.forward());
    }
  }

  Future<void> _startAnimation() async {
    await Future.delayed(widget.delay);
    if (mounted) await _controller.forward(from: 0);
  }

  void _reset() {
    _controller.value = 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final renderBox =
            _childKey.currentContext?.findRenderObject() as RenderBox?;
        final size = renderBox?.size ?? Size.zero;

        final width = size.width + widget.padding * 2;
        final height = size.height + widget.padding * 2;
        final lines = <SketchLine>[];

        final brackets = widget.brackets;
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
            color: widget.color,
            strokeWidth: widget.strokeWidth,
            progress: _animation.value,
            seed: _seed,
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.padding),
            child: KeyedSubtree(key: _childKey, child: widget.child),
          ),
        );
      },
    );
  }
}
