import 'package:flutter/material.dart';
import 'package:rough_notation/src/painters/crossed_off_painter.dart';
import 'package:rough_notation/src/painters/highlight_painter.dart';
import 'package:rough_notation/src/painters/line_painter.dart';
import 'package:rough_notation/src/utils/colors.dart';

enum RoughNotationType { highlight, underline, strikeThrough, crossedOff }

class RoughNotation extends StatefulWidget {
  const RoughNotation({
    super.key,
    required this.child,
    this.color,
    this.padding = 4.0,
    this.duration = const Duration(milliseconds: 800),
    this.type = RoughNotationType.highlight,
    this.strokeWidth = 2,
  });

  final Widget child;
  final Color? color;
  final double padding;
  final Duration duration;
  final RoughNotationType type;
  final double strokeWidth;

  @override
  State<RoughNotation> createState() => _RoughNotationState();
}

class _RoughNotationState extends State<RoughNotation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late final int _seed;

  @override
  void initState() {
    super.initState();
    _seed = DateTime.now().microsecondsSinceEpoch;
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
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
        final painter = switch (widget.type) {
          RoughNotationType.highlight => HighlightPainter(
            color: widget.color ?? kHighLightColor,
            padding: widget.padding,
            progress: _animation.value,
          ),
          RoughNotationType.underline => LinePainter(
            color: widget.color ?? kUnderlineColor,
            progress: _animation.value,
            seed: _seed,
            strokeWidth: widget.strokeWidth,
            type: LinePainterType.underline,
          ),
          RoughNotationType.strikeThrough => LinePainter(
            color: widget.color ?? kStrikeThroughColor,
            progress: _animation.value,
            seed: _seed,
            strokeWidth: widget.strokeWidth,
            type: LinePainterType.strikeThrough,
          ),
          RoughNotationType.crossedOff => CrossedOffPainter(
            color: widget.color ?? kCrossedOffColor,
            progress: _animation.value,
            seed: _seed,
            strokeWidth: widget.strokeWidth,
          
          ),
        };

        return CustomPaint(
          foregroundPainter: widget.type == RoughNotationType.highlight? null: painter,
          painter: widget.type == RoughNotationType.highlight? painter: null,
          child: Padding(
            padding: EdgeInsets.all(widget.padding),
            child: widget.child,
          ),
        );
      },
    );
  }
}
