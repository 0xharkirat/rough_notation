import 'package:flutter/material.dart';
import 'package:rough_notation/rough_notation.dart';

/// Base abstract class for all rough annotation widgets.
/// Handles animation lifecycle, delay logic, controller/group registration, etc.
abstract class RoughAnnotation extends StatefulWidget {
  const RoughAnnotation({
    super.key,

    /// The widget to annotate.
    required this.child,

    /// Total duration of the annotation animation.
    required this.duration,

    /// Delay before the animation starts (used in autoplay/grouped/controlled cases).
    required this.delay,

    /// Color of the annotation stroke.
    required this.color,

    /// Stroke width of the annotation (default: 2.0).
    this.strokeWidth = 2.0,

    /// Optional controller to manually trigger/reset the annotation.
    this.controller,

    /// Optional group name — if provided, annotation becomes part of a group sequence.
    this.group,

    /// Sequence order in a group (lower number runs earlier).
    this.sequence,

    /// Padding around the child to include in annotation drawing bounds.
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

  /// Implemented by each annotation to return a widget using the animated value.
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

  /// Global key to access size/position of the child widget for drawing.
  final GlobalKey _childKey = GlobalKey();

  /// Random seed used for jitter variation in annotation paths.
  late final int _seed;

  @override
  void initState() {
    super.initState();
    _seed = DateTime.now().microsecondsSinceEpoch;

    // Setup animation controller and curve.
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Register with group registry if group name is provided.
    if (widget.group != null) {
      RoughAnnotationRegistry.register(
        widget.group!,
        widget.sequence ?? 0,
        _startAnimation,
        _reset,
      );
    }
    // Otherwise, bind to controller if provided.
    else if (widget.controller != null) {
      widget.controller!.bind(start: _startAnimation, reset: _reset);
    }
    // Fallback: autoplay after delay if no controller or group.
    else {
      Future.delayed(widget.delay, () => _controller.forward());
    }
  }

  /// Starts the animation if the widget is mounted.
  Future<void> _startAnimation() async {
    if (mounted) await _controller.forward(from: 0);
  }

  /// Resets the animation to 0 progress.
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
      builder:
          (_, __) =>
              widget.buildWithAnimation(context, _animation, _childKey, _seed),
    );
  }
}
