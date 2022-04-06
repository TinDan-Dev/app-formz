extension ObjectExtension<T> on T? {
  S fold<S>(S ifNull(), S ifSome(T some)) {
    if (this == null) {
      return ifNull();
    } else {
      return ifSome(this as T);
    }
  }

  S? let<S>(S? ifSome(T some)) {
    if (this != null) {
      return ifSome(this as T);
    } else {
      return null;
    }
  }
}

extension BoolNullExtension on bool? {
  T bFold<T>(T ifNull(), {required T ifTrue(), required T ifFalse()}) => fold(
        ifNull,
        (some) => some.bFold(ifTrue, ifFalse),
      );
}

extension BoolExtension on bool {
  T bFold<T>(T ifTrue(), T ifFalse()) => this ? ifTrue() : ifFalse();

  T? ifTrue<T>(T? value) => this ? value : null;

  T? ifFalse<T>(T? value) => this ? null : value;
}

int _defaultHash(Object? obj) => obj.hashCode;

extension IterableExtension<T> on Iterable<T> {
  Iterable<T> unique([int hash(T element) = _defaultHash]) sync* {
    final hashes = <int>{};

    for (final element in this) {
      final h = hash(element);
      if (hashes.contains(h)) continue;

      hashes.add(h);
      yield element;
    }
  }
}
