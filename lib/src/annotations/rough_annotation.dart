import 'package:flutter/material.dart';
import 'package:rough_notation/rough_notation.dart';

abstract class RoughAnnotation extends StatefulWidget {
  const RoughAnnotation({
    super.key,
    required this.child,
    required this.duration,
    required this.delay,
    required this.color,
    this.strokeWidth = 2.0,
    this.controller,
    this.group,
    this.sequence,
    this.padding,
  });

  final Widget child;
  final Duration duration;
  final Duration delay;
  final Color color;
  final double strokeWidth;
  final double? padding;
  final String? group;
  final int? sequence;
  final RoughAnnotationController? controller;

  Widget buildWithAnimation(
    BuildContext context,
    Animation<double> animation,
    GlobalKey childKey,
    int seed,
  );

  @override
  State<RoughAnnotation> createState() => _RoughAnnotationState();
}


class _RoughAnnotationState extends State<RoughAnnotation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final GlobalKey _childKey = GlobalKey();
  late final int _seed;

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
    if (mounted) await _controller.forward(from: 0);
  }

  void _reset() => _controller.value = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => widget.buildWithAnimation(context, _animation, _childKey, _seed),
    );
  }
}
