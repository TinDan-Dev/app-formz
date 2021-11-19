import 'either.dart';

extension EitherIterableExtension<L, R> on Iterable<Either<L, R>> {
  Iterable<L> whereLeft([void onRight(R right)?]) sync* {
    for (final value in this) {
      if (value.left) {
        yield value.leftOrThrow();
      } else {
        onRight?.call(value.rightOrThrow());
      }
    }
  }

  Iterable<R> whereRight([void onLeft(L left)?]) sync* {
    for (final value in this) {
      if (value.right) {
        yield value.rightOrThrow();
      } else {
        onLeft?.call(value.leftOrThrow());
      }
    }
  }
}

extension EitherStreamExtension<L, R> on Stream<Either<L, R>> {
  Stream<L> whereLeft([void onRight(R right)?]) async* {
    await for (final value in this) {
      if (value.left) {
        yield value.leftOrThrow();
      } else {
        onRight?.call(value.rightOrThrow());
      }
    }
  }

  Stream<R> whereRight([void onLeft(L left)?]) async* {
    await for (final value in this) {
      if (value.right) {
        yield value.rightOrThrow();
      } else {
        onLeft?.call(value.leftOrThrow());
      }
    }
  }
}
