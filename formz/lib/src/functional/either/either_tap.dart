import 'dart:async';

import 'package:meta/meta.dart';

import '../../../formz.dart';
import 'either.dart';

class _TapEither<L, R> implements Either<L, R> {
  final Either<L, R> source;
  final void Function(Either<L, R> value) tap;

  bool executed;

  _TapEither({
    required this.source,
    required this.tap,
  }) : executed = false;

  @override
  T consume<T>({
    required T onLeft(L value),
    required T onRight(R value),
  }) {
    if (!executed) {
      executed = true;
      tap(source);
    }
    return source.consume(onRight: onRight, onLeft: onLeft);
  }
}

class _TapAsyncEither<L, R> extends EitherFuture<L, R> {
  final FutureOr<Either<L, R>> source;
  final FutureOr<void> Function(Either<L, R> value) tap;

  bool executed;

  _TapAsyncEither({
    required this.source,
    required this.tap,
  }) : executed = false;

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(L value),
    required FutureOr<T> onRight(R value),
  }) async {
    final source = await this.source;

    if (!executed) {
      executed = true;
      await tap(source);
    }
    return source.consume<FutureOr<T>>(onRight: onRight, onLeft: onLeft);
  }
}

extension EitherTapExtension<L, R> on Either<L, R> {
  @useResult
  Either<L, R> tap(void action(Either<L, R> value)) => _TapEither(source: this, tap: action);

  @useResult
  Either<L, R> tapLeft(void action(L value)) => _TapEither(
        source: this,
        tap: (value) => value.consume(onRight: (_) {}, onLeft: action),
      );

  @useResult
  Either<L, R> tapRight(void action(R value)) => _TapEither(
        source: this,
        tap: (value) => value.consume(onRight: action, onLeft: (_) {}),
      );

  @useResult
  Future<Either<L, R>> tapAsync(FutureOr<void> action(Either<L, R> value)) =>
      _TapAsyncEither(source: this, tap: action);

  @useResult
  Future<Either<L, R>> tapLeftAsync(FutureOr<void> action(L value)) => _TapAsyncEither(
        source: this,
        tap: (value) => value.consume(onRight: (_) {}, onLeft: action),
      );

  @useResult
  Future<Either<L, R>> tapRightAsync(FutureOr<void> action(R value)) => _TapAsyncEither(
        source: this,
        tap: (value) => value.consume(onRight: action, onLeft: (_) {}),
      );
}

extension FutureOfEitherTapExtension<L, R> on FutureOr<Either<L, R>> {
  @useResult
  Future<Either<L, R>> tap(void action(Either<L, R> value)) => _TapAsyncEither(source: this, tap: action);

  @useResult
  Future<Either<L, R>> tapLeft(void action(L value)) => _TapAsyncEither(
        source: this,
        tap: (value) => value.consume(onRight: (_) {}, onLeft: action),
      );

  @useResult
  Future<Either<L, R>> tapRight(void action(R value)) => _TapAsyncEither(
        source: this,
        tap: (value) => value.consume(onRight: action, onLeft: (_) {}),
      );

  @useResult
  Future<Either<L, R>> tapAsync(FutureOr<void> action(Either<L, R> value)) =>
      _TapAsyncEither(source: this, tap: action);

  @useResult
  Future<Either<L, R>> tapLeftAsync(FutureOr<void> action(L value)) => _TapAsyncEither(
        source: this,
        tap: (value) => value.consume(onRight: (_) {}, onLeft: action),
      );

  @useResult
  Future<Either<L, R>> tapRightAsync(FutureOr<void> action(R value)) => _TapAsyncEither(
        source: this,
        tap: (value) => value.consume(onRight: action, onLeft: (_) {}),
      );
}
