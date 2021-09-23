import 'dart:async';

import 'package:formz/src/utils/lazy.dart';

import '../either/either.dart';
import 'either_future.dart';

// Maps an [EitherFuture] (L, R) to an [EitherFuture] (S, K).
class _MapFlatEitherFuture<S, K, L, R> implements EitherFuture<S, K> {
  final LazyFuture<Either<S, K>> _lazyMap;

  _MapFlatEitherFuture({
    required FutureOr<EitherFuture<L, R>> source,
    required Future<Either<S, K>> map(EitherFuture<L, R> value),
  }) : _lazyMap = LazyFuture(() async => map(await source));

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(S value),
    required FutureOr<T> onRight(K value),
  }) async =>
      (await _lazyMap.value).consume(onLeft: onLeft, onRight: onRight);
}

// Maps an [EitherFuture] (L, R) async to an [EitherFuture] (S, K).
class _MapAsyncFlatEitherFuture<S, K, L, R> implements EitherFuture<S, K> {
  final LazyFuture<EitherFuture<S, K>> _lazyMap;

  _MapAsyncFlatEitherFuture({
    required FutureOr<EitherFuture<L, R>> source,
    required Future<EitherFuture<S, K>> map(EitherFuture<L, R> value),
  }) : _lazyMap = LazyFuture(() async => map(await source));

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(S value),
    required FutureOr<T> onRight(K value),
  }) async =>
      (await _lazyMap.value).consume(onLeft: onLeft, onRight: onRight);
}

extension EitherFutureMapExtension<L, R> on EitherFuture<L, R> {
  /// Maps the left side of this [EitherFuture] (L) to a new value (S).
  EitherFuture<S, R> mapLeft<S>(S map(L value)) => _MapFlatEitherFuture<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<S, R>.left(map(value)),
          onRight: (value) => Either<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [EitherFuture] (R) to a new value (S).
  EitherFuture<L, S> mapRight<S>(S map(R value)) => _MapFlatEitherFuture<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<L, S>.left(value),
          onRight: (value) => Either<L, S>.right(map(value)),
        ),
      );

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

  EitherFuture<void, R> discardLeft() => mapLeft((_) {});

  EitherFuture<L, void> discardRight() => mapRight((_) {});
}

extension FutureOfEitherFutureMapExtension<L, R> on FutureOr<EitherFuture<L, R>> {
  /// Maps the left side of this [EitherFuture] (L) to a new value (S).
  EitherFuture<S, R> mapLeft<S>(S map(L value)) => _MapFlatEitherFuture<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<S, R>.left(map(value)),
          onRight: (value) => Either<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [EitherFuture] (R) to a new value (S).
  EitherFuture<L, S> mapRight<S>(S map(R value)) => _MapFlatEitherFuture<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<L, S>.left(value),
          onRight: (value) => Either<L, S>.right(map(value)),
        ),
      );

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

  EitherFuture<void, R> discardLeft() => mapLeft((_) {});

  EitherFuture<L, void> discardRight() => mapRight((_) {});
}
