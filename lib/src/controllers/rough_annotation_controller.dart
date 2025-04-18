// lib/src/controller/rough_annotation_controller.dart

import 'package:flutter/widgets.dart';

class RoughAnnotationController {
  final bool autoPlay;
  final Duration delay;
  void Function()? _start;
  void Function()? _reset;

  RoughAnnotationController({
    this.autoPlay = false,
    this.delay = Duration.zero,
  });

  void bind({required void Function() start, required void Function() reset}) {
    _start = start;
    _reset = reset;

    if (autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        show(delay);
      });
    }
  }

  Future<void> show([Duration? delayOverride]) async {
    reset();
    final wait = delayOverride ?? delay;
    await Future.delayed(wait);

    _start?.call();
  }

  void reset() => _reset?.call();
}
