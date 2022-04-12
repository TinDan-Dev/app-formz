import 'dart:async';

import 'either.dart';

extension EitherTapExtension<L, R> on Either<L, R> {
  Either<L, R> tap(void action(Either<L, R> value)) {
    action(this);
    return this;
  }

  Either<L, R> tapLeft(void action(L value)) {
    consume(onRight: (_) {}, onLeft: action);
    return this;
  }

  Either<L, R> tapRight(void action(R value)) {
    consume(onRight: action, onLeft: (_) {});
    return this;
  }

  Future<Either<L, R>> tapAsync(FutureOr<void> action(Either<L, R> value)) async {
    await action(this);
    return this;
  }

  Future<Either<L, R>> tapLeftAsync(FutureOr<void> action(L value)) async {
    await consume<Future<void>>(onRight: (_) async {}, onLeft: (v) async => action(v));
    return this;
  }

  Future<Either<L, R>> tapRightAsync(FutureOr<void> action(R value)) async {
    await consume<Future<void>>(onRight: (v) async => action(v), onLeft: (_) async {});
    return this;
  }
}

extension FutureOfEitherTapExtension<L, R> on Future<Either<L, R>> {
  Future<Either<L, R>> tap(void action(Either<L, R> value)) async {
    action(await this);
    return this;
  }

  Future<Either<L, R>> tapLeft(void action(L value)) async {
    await consume(onRight: (_) {}, onLeft: action);
    return this;
  }

  Future<Either<L, R>> tapRight(void action(R value)) async {
    await consume(onRight: action, onLeft: (_) {});
    return this;
  }

  Future<Either<L, R>> tapAsync(FutureOr<void> action(Either<L, R> value)) async {
    await action(await this);
    return this;
  }

  Future<Either<L, R>> tapLeftAsync(FutureOr<void> action(L value)) async {
    await consume(onRight: (_) {}, onLeft: action);
    return this;
  }

  Future<Either<L, R>> tapRightAsync(FutureOr<void> action(R value)) async {
    await consume(onRight: action, onLeft: (_) {});
    return this;
  }
}
