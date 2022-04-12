import 'package:collection/collection.dart';

import '../result/result_state.dart';
import 'nbr.dart';

class _NBRPoolEntry<T extends NBR> {
  final DateTime insertionTime;
  final T value;

  const _NBRPoolEntry({
    required this.insertionTime,
    required this.value,
  });
}

class NBRPool<T extends NBR> {
  /// The default duration after which a network bound resource is invalidated.
  static const defaultInvalidationTime = Duration(seconds: 30);

  /// The default minimum size the pool has to reach to run a cleaning sweep.
  static const defaultMinSweepSize = 500;

  final Map<Object, _NBRPoolEntry<T>> _pool;

  /// The duration after which a network bound resource is invalidated.
  ///
  /// In ms and defaults to [defaultInvalidationTime].
  final Duration invalidationTime;

  /// The minimum size the pool has to reach to run a cleaning sweep.
  ///
  /// Defaults to [defaultMinSweepSize].
  final int minSweepSize;

  NBRPool({
    this.invalidationTime = defaultInvalidationTime,
    this.minSweepSize = defaultMinSweepSize,
  }) : _pool = {};

  int get currentSize => _pool.keys.length;

  T _create(Object key, DateTime now, T create()) {
    final entry = create();
    _pool[key] = _NBRPoolEntry(insertionTime: now, value: entry);

    return entry;
  }

  _NBRPoolEntry<T>? _validate(
    _NBRPoolEntry<T>? entry, {
    required DateTime now,
    required bool outdatedOk,
    required bool failedOk,
  }) {
    if (entry == null) {
      return null;
    }

    final outdated = now.difference(entry.insertionTime) > invalidationTime;
    if (outdated && !outdatedOk) {
      return null;
    }

    final failed = entry.value.currentState is ResultStateError;
    if (failed && !failedOk) {
      return null;
    }

    return entry;
  }

  T _get(
    Object key, {
    required DateTime now,
    required T create(),
    required bool outdatedOk,
    required bool failedOk,
  }) {
    final validatedEntry = _validate(
      _pool[key],
      now: now,
      outdatedOk: outdatedOk,
      failedOk: failedOk,
    );

    if (validatedEntry == null) {
      return _create(key, now, create);
    }

    return validatedEntry.value;
  }

  T request(
    Object key, {
    required T create(),
    required DateTime now,
    bool outdatedOk = false,
    bool failedOk = false,
  }) {
    final entry = _get(
      key,
      now: now,
      create: create,
      outdatedOk: outdatedOk,
      failedOk: failedOk,
    );

    _sweep(now);

    return entry;
  }

  Iterable<T> requestMultiple(
    Iterable<Object> keys, {
    required DateTime now,
    required T create(Object key),
    bool outdatedOk = false,
    bool failedOk = false,
  }) {
    final entries = keys
        .map(
          (key) => _get(
            key,
            now: now,
            create: () => create(key),
            outdatedOk: outdatedOk,
            failedOk: failedOk,
          ),
        )
        .toList();

    _sweep(now);

    return entries;
  }

  void _sweep(DateTime now) {
    // remove every element that is older then the valid time
    if (_pool.length >= minSweepSize) {
      _pool.removeWhere((key, value) => now.difference(value.insertionTime) > invalidationTime);
    }

    // if there are still more elements in the pool, remove the oldest ones
    if (_pool.length > minSweepSize) {
      final entries = _pool.entries.sorted(
        (a, b) => a.value.insertionTime.difference(b.value.insertionTime).inMilliseconds,
      );

      for (final entry in entries.take(_pool.length - minSweepSize)) {
        _pool.remove(entry.key);
      }
    }
  }

  T? tryGet(Object key, {required DateTime now, bool outdatedOk = false, bool failedOk = false}) {
    final validatedEntry = _validate(
      _pool[key],
      now: now,
      outdatedOk: outdatedOk,
      failedOk: failedOk,
    );

    return validatedEntry?.value;
  }

  void add(Object key, {required DateTime now, required T value}) {
    _create(key, now, () => value);
    _sweep(now);
  }

  void dispose() {
    _pool.clear();
  }
}
