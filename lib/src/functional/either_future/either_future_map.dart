import 'dart:async';

import 'either_future.dart';

/// Maps the left side of an [EitherFuture] (L) to a new value (S).
class _MapLeftEitherFuture<S, L, R> implements EitherFuture<S, R> {
  final FutureOr<EitherFuture<L, R>> source;

  final S Function(L value) map;

  const _MapLeftEitherFuture({required this.source, required this.map});

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(S value),
    required FutureOr<T> onRight(R value),
  }) async =>
      (await source).consume(onLeft: (value) => onLeft(map(value)), onRight: onRight);
}

/// Maps the right side of an [EitherFuture] (R) to a new value (S).
class _MapRightEitherFuture<S, L, R> implements EitherFuture<L, S> {
  final FutureOr<EitherFuture<L, R>> source;

  final S Function(R value) map;

  const _MapRightEitherFuture({required this.source, required this.map});

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(L value),
    required FutureOr<T> onRight(S value),
  }) async =>
      (await source).consume(onLeft: onLeft, onRight: (value) => onRight(map(value)));
}

// Maps an [EitherFuture] (L, R) to an [EitherFuture] (S, K).
class _MapFlatEitherFuture<S, K, L, R> implements EitherFuture<S, K> {
  final FutureOr<EitherFuture<L, R>> source;

  final Future<EitherFuture<S, K>> Function(EitherFuture<L, R> value) map;

  const _MapFlatEitherFuture({required this.source, required this.map});

  @override
  Future<T> consume<T>({required FutureOr<T> onLeft(S value), required FutureOr<T> onRight(K value)}) async =>
      (await map(await source)).consume(onLeft: onLeft, onRight: onRight);
}

extension EitherFutureMapExtension<L, R> on EitherFuture<L, R> {
  /// Maps the left side of this [EitherFuture] (L) to a new value (S).
  EitherFuture<S, R> mapLeft<S>(S map(L value)) => _MapLeftEitherFuture<S, L, R>(source: this, map: map);

  /// Maps the right side of this [EitherFuture] (R) to a new value (S).
  EitherFuture<L, S> mapRight<S>(S map(R value)) => _MapRightEitherFuture<S, L, R>(source: this, map: map);

  /// Maps the this [EitherFuture] (L, R) to a new [EitherFuture] (S, K).
  EitherFuture<S, K> mapFlat<S, K>(Future<EitherFuture<S, K>> map(EitherFuture<L, R> value)) =>
      _MapFlatEitherFuture<S, K, L, R>(source: this, map: map);

  /// Maps the left side of this [EitherFuture] (L) to a new [EitherFuture] (S, R).
  EitherFuture<S, R> mapLeftFlat<S>(FutureOr<EitherFuture<S, R>> map(L value)) => _MapFlatEitherFuture<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => map(value),
          onRight: (value) => EitherFuture<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [EitherFuture] (R) to a new [EitherFuture] (L, S).
  EitherFuture<L, S> mapLeftRight<S>(FutureOr<EitherFuture<L, S>> map(R value)) => _MapFlatEitherFuture<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => EitherFuture<L, S>.left(value),
          onRight: (value) => map(value),
        ),
      );

  EitherFuture<void, R> discardLeft() => _MapLeftEitherFuture(source: this, map: (_) {});

  EitherFuture<L, void> discardRight() => _MapRightEitherFuture(source: this, map: (_) {});
}

extension FutureOfEitherFutureMapExtension<L, R> on Future<EitherFuture<L, R>> {
  /// Maps the left side of this [EitherFuture] (L) to a new value (S).
  EitherFuture<S, R> mapLeft<S>(S map(L value)) => _MapLeftEitherFuture<S, L, R>(source: this, map: map);

  /// Maps the right side of this [EitherFuture] (R) to a new value (S).
  EitherFuture<L, S> mapRight<S>(S map(R value)) => _MapRightEitherFuture<S, L, R>(source: this, map: map);

  /// Maps the this [EitherFuture] (L, R) to a new [EitherFuture] (S, K).
  EitherFuture<S, K> mapFlat<S, K>(Future<EitherFuture<S, K>> map(EitherFuture<L, R> value)) =>
      _MapFlatEitherFuture<S, K, L, R>(source: this, map: map);

  /// Maps the left side of this [EitherFuture] (L) to a new [EitherFuture] (S, R).
  EitherFuture<S, R> mapLeftFlat<S>(FutureOr<EitherFuture<S, R>> map(L value)) => _MapFlatEitherFuture<S, R, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => map(value),
          onRight: (value) => EitherFuture<S, R>.right(value),
        ),
      );

  /// Maps the right side of this [EitherFuture] (R) to a new [EitherFuture] (L, S).
  EitherFuture<L, S> mapLeftRight<S>(FutureOr<EitherFuture<L, S>> map(R value)) => _MapFlatEitherFuture<L, S, L, R>(
        source: this,
        map: (value) => value.consume(
          onLeft: (value) => EitherFuture<L, S>.left(value),
          onRight: (value) => map(value),
        ),
      );

  EitherFuture<void, R> discardLeft() => _MapLeftEitherFuture(source: this, map: (_) {});

  EitherFuture<L, void> discardRight() => _MapRightEitherFuture(source: this, map: (_) {});
}
