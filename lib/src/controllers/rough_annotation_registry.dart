// lib/src/controller/rough_annotation_registry.dart

import 'dart:async';
import 'package:flutter/widgets.dart';

/// Type alias for a function that starts the annotation animation.
typedef StartFn = Future<void> Function();

/// Type alias for a function that resets the annotation animation.
typedef ResetFn = void Function();

/// Represents a single annotation entry in a group with sequencing.
class _AnnotationEntry {
  final int sequence;
  final StartFn start;
  final ResetFn reset;

  _AnnotationEntry(this.sequence, this.start, this.reset);
}

/// Static class to manage grouped annotations and their sequencing logic.
///
/// You can register annotations into named groups and control their playback
/// either manually or automatically using the methods provided here.
class RoughAnnotationRegistry {
  /// Internal store of registered annotation groups.
  static final Map<String, List<_AnnotationEntry>> _groups = {};

  /// Tracks currently running group animations to allow cancellation.
  static final Map<String, Completer<void>> _activeSequences = {};

  /// Auto-incrementing sequence number used when no explicit sequence is given.
  static int _autoIncrement = 0;

  /// Registers an annotation to a group with optional [sequence].
  ///
  /// The [start] and [reset] functions are stored and used later when
  /// animating a group.
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

  /// Automatically triggers a group's animation after the first frame is rendered.
  ///
  /// Useful for triggering a group as soon as the UI is built.
  static void markGroupForAutoStart(
    String group, {
    Duration delayBetween = const Duration(milliseconds: 300),
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showGroup(group, delayBetween: delayBetween);
    });
  }

  /// Starts animation for a group in the order of their sequence.
  ///
  /// If a group animation is already running, it will be cancelled and restarted.
  static Future<void> showGroup(
    String group, {
    Duration delayBetween = const Duration(milliseconds: 300),
  }) async {
    final list = _groups[group];
    if (list == null) return;

    // Cancel any previous running sequence for this group
    if (_activeSequences.containsKey(group)) {
      _activeSequences[group]?.complete();
      _activeSequences.remove(group);
    }

    final localCompleter = Completer<void>();
    _activeSequences[group] = localCompleter;

    // Reset all animations in the group before starting
    for (final entry in list) {
      entry.reset();
    }

    // Sort by sequence before animating
    list.sort((a, b) => a.sequence.compareTo(b.sequence));

    for (final entry in list) {
      if (localCompleter.isCompleted) return;
      await entry.start();
      if (localCompleter.isCompleted) return;
      await Future.delayed(delayBetween);
    }

    _activeSequences.remove(group);
  }

  /// Clears all entries for a specific [group].
  static void clear(String group) {
    _groups.remove(group);
    _activeSequences.remove(group);
  }

  /// Clears all registered groups and resets sequence count.
  static void clearAll() {
    _groups.clear();
    _activeSequences.clear();
    _autoIncrement = 0;
  }
}
