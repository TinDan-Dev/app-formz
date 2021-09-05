import 'dart:async';

import '../either/either.dart';
import 'either_future.dart';

// Maps an [EitherFuture] (L, R) to an [EitherFuture] (S, K).
class _MapFlatEitherFuture<S, K, L, R> implements EitherFuture<S, K> {
  final FutureOr<EitherFuture<L, R>> source;

  final Future<Either<S, K>> Function(EitherFuture<L, R> value) map;

  const _MapFlatEitherFuture({required this.source, required this.map});

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(S value),
    required FutureOr<T> onRight(K value),
  }) async =>
      (await map(await source)).consume(onLeft: onLeft, onRight: onRight);
}

/// Maps the left side of an [EitherFuture] (L) async to a new value (S).
class _MapAsyncLeftEitherFuture<S, L, R> implements EitherFuture<S, R> {
  final FutureOr<EitherFuture<L, R>> source;

  final S Function(L value) map;

  const _MapAsyncLeftEitherFuture({required this.source, required this.map});

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(S value),
    required FutureOr<T> onRight(R value),
  }) async =>
      (await source).consume(onLeft: (value) => onLeft(map(value)), onRight: onRight);
}

/// Maps the right side of an [EitherFuture] (R) async to a new value (S).
class _MapAsyncRightEitherFuture<S, L, R> implements EitherFuture<L, S> {
  final FutureOr<EitherFuture<L, R>> source;

  final S Function(R value) map;

  const _MapAsyncRightEitherFuture({required this.source, required this.map});

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(L value),
    required FutureOr<T> onRight(S value),
  }) async =>
      (await source).consume(onLeft: onLeft, onRight: (value) => onRight(map(value)));
}

// Maps an [EitherFuture] (L, R) async to an [EitherFuture] (S, K).
class _MapAsyncFlatEitherFuture<S, K, L, R> implements EitherFuture<S, K> {
  final FutureOr<EitherFuture<L, R>> source;

  final Future<EitherFuture<S, K>> Function(EitherFuture<L, R> value) map;

  const _MapAsyncFlatEitherFuture({required this.source, required this.map});

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(S value),
    required FutureOr<T> onRight(K value),
  }) async =>
      (await map(await source)).consume(onLeft: onLeft, onRight: onRight);
}

extension EitherFutureMapExtension<L, R> on EitherFuture<L, R> {
  /// Maps the left side of this [EitherFuture] (L) to a new value (S).
  EitherFuture<S, R> mapLeft<S>(S map(L value)) => _MapAsyncLeftEitherFuture<S, L, R>(source: this, map: map);

  /// Maps the right side of this [EitherFuture] (R) to a new value (S).
  EitherFuture<L, S> mapRight<S>(S map(R value)) => _MapAsyncRightEitherFuture<S, L, R>(source: this, map: map);

  /// Maps the this [EitherFuture] (L, R) to a new [EitherFuture] (S, K).
  EitherFuture<S, K> mapFlat<S, K>(Future<Either<S, K>> map(EitherFuture<L, R> value)) =>
      _MapFlatEitherFuture<S, K, L, R>(source: this, map: map);

  /// Maps the left side of this [EitherFuture] (L) to a new [EitherFuture] (S, R).
  EitherFuture<S, R> mapLeftFlat<S>(FutureOr<Either<S, R>> map(L value)) => _MapFlatEitherFuture<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => map(value),
          onRight: (value) => Either<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [EitherFuture] (R) to a new [EitherFuture] (L, S).
  EitherFuture<L, S> mapRightFlat<S>(FutureOr<Either<L, S>> map(R value)) => _MapFlatEitherFuture<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<L, S>.left(value),
          onRight: (value) => map(value),
        ),
      );

  /// Maps the this [EitherFuture] (L, R) async to a new [EitherFuture] (S, K).
  EitherFuture<S, K> mapFlatAsync<S, K>(Future<EitherFuture<S, K>> map(EitherFuture<L, R> value)) =>
      _MapAsyncFlatEitherFuture<S, K, L, R>(source: this, map: map);

  /// Maps the left side of this [EitherFuture] (L) async to a new [EitherFuture] (S, R).
  EitherFuture<S, R> mapLeftFlatAsync<S>(FutureOr<EitherFuture<S, R>> map(L value)) =>
      _MapAsyncFlatEitherFuture<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => map(value),
          onRight: (value) => EitherFuture<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [EitherFuture] (R) async to a new [EitherFuture] (L, S).
  EitherFuture<L, S> mapRightFlatAsync<S>(FutureOr<EitherFuture<L, S>> map(R value)) =>
      _MapAsyncFlatEitherFuture<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => EitherFuture<L, S>.left(value),
          onRight: (value) => map(value),
        ),
      );

  EitherFuture<void, R> discardLeft() => _MapAsyncLeftEitherFuture(source: this, map: (_) {});

  EitherFuture<L, void> discardRight() => _MapAsyncRightEitherFuture(source: this, map: (_) {});
}

extension FutureOfEitherFutureMapExtension<L, R> on FutureOr<EitherFuture<L, R>> {
  /// Maps the left side of this [EitherFuture] (L) to a new value (S).
  EitherFuture<S, R> mapLeft<S>(S map(L value)) => _MapAsyncLeftEitherFuture<S, L, R>(source: this, map: map);

  /// Maps the right side of this [EitherFuture] (R) to a new value (S).
  EitherFuture<L, S> mapRight<S>(S map(R value)) => _MapAsyncRightEitherFuture<S, L, R>(source: this, map: map);

  /// Maps the this [EitherFuture] (L, R) to a new [EitherFuture] (S, K).
  EitherFuture<S, K> mapFlat<S, K>(Future<Either<S, K>> map(EitherFuture<L, R> value)) =>
      _MapFlatEitherFuture<S, K, L, R>(source: this, map: map);

  /// Maps the left side of this [EitherFuture] (L) to a new [EitherFuture] (S, R).
  EitherFuture<S, R> mapLeftFlat<S>(FutureOr<Either<S, R>> map(L value)) => _MapFlatEitherFuture<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => map(value),
          onRight: (value) => Either<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [EitherFuture] (R) to a new [EitherFuture] (L, S).
  EitherFuture<L, S> mapRightFlat<S>(FutureOr<Either<L, S>> map(R value)) => _MapFlatEitherFuture<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<L, S>.left(value),
          onRight: (value) => map(value),
        ),
      );

  /// Maps the this [EitherFuture] (L, R) async to a new [EitherFuture] (S, K).
  EitherFuture<S, K> mapFlatAsync<S, K>(Future<EitherFuture<S, K>> map(EitherFuture<L, R> value)) =>
      _MapAsyncFlatEitherFuture<S, K, L, R>(source: this, map: map);

  /// Maps the left side of this [EitherFuture] (L) async to a new [EitherFuture] (S, R).
  EitherFuture<S, R> mapLeftFlatAsync<S>(FutureOr<EitherFuture<S, R>> map(L value)) =>
      _MapAsyncFlatEitherFuture<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => map(value),
          onRight: (value) => EitherFuture<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [EitherFuture] (R) async to a new [EitherFuture] (L, S).
  EitherFuture<L, S> mapRightFlatAsync<S>(FutureOr<EitherFuture<L, S>> map(R value)) =>
      _MapAsyncFlatEitherFuture<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => EitherFuture<L, S>.left(value),
          onRight: (value) => map(value),
        ),
      );

  EitherFuture<void, R> discardLeft() => _MapAsyncLeftEitherFuture(source: this, map: (_) {});

  EitherFuture<L, void> discardRight() => _MapAsyncRightEitherFuture(source: this, map: (_) {});
}
