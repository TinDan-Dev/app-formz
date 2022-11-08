import '../functional/result/result.dart';
import '../functional/result/result_failures.dart';

extension ObjectExtension<T> on T {
  Future<bool> _tryInvocation(dynamic invocation()) async {
    try {
      final result = invocation();

      if (result is Future) {
        await result;
      }

      return true;
    } on NoSuchMethodError catch (_) {
      return false;
    }
  }

  Future<bool> invokeDispose() async {
    final dynamic dynamicThis = this;

    if (await _tryInvocation(() => dynamicThis.disposeEntries())) return true;
    if (await _tryInvocation(() => dynamicThis.close())) return true;
    if (await _tryInvocation(() => dynamicThis.cancel())) return true;

    return false;
  }
}

extension ObjectNullExtension<T> on T? {
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

  Result<T> foldToResult([String name = 'anonymous']) => fold(
        () => Result.left(NullFailure(name)),
        (some) => Result.right(some),
      );
}

extension BoolNullExtension on bool? {
  T bFold<T>(T ifNull(), {required T ifTrue(), required T ifFalse()}) => fold(
        ifNull,
        (some) => some.bFold(ifTrue: ifTrue, ifFalse: ifFalse),
      );
}

extension BoolExtension on bool {
  T bFold<T>({required T ifTrue(), required T ifFalse()}) => this ? ifTrue() : ifFalse();

  T? ifTrue<T>(T? value) => this ? value : null;

  T? ifFalse<T>(T? value) => this ? null : value;
}

extension ListExtension<T> on List<T> {
  Future<void> asyncRemoveWhere(Future<bool> Function(T value) test) async {
    final toRemove = [
      for (final value in this)
        if (await test(value)) value
    ];

    removeWhere(toRemove.contains);
  }
}

S foldDynamic<T extends Object, S>(dynamic object, {required S ifNot(), required S ifSome(T some)}) {
  if (object is T) {
    return ifSome(object);
  } else {
    return ifNot();
  }
}

S? letDynamic<T extends Object, S>(dynamic object, {required S ifSome(T some)}) {
  if (object is T) {
    return ifSome(object);
  } else {
    return null;
  }
}
