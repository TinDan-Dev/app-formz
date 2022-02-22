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

  T or(T value) {
    if (this != null) {
      return this as T;
    } else {
      return value;
    }
  }

  T? orOther(T? value) {
    if (this != null) {
      return this as T;
    } else {
      return value;
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
