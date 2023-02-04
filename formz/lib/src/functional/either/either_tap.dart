import 'dart:async';

import 'package:meta/meta.dart';

import '../../../formz.dart';
import 'either.dart';

class _TapEither<L, R> implements Either<L, R> {
  final bool opt;

  final Either<L, R> source;
  final void Function(Either<L, R> value) tap;

  bool executed;

  _TapEither({
    required this.opt,
    required this.source,
    required this.tap,
  }) : executed = false;

  @override
  T consume<T>({
    required T onLeft(L value),
    required T onRight(R value),
  }) {
    if (!executed && opt) {
      executed = true;
      tap(source);
    }
    return source.consume(onRight: onRight, onLeft: onLeft);
  }
}

class _TapAsyncEither<L, R> extends EitherFuture<L, R> {
  final bool opt;

  final FutureOr<Either<L, R>> source;
  final FutureOr<void> Function(Either<L, R> value) tap;

  bool executed;

  _TapAsyncEither({
    required this.opt,
    required this.source,
    required this.tap,
  }) : executed = false;

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(L value),
    required FutureOr<T> onRight(R value),
  }) async {
    final source = await this.source;

    if (!executed && opt) {
      executed = true;
      await tap(source);
    }
    return source.consume<FutureOr<T>>(onRight: onRight, onLeft: onLeft);
  }
}

extension EitherTapExtension<L, R> on Either<L, R> {
  @useResult
  Either<L, R> tap(void action(Either<L, R> value), {bool opt = true}) =>
      _TapEither(source: this, tap: action, opt: opt);

  @useResult
  Either<L, R> tapLeft(void action(L value), {bool opt = true}) => _TapEither(
        source: this,
        tap: (value) => value.consume(onRight: (_) {}, onLeft: action),
        opt: opt,
      );

  @useResult
  Either<L, R> tapRight(void action(R value), {bool opt = true}) => _TapEither(
        source: this,
        tap: (value) => value.consume(onRight: action, onLeft: (_) {}),
        opt: opt,
      );

  @useResult
  Future<Either<L, R>> tapAsync(FutureOr<void> action(Either<L, R> value), {bool opt = true}) =>
      _TapAsyncEither(source: this, tap: action, opt: opt);

  @useResult
  Future<Either<L, R>> tapLeftAsync(FutureOr<void> action(L value), {bool opt = true}) => _TapAsyncEither(
        source: this,
        tap: (value) => value.consume(onRight: (_) {}, onLeft: action),
        opt: opt,
      );

  @useResult
  Future<Either<L, R>> tapRightAsync(FutureOr<void> action(R value), {bool opt = true}) => _TapAsyncEither(
        source: this,
        tap: (value) => value.consume(onRight: action, onLeft: (_) {}),
        opt: opt,
      );
}

extension FutureOfEitherTapExtension<L, R> on FutureOr<Either<L, R>> {
  @useResult
  Future<Either<L, R>> tap(void action(Either<L, R> value), {bool opt = true}) =>
      _TapAsyncEither(source: this, tap: action, opt: opt);

  @useResult
  Future<Either<L, R>> tapLeft(void action(L value), {bool opt = true}) => _TapAsyncEither(
        source: this,
        tap: (value) => value.consume(onRight: (_) {}, onLeft: action),
        opt: opt,
      );

  @useResult
  Future<Either<L, R>> tapRight(void action(R value), {bool opt = true}) => _TapAsyncEither(
        source: this,
        tap: (value) => value.consume(onRight: action, onLeft: (_) {}),
        opt: opt,
      );

  @useResult
  Future<Either<L, R>> tapAsync(FutureOr<void> action(Either<L, R> value), {bool opt = true}) =>
      _TapAsyncEither(source: this, tap: action, opt: opt);

  @useResult
  Future<Either<L, R>> tapLeftAsync(FutureOr<void> action(L value), {bool opt = true}) => _TapAsyncEither(
        source: this,
        tap: (value) => value.consume(onRight: (_) {}, onLeft: action),
        opt: opt,
      );

  @useResult
  Future<Either<L, R>> tapRightAsync(FutureOr<void> action(R value), {bool opt = true}) => _TapAsyncEither(
        source: this,
        tap: (value) => value.consume(onRight: action, onLeft: (_) {}),
        opt: opt,
      );
}

class _TapFlatRightEither<L, R> implements Either<L, R> {
  final Either<L, R> source;
  final Either<L, void> Function(R value) tap;

  Either<L, void>? result;

  _TapFlatRightEither({
    required this.source,
    required this.tap,
  });

  @override
  T consume<T>({
    required T onLeft(L value),
    required T onRight(R value),
  }) {
    result ??= source.consume(onRight: tap, onLeft: (_) => const Either.right(null));

    return result!.consume(
      onRight: (_) => source.consume(onRight: onRight, onLeft: onLeft),
      onLeft: onLeft,
    );
  }
}

class _TapFlatLeftEither<L, R> implements Either<L, R> {
  final Either<L, R> source;
  final Either<void, R> Function(L value) tap;

  Either<void, R>? result;

  _TapFlatLeftEither({
    required this.source,
    required this.tap,
  });

  @override
  T consume<T>({
    required T onLeft(L value),
    required T onRight(R value),
  }) {
    result ??= source.consume(onRight: (_) => const Either.left(null), onLeft: tap);

    return result!.consume(
      onRight: onRight,
      onLeft: (_) => source.consume(onRight: onRight, onLeft: onLeft),
    );
  }
}

class _TapAsyncFlatRightEither<L, R> extends EitherFuture<L, R> {
  final FutureOr<Either<L, R>> source;
  final FutureOr<Either<L, void>> Function(R value) tap;
  final Mutex mutex;

  Either<L, void>? result;

  _TapAsyncFlatRightEither({
    required this.source,
    required this.tap,
  }) : mutex = Mutex();

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(L value),
    required FutureOr<T> onRight(R value),
  }) async {
    if (result == null) {
      await mutex.scope(() async {
        result = await source.consume(onRight: tap, onLeft: (_) => const Either.right(null));
      });
    }

    return result!.consume(
      onRight: (_) => source.consume(onRight: onRight, onLeft: onLeft),
      onLeft: onLeft,
    );
  }
}

class _TapAsyncFlatLeftEither<L, R> extends EitherFuture<L, R> {
  final FutureOr<Either<L, R>> source;
  final FutureOr<Either<void, R>> Function(L value) tap;
  final Mutex mutex;

  Either<void, R>? result;

  _TapAsyncFlatLeftEither({
    required this.source,
    required this.tap,
  }) : mutex = Mutex();

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(L value),
    required FutureOr<T> onRight(R value),
  }) async {
    if (result == null) {
      await mutex.scope(() async {
        result = await source.consume(onRight: (_) => const Either.left(null), onLeft: tap);
      });
    }

    return result!.consume(
      onRight: onRight,
      onLeft: (_) => source.consume(onRight: onRight, onLeft: onLeft),
    );
  }
}

extension EitherTapFlatExtension<L, R> on Either<L, R> {
  @useResult
  Either<L, R> tapLeftFlat(Either<void, R> action(L value)) => _TapFlatLeftEither(source: this, tap: action);

  @useResult
  Either<L, R> tapRightFlat(Either<L, void> action(R value)) => _TapFlatRightEither(source: this, tap: action);

  @useResult
  Future<Either<L, R>> tapLeftAsyncFlat(FutureOr<Either<void, R>> action(L value)) =>
      _TapAsyncFlatLeftEither(source: this, tap: action);

  @useResult
  Future<Either<L, R>> tapRightAsyncFlat(FutureOr<Either<L, void>> action(R value)) =>
      _TapAsyncFlatRightEither(source: this, tap: action);
}

extension FutureOfEitherTapFlatExtension<L, R> on FutureOr<Either<L, R>> {
  @useResult
  Future<Either<L, R>> tapLeftFlat(Either<void, R> action(L value)) =>
      _TapAsyncFlatLeftEither(source: this, tap: action);

  @useResult
  Future<Either<L, R>> tapRightFlat(Either<L, void> action(R value)) =>
      _TapAsyncFlatRightEither(source: this, tap: action);

  @useResult
  Future<Either<L, R>> tapLeftAsyncFlat(FutureOr<Either<void, R>> action(L value)) =>
      _TapAsyncFlatLeftEither(source: this, tap: action);

  @useResult
  Future<Either<L, R>> tapRightAsyncFlat(FutureOr<Either<L, void>> action(R value)) =>
      _TapAsyncFlatRightEither(source: this, tap: action);
}
