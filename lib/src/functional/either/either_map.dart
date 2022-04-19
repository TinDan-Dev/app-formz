import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../utils/lazy.dart';
import 'either.dart';

// Maps an [Either] (L, R) to an [Either] (S, K).
class _MapFlatEither<S, K, L, R> extends Equatable implements Either<S, K> {
  final Lazy<Either<S, K>> _lazyMap;

  _MapFlatEither({
    required Either<L, R> source,
    required Either<S, K> map(Either<L, R> value),
  }) : _lazyMap = Lazy(() => map(source));

  @override
  T consume<T>({
    required T onLeft(S value),
    required T onRight(K value),
  }) =>
      _lazyMap.value.consume(onLeft: onLeft, onRight: onRight);

  @override
  List<Object?> get props => [consume(onLeft: (value) => value, onRight: (value) => value)];
}

// Maps an [Either] (L, R) async to an [Either] (S, K).
class _MapAsyncFlatEither<S, K, L, R> extends EitherFuture<S, K> {
  final LazyFuture<Either<S, K>> _lazyMap;

  _MapAsyncFlatEither({
    required FutureOr<Either<L, R>> source,
    required FutureOr<Either<S, K>> map(Either<L, R> value),
  }) : _lazyMap = LazyFuture(() async => map(await source));

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(S value),
    required FutureOr<T> onRight(K value),
  }) async {
    return (await _lazyMap.value).consume(onLeft: onLeft, onRight: onRight);
  }
}

extension EitherMapExtension<L, R> on Either<L, R> {
  /// Maps the left side of this [Either] (L) to a new value (S).
  @useResult
  Either<S, R> mapLeft<S>(S map(L value)) => _MapFlatEither<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<S, R>.left(map(value)),
          onRight: (value) => Either<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [Either] (R) to a new value (S).
  @useResult
  Either<L, S> mapRight<S>(S map(R value)) => _MapFlatEither<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<L, S>.left(value),
          onRight: (value) => Either<L, S>.right(map(value)),
        ),
      );

  /// Maps the this [Either] (L, R) to a new [Either] (S, K).
  @useResult
  Either<S, K> mapFlat<S, K>(Either<S, K> map(Either<L, R> value)) =>
      _MapFlatEither<S, K, L, R>(source: this, map: map);

  /// Maps the left side of this [Either] (L) to a new [Either] (S, R).
  @useResult
  Either<S, R> mapLeftFlat<S>(Either<S, R> map(L value)) => _MapFlatEither<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => map(value),
          onRight: (value) => Either<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [Either] (R) to a new [Either] (L, S).
  @useResult
  Either<L, S> mapRightFlat<S>(Either<L, S> map(R value)) => _MapFlatEither<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<L, S>.left(value),
          onRight: (value) => map(value),
        ),
      );

  /// Maps the left side of this [Either] (L) async to a new value (S).
  @useResult
  Future<Either<S, R>> mapLeftAsync<S>(FutureOr<S> map(L value)) => _MapAsyncFlatEither<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onRight: (value) => EitherFuture<S, R>.right(value),
          onLeft: (value) => EitherFuture<S, R>.left(map(value)),
        ),
      );

  /// Maps the right side of this [Either] (R) async to a new value (S).
  @useResult
  Future<Either<L, S>> mapRightAsync<S>(FutureOr<S> map(R value)) => _MapAsyncFlatEither<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onRight: (value) => EitherFuture<L, S>.right(map(value)),
          onLeft: (value) => EitherFuture<L, S>.left(value),
        ),
      );

  /// Maps the this [Either] (L, R) async to a new [Either] (S, K).
  @useResult
  Future<Either<S, K>> mapAsyncFlat<S, K>(FutureOr<Either<S, K>> map(Either<L, R> value)) =>
      _MapAsyncFlatEither<S, K, L, R>(source: this, map: map);

  /// Maps the left side of this [Either] (L) async to a new [Either] (S, R).
  @useResult
  Future<Either<S, R>> mapLeftAsyncFlat<S>(FutureOr<Either<S, R>> map(L value)) => _MapAsyncFlatEither<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => map(value),
          onRight: (value) => EitherFuture<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [Either] (R) async to a new [Either] (L, S).
  @useResult
  Future<Either<L, S>> mapRightAsyncFlat<S>(FutureOr<Either<L, S>> map(R value)) => _MapAsyncFlatEither<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => EitherFuture<L, S>.left(value),
          onRight: (value) => map(value),
        ),
      );

  @useResult
  Either<void, R> discardLeft() => mapLeft((_) {});

  @useResult
  Either<L, void> discardRight() => mapRight((_) {});

  @useResult
  Either<S, R> castLeft<S>() => mapLeft((value) => value as S);

  @useResult
  Either<L, S> castRight<S>() => mapRight((value) => value as S);
}

extension FutureOfEitherMapExtension<L, R> on FutureOr<Either<L, R>> {
  /// Maps the left side of this [Either] (L) to a new value (S).
  @useResult
  Future<Either<S, R>> mapLeft<S>(S map(L value)) => _MapAsyncFlatEither<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<S, R>.left(map(value)),
          onRight: (value) => Either<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [Either] (R) to a new value (S).
  @useResult
  Future<Either<L, S>> mapRight<S>(S map(R value)) => _MapAsyncFlatEither<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<L, S>.left(value),
          onRight: (value) => Either<L, S>.right(map(value)),
        ),
      );

  /// Maps the this [Either] (L, R) to a new [Either] (S, K).
  @useResult
  Future<Either<S, K>> mapFlat<S, K>(Either<S, K> map(Either<L, R> value)) =>
      _MapAsyncFlatEither<S, K, L, R>(source: this, map: map);

  /// Maps the left side of this [Either] (L) to a new [Either] (S, R).
  @useResult
  Future<Either<S, R>> mapLeftFlat<S>(Either<S, R> map(L value)) => _MapAsyncFlatEither<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => map(value),
          onRight: (value) => Either<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [Either] (R) to a new [Either] (L, S).
  @useResult
  Future<Either<L, S>> mapRightFlat<S>(Either<L, S> map(R value)) => _MapAsyncFlatEither<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<L, S>.left(value),
          onRight: (value) => map(value),
        ),
      );

  /// Maps the left side of this [Either] (L) async to a new value (S).
  @useResult
  Future<Either<S, R>> mapLeftAsync<S>(FutureOr<S> map(L value)) => _MapAsyncFlatEither<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onRight: (value) => EitherFuture<S, R>.right(value),
          onLeft: (value) => EitherFuture<S, R>.left(map(value)),
        ),
      );

  /// Maps the right side of this [Either] (R) async to a new value (S).
  @useResult
  Future<Either<L, S>> mapRightAsync<S>(FutureOr<S> map(R value)) => _MapAsyncFlatEither<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onRight: (value) => EitherFuture<L, S>.right(map(value)),
          onLeft: (value) => EitherFuture<L, S>.left(value),
        ),
      );

  /// Maps the this [Either] (L, R) async to a new [Either] (S, K).
  @useResult
  Future<Either<S, K>> mapAsyncFlat<S, K>(FutureOr<Either<S, K>> map(Either<L, R> value)) =>
      _MapAsyncFlatEither<S, K, L, R>(source: this, map: map);

  /// Maps the left side of this [Either] (L) async to a new [Either] (S, R).
  @useResult
  Future<Either<S, R>> mapLeftAsyncFlat<S>(FutureOr<Either<S, R>> map(L value)) => _MapAsyncFlatEither<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => map(value),
          onRight: (value) => EitherFuture<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [Either] (R) async to a new [Either] (L, S).
  @useResult
  Future<Either<L, S>> mapRightAsyncFlat<S>(FutureOr<Either<L, S>> map(R value)) => _MapAsyncFlatEither<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => EitherFuture<L, S>.left(value),
          onRight: (value) => map(value),
        ),
      );

  @useResult
  Future<Either<void, R>> discardLeft() => mapLeft((_) {});

  @useResult
  Future<Either<L, void>> discardRight() => mapRight((_) {});

  @useResult
  Future<Either<S, R>> castLeft<S>() => mapLeft((value) => value as S);

  @useResult
  Future<Either<L, S>> castRight<S>() => mapRight((value) => value as S);
}
