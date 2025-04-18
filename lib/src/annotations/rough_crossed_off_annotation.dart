// lib/src/annotations/rough_crossedoff_annotation.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rough_notation/src/utils/colors.dart';
import '../painters/line_painter.dart';

class RoughCrossedOffAnnotation extends StatefulWidget {
  const RoughCrossedOffAnnotation({
    super.key,
    required this.child,
    this.color = kCrossedOffColor,
    this.strokeWidth = 2.0,
    this.duration = const Duration(milliseconds: 1000),
    this.delay = Duration.zero,
    this.padding,
  });

  final Widget child;
  final Color color;
  final double strokeWidth;
  final Duration duration;
  final Duration delay;
  final double? padding;

  @override
  State<RoughCrossedOffAnnotation> createState() => _RoughCrossedOffAnnotationState();
}

class _RoughCrossedOffAnnotationState extends State<RoughCrossedOffAnnotation>
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
    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
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
        final renderBox = _childKey.currentContext?.findRenderObject() as RenderBox?;
        final size = renderBox?.size ?? Size.zero;
        final width = size.width;
        final height = size.height;

        final random = Random(_seed);
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
            color: widget.color,
            strokeWidth: widget.strokeWidth,
            progress: _animation.value,
            seed: _seed,
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.padding?? 0.0),
            child: KeyedSubtree(
              key: _childKey,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}