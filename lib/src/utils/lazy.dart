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

class AsyncLazy<T> {
  final Future<T> Function() _provider;

  late bool _evaluated;
  late T _value;

  AsyncLazy(this._provider) : _evaluated = false;

  Future<T> get value async {
    if (!_evaluated) {
      _value = await _provider();
      _evaluated = true;
    }
    return _value;
  }

  bool get evaluated => _evaluated;
}
