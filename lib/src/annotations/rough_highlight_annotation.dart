// lib/src/annotations/rough_highlight_annotation.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:rough_notation/src/painters/line_painter.dart';
import 'package:rough_notation/src/utils/colors.dart';

class RoughHighlightAnnotation extends StatefulWidget {
  const RoughHighlightAnnotation({
    super.key,
    required this.child,
    this.color = kHighLightColor,
    this.strokeWidth = 12,
    this.padding,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.controller,
    this.group,
    this.sequence,
  });

  final Widget child;
  final Color color;
  final double strokeWidth;
  final double? padding;
  final Duration duration;
  final Duration delay;
  final RoughAnnotationController? controller;
  final String? group;
  final int? sequence;

  @override
  State<RoughHighlightAnnotation> createState() =>
      _RoughHighlightAnnotationState();
}

class _RoughHighlightAnnotationState extends State<RoughHighlightAnnotation>
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

        final width = size.width;
        final height = size.height;

        final from = Offset(0, height / 2);
        final to = Offset(width, height / 2);

        final lines = [
          SketchLine(start: from, end: to, fromProgress: 0.0, toProgress: 0.5),
          SketchLine(
            start: to,
            end: from.translate(10, Random(_seed).nextDouble() * 20 - 10),
            fromProgress: 0.5,
            toProgress: 1.0,
          ),
        ];

        return CustomPaint(
          painter: LinePainter(
            strokeCap: StrokeCap.square,
            lines: lines,
            color: widget.color,
            progress: _animation.value,
            seed: _seed,
            strokeWidth: height,
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.padding ?? 0.0),
            child: KeyedSubtree(key: _childKey, child: widget.child),
          ),
        );
      },
    );
  }
}
