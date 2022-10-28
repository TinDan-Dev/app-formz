import '../../utils/extensions.dart';

bool _defaultValidation(dynamic _) => true;

class _Entry<T extends Object> {
  final int timestamp;
  final T value;

  _Entry(this.timestamp, this.value);
}

class Cache<T extends Object> {
  final Map<int, _Entry<T>> _map;

  final int lifeTime;
  final int size;
  final bool disposeEntries;

  final bool Function(T value) validation;

  Cache(
    Duration lifeTime, {
    this.size = 100,
    this.disposeEntries = true,
    this.validation = _defaultValidation,
  })  : lifeTime = lifeTime.inMilliseconds,
        _map = {};

  bool _valid(_Entry<T> entry, int now) {
    return !validation(entry.value) || entry.timestamp + lifeTime > now;
  }

  void _sweep(int now) {
    if (_map.length <= size) return;

    _map.removeWhere((_, entry) {
      if (_valid(entry, now)) return false;

      if (disposeEntries) {
        entry.value.invokeDispose();
      }

      return true;
    });

    // TODO: this could be smarter
    while (_map.length > size) {
      final key = _map.keys.last;

      if (disposeEntries) {
        _map[key]?.value.invokeDispose();
      }

      _map.remove(key);
    }
  }

  T? get(int key, {required int now}) {
    final cached = _map[key];
    if (cached == null) return null;

    if (!_valid(cached, now)) {
      if (disposeEntries) {
        cached.value.invokeDispose();
      }

      _map.remove(key);
      return null;
    }

    return cached.value;
  }

  void insert(int key, {required T value, required int now}) {
    final cached = get(key, now: now);
    cached?.invokeDispose();

    _map[key] = _Entry(now, value);

    _sweep(now);
  }

  T getOrInsert(int key, {required T create(), required int now}) {
    final cached = get(key, now: now);
    if (cached != null) return cached;

    final value = create();
    insert(key, value: value, now: now);

    return value;
  }

  void dispose() {
    if (disposeEntries) {
      for (final entry in _map.values) {
        entry.value.invokeDispose();
      }
    }

    _map.clear();
  }
}
