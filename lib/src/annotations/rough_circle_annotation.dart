// lib/src/annotations/rough_circle_annotation.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rough_notation/rough_notation.dart';
import 'package:rough_notation/src/painters/arc_painter.dart';
import 'package:rough_notation/src/utils/colors.dart';


class RoughCircleAnnotation extends StatefulWidget {
  const RoughCircleAnnotation({
    super.key,
    required this.child,
    this.color = kCircleColor,
    this.strokeWidth = 2,
    this.padding = 6.0,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.controller,
    this.group,
    this.sequence,
  });

  final Widget child;
  final Color color;
  final double strokeWidth;
  final double padding;
  final Duration duration;
  final Duration delay;
  final RoughAnnotationController? controller;
  final String? group;
  final int? sequence;

  @override
  State<RoughCircleAnnotation> createState() => _RoughCircleAnnotationState();
}

class _RoughCircleAnnotationState extends State<RoughCircleAnnotation>
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
        final renderBox = _childKey.currentContext?.findRenderObject() as RenderBox?;
        final size = renderBox?.size ?? Size.zero;

        final bounds = Rect.fromLTWH(
          -widget.padding / 2,
          -widget.padding / 2,
          size.width + widget.padding,
          size.height + widget.padding,
        );

        final offset = 2.0;
        final offsetBounds = Rect.fromLTWH(
          bounds.left + offset,
          bounds.top + offset,
          bounds.width,
          bounds.height,
        );

        final arcs = [
          SketchArc(
            bounds: bounds,
            fromAngle: 0,
            toAngle: 2 * pi,
            fromProgress: 0.0,
            toProgress: 0.5,
          ),
          SketchArc(
            bounds: offsetBounds,
            fromAngle: 0,
            toAngle: 2 * pi,
            fromProgress: 0.5,
            toProgress: 1.0,
          ),
        ];


        return CustomPaint(
          foregroundPainter: ArcPainter(
            arcs: arcs,
            color: widget.color,
            strokeWidth: widget.strokeWidth,
            seed: _seed,
            progress: _animation.value,
          ),
          child: Padding(
            padding: EdgeInsets.all(widget.padding),
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
