// lib/src/annotations/rough_underline_annotation.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rough_notation/src/controllers/rough_annotation_controller.dart';
import 'package:rough_notation/src/controllers/rough_annotation_registry.dart';
import 'package:rough_notation/src/utils/colors.dart';
import '../painters/line_painter.dart';

class RoughUnderlineAnnotation extends StatefulWidget {
  const RoughUnderlineAnnotation({
    super.key,
    required this.child,
    this.color = kUnderlineColor,
    this.strokeWidth = 2.0,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.padding,
    this.group,
    this.sequence,
    this.controller,
  });

  final Widget child;
  final Color color;
  final double strokeWidth;
  final Duration duration;
  final Duration delay;
  final double? padding;
  final String? group;
  final int? sequence;
  final RoughAnnotationController? controller;

  @override
  State<RoughUnderlineAnnotation> createState() =>
      _RoughUnderlineAnnotationState();
}

class _RoughUnderlineAnnotationState extends State<RoughUnderlineAnnotation>
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
      widget.controller!.bind(
        start: () => _startAnimation(),
        reset: () => _reset(),
      );
    } else {
      // No group, no controller — fallback autoplay
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
        final baseY = height + (widget.padding ?? 0) / 2;
        final yOffset = Random(_seed + 3).nextInt(7) - 3;

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
            color: widget.color,
            strokeWidth: widget.strokeWidth,
            progress: _animation.value,
            seed: _seed,
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: widget.padding ?? 0.0),
            child: KeyedSubtree(key: _childKey, child: widget.child),
          ),
        );
      },
    );
  }
}
