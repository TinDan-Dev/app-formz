import 'dart:async';

import 'package:equatable/equatable.dart';

import '../either_future/either_future.dart';
import 'either.dart';

/// Maps the left side of an [Either] (L) to a new value (S).
class _MapLeftEither<S, L, R> extends Equatable implements Either<S, R> {
  final Either<L, R> source;

  final S Function(L value) map;

  const _MapLeftEither({required this.source, required this.map});

  @override
  T consume<T>({required T onLeft(S value), required T onRight(R value)}) => source.consume(
        onLeft: (value) => onLeft(map(value)),
        onRight: onRight,
      );

  @override
  List<Object?> get props => [consume(onLeft: (value) => value, onRight: (value) => value)];
}

/// Maps the right side of an [Either] (R) to a new value (S).
class _MapRightEither<S, L, R> extends Equatable implements Either<L, S> {
  final Either<L, R> source;

  final S Function(R value) map;

  const _MapRightEither({required this.source, required this.map});

  @override
  T consume<T>({required T onLeft(L value), required T onRight(S value)}) => source.consume(
        onLeft: onLeft,
        onRight: (value) => onRight(map(value)),
      );

  @override
  List<Object?> get props => [consume(onLeft: (value) => value, onRight: (value) => value)];
}

// Maps an [Either] (L, R) to an [Either] (S, K).
class _MapFlatEither<S, K, L, R> extends Equatable implements Either<S, K> {
  final Either<L, R> source;

  final Either<S, K> Function(Either<L, R> value) map;

  const _MapFlatEither({required this.source, required this.map});

  @override
  T consume<T>({required T onLeft(S value), required T onRight(K value)}) =>
      map(source).consume(onLeft: onLeft, onRight: onRight);

  @override
  List<Object?> get props => [consume(onLeft: (value) => value, onRight: (value) => value)];
}

/// Maps the left side of an [Either] (L) async to a new value (S).
class _MapAsyncLeftEither<S, L, R> implements EitherFuture<S, R> {
  final Either<L, R> source;

  final FutureOr<S> Function(L value) map;

  const _MapAsyncLeftEither({required this.source, required this.map});

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(S value),
    required FutureOr<T> onRight(R value),
  }) =>
      source.consume(
        onLeft: (value) async => onLeft(await map(value)),
        onRight: (value) async => onRight(value),
      );
}

/// Maps the right side of an [Either] (L) async to a new value (S).
class _MapAsyncRightEither<S, L, R> implements EitherFuture<L, S> {
  final Either<L, R> source;

  final FutureOr<S> Function(R value) map;

  const _MapAsyncRightEither({required this.source, required this.map});

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(L value),
    required FutureOr<T> onRight(S value),
  }) =>
      source.consume(
        onLeft: (value) async => onLeft(value),
        onRight: (value) async => onRight(await map(value)),
      );
}

// Maps an [Either] (L, R) async to an [Either] (S, K).
class _MapAsyncFlatEither<S, K, L, R> implements EitherFuture<S, K> {
  final Either<L, R> source;

  final FutureOr<EitherFuture<S, K>> Function(Either<L, R> value) map;

  const _MapAsyncFlatEither({required this.source, required this.map});

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(S value),
    required FutureOr<T> onRight(K value),
  }) async =>
      (await map(source)).consume(onLeft: onLeft, onRight: onRight);
}

extension EitherMapExtension<L, R> on Either<L, R> {
  /// Maps the left side of this [Either] (L) to a new value (S).
  Either<S, R> mapLeft<S>(S map(L value)) => _MapLeftEither<S, L, R>(source: this, map: map);

  /// Maps the right side of this [Either] (R) to a new value (S).
  Either<L, S> mapRight<S>(S map(R value)) => _MapRightEither<S, L, R>(source: this, map: map);

  /// Maps the this [Either] (L, R) to a new [Either] (S, K).
  Either<S, K> mapFlat<S, K>(Either<S, K> map(Either<L, R> value)) =>
      _MapFlatEither<S, K, L, R>(source: this, map: map);

  /// Maps the left side of this [Either] (L) to a new [Either] (S, R).
  Either<S, R> mapLeftFlat<S>(Either<S, R> map(L value)) => _MapFlatEither<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => map(value),
          onRight: (value) => Either<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [Either] (R) to a new [Either] (L, S).
  Either<L, S> mapRightFlat<S>(Either<L, S> map(R value)) => _MapFlatEither<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => Either<L, S>.left(value),
          onRight: (value) => map(value),
        ),
      );

  /// Maps the left side of this [Either] (L) async to a new value (S).
  EitherFuture<S, R> mapAsyncLeft<S>(FutureOr<S> map(L value)) => _MapAsyncLeftEither<S, L, R>(source: this, map: map);

  /// Maps the right side of this [Either] (R) async to a new value (S).
  EitherFuture<L, S> mapAsyncRight<S>(FutureOr<S> map(R value)) =>
      _MapAsyncRightEither<S, L, R>(source: this, map: map);

  /// Maps the this [Either] (L, R) async to a new [Either] (S, K).
  EitherFuture<S, K> mapAsyncFlat<S, K>(FutureOr<EitherFuture<S, K>> map(Either<L, R> value)) =>
      _MapAsyncFlatEither<S, K, L, R>(source: this, map: map);

  /// Maps the left side of this [Either] (L) async to a new [Either] (S, R).
  EitherFuture<S, R> mapLeftAsyncFlat<S>(FutureOr<EitherFuture<S, R>> map(L value)) => _MapAsyncFlatEither<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => map(value),
          onRight: (value) => EitherFuture<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [Either] (R) async to a new [Either] (L, S).
  EitherFuture<L, S> mapRightAsyncFlat<S>(FutureOr<EitherFuture<L, S>> map(R value)) => _MapAsyncFlatEither<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => EitherFuture<L, S>.left(value),
          onRight: (value) => map(value),
        ),
      );

  Either<void, R> discardLeft() => _MapLeftEither(source: this, map: (_) {});

  Either<L, void> discardRight() => _MapRightEither(source: this, map: (_) {});
}

extension FutureOfEitherMapExtension<L, R> on Future<Either<L, R>> {
  /// Maps the left side of this [Either] (L) to a new value (S).
  Future<Either<S, R>> mapLeft<S>(S map(L value)) async => (await this).mapLeft(map);

  /// Maps the right side of this [Either] (R) to a new value (S).
  Future<Either<L, S>> mapRight<S>(S map(R value)) async => (await this).mapRight(map);

  /// Maps the this [Either] (L, R) to a new [Either] (S, K).
  Future<Either<S, K>> mapFlat<S, K>(Either<S, K> map(Either<L, R> value)) async => (await this).mapFlat(map);

  /// Maps the left side of this [Either] (L) to a new [Either] (S, R).
  Future<Either<S, R>> mapLeftFlat<S>(Either<S, R> map(L value)) async => (await this).mapLeftFlat(map);

  /// Maps the right side of this [Either] (R) to a new [Either] (L, S).
  Future<Either<L, S>> mapRightFlat<S>(Either<L, S> map(R value)) async => (await this).mapRightFlat(map);

  /// Maps the left side of this [Either] (L) async to a new value (S).
  Future<EitherFuture<S, R>> mapAsyncLeft<S>(FutureOr<S> map(L value)) async => (await this).mapAsyncLeft(map);

  /// Maps the right side of this [Either] (R) async to a new value (S).
  Future<EitherFuture<L, S>> mapAsyncRight<S>(FutureOr<S> map(R value)) async => (await this).mapAsyncRight(map);

  /// Maps the this [Either] (L, R) async to a new [Either] (S, K).
  Future<EitherFuture<S, K>> mapAsyncFlat<S, K>(FutureOr<EitherFuture<S, K>> map(Either<L, R> value)) async =>
      (await this).mapAsyncFlat(map);

  /// Maps the left side of this [Either] (L) async to a new [Either] (S, R).
  Future<EitherFuture<S, R>> mapLeftAsyncFlat<S>(FutureOr<EitherFuture<S, R>> map(L value)) async =>
      (await this).mapLeftAsyncFlat(map);

  /// Maps the right side of this [Either] (R) async to a new [Either] (L, S).
  Future<EitherFuture<L, S>> mapRightAsyncFlat<S>(FutureOr<EitherFuture<L, S>> map(R value)) async =>
      (await this).mapRightAsyncFlat(map);

  Future<Either<void, R>> discardLeft() async => (await this).discardLeft();

  Future<Either<L, void>> discardRight() async => (await this).discardRight();
}
