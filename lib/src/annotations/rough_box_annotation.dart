// lib/src/annotations/rough_box_annotation.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rough_notation/src/controllers/rough_annotation_registry.dart';
import 'package:rough_notation/src/utils/colors.dart';
import '../painters/line_painter.dart';

class RoughBoxAnnotation extends StatefulWidget {
  const RoughBoxAnnotation({
    super.key,
    required this.child,
    this.color = kBoxColor,
    this.strokeWidth = 2.0,
    this.duration = const Duration(milliseconds: 1200),
    this.delay = Duration.zero,
    this.padding = 4.0,
    this.looseCorners = true,
    this.group,
    this.sequence,
  });

  final Widget child;
  final Color color;
  final double strokeWidth;
  final Duration duration;
  final Duration delay;
  final double padding;
  final bool looseCorners;
  final String? group;
  final int? sequence;

  @override
  State<RoughBoxAnnotation> createState() => _RoughBoxAnnotationState();
}

class _RoughBoxAnnotationState extends State<RoughBoxAnnotation>
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
      // group: delay is controlled by the registry
      RoughAnnotationRegistry.register(
        widget.group!,
        widget.sequence ?? 0,
        _startAnimation,
        _reset,
      );
    } else {
      // standalone: respect delay
      Future.delayed(widget.delay, () => _controller.forward());
    }
  }

  Future<void> _startAnimation() async {
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

  Offset _jittered(Offset original, Random rand) {
    if (!widget.looseCorners) return original;
    return original.translate(
      rand.nextDouble() * 6 - 3,
      rand.nextDouble() * 6 - 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        final renderBox =
            _childKey.currentContext?.findRenderObject() as RenderBox?;
        final size = renderBox?.size ?? Size.zero;
        final width = size.width + (widget.padding);
        final height = size.height + (widget.padding);

        final rand = Random(_seed);

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
