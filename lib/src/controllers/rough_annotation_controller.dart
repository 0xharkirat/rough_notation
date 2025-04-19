// lib/src/controller/rough_annotation_controller.dart

import 'package:flutter/widgets.dart';

class RoughAnnotationController {
  final bool autoPlay;
  final Duration delay;

  final List<VoidCallback> _starts = [];
  final List<VoidCallback> _resets = [];

  RoughAnnotationController({
    this.autoPlay = false,
    this.delay = Duration.zero,
  });

  void bind({required VoidCallback start, required VoidCallback reset}) {
    _starts.add(start);
    _resets.add(reset);

    if (autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => show());
    }
  }

  Future<void> show([Duration? delayOverride]) async {
    reset();
    final wait = delayOverride ?? delay;
    await Future.delayed(wait);

    for (final start in _starts) {
      start.call();
    }
  }

  void reset() {
    for (final reset in _resets) {
      reset.call();
    }
  }

  void dispose() {
    _starts.clear();
    _resets.clear();
  }
}
