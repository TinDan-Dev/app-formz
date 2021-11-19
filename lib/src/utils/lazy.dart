import 'dart:async';

import 'mutex.dart';

class Lazy<T> {
  final T Function() _provider;

  late bool _evaluated;
  late T _value;

  Lazy(this._provider) : _evaluated = false;

  T get value {
    if (!_evaluated) {
      _evaluated = true;
      _value = _provider();
    }
    return _value;
  }

  bool get evaluated => _evaluated;
}

class LazyFuture<T> {
  final FutureOr<T> Function() _provider;

  final Mutex _mutex;

  late bool _evaluated;
  late T _value;

  LazyFuture(this._provider)
      : _evaluated = false,
        _mutex = Mutex();

  Future<T> get value => _mutex.scope(() async {
        if (!_evaluated) {
          _value = await _provider();
          _evaluated = true;
        }

        return _value;
      });

  bool get evaluated => _evaluated;
}
