import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'nbr.dart';

class _PoolKey implements Comparable<_PoolKey> {
  final Object key;
  final DateTime insertionTime;

  _PoolKey(this.key, this.insertionTime);

  @override
  int compareTo(_PoolKey other) => insertionTime.compareTo(other.insertionTime);

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! _PoolKey) return false;

    return key == other.key;
  }
}

class _PoolValue<T> {
  final T value;
  final DateTime insertionTime;

  _PoolValue(this.value, this.insertionTime);
}

class NBRPool<T extends NBR> {
  /// The default duration after which a network bound resource is invalidated.
  static const defaultInvalidationTime = Duration(seconds: 30);

  /// The default minimum size the pool has to reach to run a cleaning sweep.
  static const defaultMaxSize = 500;

  final Map<Object, _PoolValue<T>> _pool;
  final PriorityQueue<_PoolKey> _queue;

  /// The duration after which a network bound resource is invalidated.
  ///
  /// In ms and defaults to [defaultInvalidationTime].
  final Duration invalidationTime;

  /// The minimum size the pool has to reach to run a cleaning sweep.
  ///
  /// Defaults to [defaultMinSweepSize].
  final int maxSize;

  NBRPool({
    this.invalidationTime = defaultInvalidationTime,
    this.maxSize = defaultMaxSize,
  })  : _pool = {},
        _queue = PriorityQueue();

  int get currentSize => _pool.keys.length;

  T _insert(Object key, DateTime now, T create()) {
    final oldEntry = _pool[key];
    if (oldEntry != null) {
      oldEntry.value.dispose();
    }

    final entry = create();
    _pool[key] = _PoolValue(entry, now);
    _queue.add(_PoolKey(key, now));

    return entry;
  }

  @visibleForTesting
  void sweep(DateTime now) {
    while (_queue.isNotEmpty &&
        (now.difference(_queue.first.insertionTime) > invalidationTime || _queue.length > maxSize)) {
      final key = _queue.removeFirst();
      final value = _pool[key.key];

      if (value == null) continue;

      assert(value.insertionTime.isAfter(key.insertionTime) || value.insertionTime.isAtSameMomentAs(key.insertionTime));
      if (value.insertionTime.isAtSameMomentAs(key.insertionTime)) {
        value.value.dispose();
        _pool.remove(key.key);
      }
    }
  }

  bool _validate(
    _PoolValue<T>? value, {
    required DateTime now,
    required bool outdatedOk,
    required bool failedOk,
  }) {
    if (value == null) return false;

    final outdated = now.difference(value.insertionTime) > invalidationTime;
    if (outdated && !outdatedOk) return false;

    final failed = value.value.currentResult.isError;
    if (failed && !failedOk) return false;

    return true;
  }

  T _get(
    Object key, {
    required DateTime now,
    required T create(),
    required bool outdatedOk,
    required bool failedOk,
  }) {
    final value = _pool[key];
    final valid = _validate(
      value,
      now: now,
      outdatedOk: outdatedOk,
      failedOk: failedOk,
    );

    if (valid) {
      return value!.value;
    } else {
      return _insert(key, now, create);
    }
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

    sweep(now);

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

    sweep(now);

    return entries;
  }

  T? tryGet(Object key, {required DateTime now, bool outdatedOk = false, bool failedOk = false}) {
    final value = _pool[key];
    final valid = _validate(
      value,
      now: now,
      outdatedOk: outdatedOk,
      failedOk: failedOk,
    );

    if (valid) {
      return value?.value;
    } else {
      return null;
    }
  }

  void add(Object key, {required DateTime now, required T value}) {
    _insert(key, now, () => value);
    sweep(now);
  }

  void clear() {
    for (final value in _pool.values) {
      value.value.dispose();
    }
    _pool.clear();
    _queue.clear();
  }

  void dispose() => clear();
}
