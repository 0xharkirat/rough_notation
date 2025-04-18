// lib/src/controller/rough_annotation_registry.dart

import 'dart:async';
import 'package:flutter/widgets.dart';

typedef StartFn = Future<void> Function();
typedef ResetFn = void Function();

class _AnnotationEntry {
  final int sequence;
  final StartFn start;
  final ResetFn reset;

  _AnnotationEntry(this.sequence, this.start, this.reset);
}

class RoughAnnotationRegistry {
  static final Map<String, List<_AnnotationEntry>> _groups = {};
  static final Map<String, Completer<void>> _activeSequences = {};
  static int _autoIncrement = 0;

  static void register(
    String group,
    int? sequence,
    StartFn start,
    ResetFn reset,
  ) {
    final list = _groups.putIfAbsent(group, () => []);
    final safeSeq = sequence ?? _autoIncrement++;
    list.add(_AnnotationEntry(safeSeq, start, reset));
  }

  static void markGroupForAutoStart(
    String group, {
    Duration delayBetween = const Duration(milliseconds: 300),
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showGroup(group, delayBetween: delayBetween);
    });
  }

  static Future<void> showGroup(
    String group, {
    Duration delayBetween = const Duration(milliseconds: 300),
  }) async {
    final list = _groups[group];
    if (list == null) return;

    if (_activeSequences.containsKey(group)) {
      _activeSequences[group]?.complete();
      _activeSequences.remove(group);
    }

    final localCompleter = Completer<void>();
    _activeSequences[group] = localCompleter;

    for (final entry in list) {
      entry.reset();
    }

    list.sort((a, b) => a.sequence.compareTo(b.sequence));

    for (final entry in list) {
      if (localCompleter.isCompleted) return;
      await entry.start();
      if (localCompleter.isCompleted) return;
      await Future.delayed(delayBetween);
    }

    _activeSequences.remove(group);
  }

  static void clear(String group) {
    _groups.remove(group);
    _activeSequences.remove(group);
  }

  static void clearAll() {
    _groups.clear();
    _activeSequences.clear();
    _autoIncrement = 0;
  }
}
