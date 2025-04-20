// lib/src/controller/rough_annotation_controller.dart

import 'package:flutter/widgets.dart';

/// A controller to manually control the start and reset of annotation animations.
///
/// You can bind multiple annotation widgets to a single controller and trigger
/// their animations simultaneously using [show]. Optionally, [autoPlay] can be
/// enabled to trigger the animation automatically on widget build.
class RoughAnnotationController {
  /// Whether the annotation should automatically start on first build.
  final bool autoPlay;

  /// Optional delay before the animation starts.
  final Duration delay;

  /// Internal list of callbacks to start animations.
  final List<VoidCallback> _starts = [];

  /// Internal list of callbacks to reset animations.
  final List<VoidCallback> _resets = [];

  /// Creates a [RoughAnnotationController].
  ///
  /// If [autoPlay] is true, the annotations bound to this controller
  /// will automatically play after the first frame with the optional [delay].
  RoughAnnotationController({
    this.autoPlay = false,
    this.delay = Duration.zero,
  });

  /// Binds the controller to a widget's animation start and reset functions.
  ///
  /// Typically called internally by the annotation widget when it's mounted.
  void bind({required VoidCallback start, required VoidCallback reset}) {
    _starts.add(start);
    _resets.add(reset);

    if (autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => show());
    }
  }

  /// Starts the animation(s) manually.
  ///
  /// Optionally override the delay with [delayOverride].
  Future<void> show([Duration? delayOverride]) async {
    reset();
    final wait = delayOverride ?? delay;
    await Future.delayed(wait);

    for (final start in _starts) {
      start.call();
    }
  }

  /// Resets all bound animations to their initial state.
  void reset() {
    for (final reset in _resets) {
      reset.call();
    }
  }

  /// Disposes the controller and clears all references.
  ///
  /// Useful when annotations are disposed to avoid memory leaks.
  void dispose() {
    _starts.clear();
    _resets.clear();
  }
}
