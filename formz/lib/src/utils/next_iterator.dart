abstract class NextIterator<T> {
  const NextIterator();

  factory NextIterator.from(Iterator<T> source) = _NextIterator<T>;

  bool get hasNext;

  T next();
}

class _NextIterator<T> extends NextIterator<T> {
  final Iterator<T> source;

  late bool _hasNext;

  @override
  bool get hasNext => _hasNext;

  _NextIterator(this.source) {
    if (source.moveNext()) {
      _hasNext = true;
    } else {
      _hasNext = false;
    }
  }

  @override
  T next() {
    assert(_hasNext);
    final next = source.current;

    if (source.moveNext()) {
      _hasNext = true;
    } else {
      _hasNext = false;
    }

    return next;
  }
}

abstract class PeekIterator<T> extends NextIterator<T> {
  const PeekIterator();

  factory PeekIterator.from(Iterator<T> source) = _PeekIterator<T>;

  T get peek;
}

class _PeekIterator<T> extends PeekIterator<T> {
  final Iterator<T> source;

  late bool _hasNext;
  late T _next;

  @override
  bool get hasNext => _hasNext;

  @override
  T get peek => _next;

  _PeekIterator(this.source) {
    if (source.moveNext()) {
      _hasNext = true;
      _next = source.current;
    } else {
      _hasNext = false;
    }
  }

  @override
  T next() {
    assert(_hasNext);
    final next = _next;

    if (source.moveNext()) {
      _hasNext = true;
      _next = source.current;
    } else {
      _hasNext = false;
    }

    return next;
  }
}
