import 'dart:async';

import 'package:equatable/equatable.dart';

export 'either_future.dart';
export 'either_iterable.dart';
export 'either_join.dart';
export 'either_map.dart';
export 'either_stream.dart';

abstract class Either<L, R> {
  const factory Either.left(L value) = _Left<L, R>;

  const factory Either.right(R value) = _Right<L, R>;

  T consume<T>({required T onRight(R value), required T onLeft(L value)});
}

class _Left<L, R> extends Equatable implements Either<L, R> {
  final L value;

  const _Left(this.value);

  @override
  T consume<T>({required T onRight(R value), required T onLeft(L value)}) => onLeft(value);

  @override
  List<Object?> get props => [value];
}

class _Right<L, R> extends Equatable implements Either<L, R> {
  final R value;

  const _Right(this.value);

  @override
  T consume<T>({required T onRight(R value), required T onLeft(L value)}) => onRight(value);

  @override
  List<Object?> get props => [value];
}

class EitherException implements Exception {
  final String side;
  final Object? otherSide;

  EitherException({
    required this.side,
    required this.otherSide,
  });

  @override
  String toString() {
    return 'EitherException: Expected side $side, other side is: $otherSide';
  }
}

extension EitherExtension<L, R> on Either<L, R> {
  bool get left => consume(onLeft: (_) => true, onRight: (_) => false);

  bool get right => consume(onLeft: (_) => false, onRight: (_) => true);

  Either<L, R> tap(void action(Either<L, R> value)) {
    action(this);
    return this;
  }

  Either<L, R> invoke() => consume(onRight: (value) => Either.right(value), onLeft: (value) => Either.left(value));

  T? onLeft<T>(T onLeft(L value)) => consume(onLeft: onLeft, onRight: (_) => null);

  T? onRight<T>(T onRight(R value)) => consume(onLeft: (_) => null, onRight: onRight);

  Future<T?> onLeftAsync<T>(FutureOr<T> onLeft(L value)) async => consume(onLeft: onLeft, onRight: (_) => null);

  Future<T?> onRightAsync<T>(FutureOr<T> onRight(R value)) async => consume(onLeft: (_) => null, onRight: onRight);

  L leftOr(L fallback()) => consume(onLeft: (value) => value, onRight: (_) => fallback());

  R rightOr(R fallback()) => consume(onLeft: (_) => fallback(), onRight: (value) => value);

  L? leftOrNullable(L? fallback()) => consume(onLeft: (value) => value, onRight: (_) => fallback());

  R? rightOrNullable(R? fallback()) => consume(onLeft: (_) => fallback(), onRight: (value) => value);

  L? leftOrNull() => consume(onLeft: (value) => value, onRight: (_) => null);

  R? rightOrNull() => consume(onLeft: (_) => null, onRight: (value) => value);

  L leftOrThrow() => consume(
        onLeft: (value) => value,
        onRight: (value) => throw EitherException(side: 'left', otherSide: value),
      );

  R rightOrThrow() => consume(
        onLeft: (value) => throw EitherException(side: 'right', otherSide: value),
        onRight: (value) => value,
      );
}

extension FutureOfEitherExtension<L, R> on FutureOr<Either<L, R>> {
  Future<T> consume<T>({required FutureOr<T> onLeft(L value), required FutureOr<T> onRight(R value)}) async =>
      (await this).consume(
        onLeft: onLeft,
        onRight: onRight,
      );

  Future<bool> get left async => (await this).left;

  Future<bool> get right async => (await this).right;

  Future<Either<L, R>> tap(void action(Either<L, R> value)) async => (await this).tap(action);

  Future<Either<L, R>> invoke() async => (await this).invoke();

  Future<T?> onLeft<T>(T onLeft(L value)) async => (await this).onLeft(onLeft);

  Future<T?> onRight<T>(T onRight(R value)) async => (await this).onRight(onRight);

  Future<T?> onLeftAsync<T>(FutureOr<T> onLeft(L value)) async => (await this).onLeftAsync(onLeft);

  Future<T?> onRightAsync<T>(FutureOr<T> onRight(R value)) async => (await this).onRightAsync(onRight);

  Future<L> leftOr(L fallback()) async => (await this).leftOr(fallback);

  Future<R> rightOr(R fallback()) async => (await this).rightOr(fallback);

  Future<L?> leftOrNullable(L? fallback()) async => (await this).leftOrNullable(fallback);

  Future<R?> rightOrNullable(R? fallback()) async => (await this).rightOrNullable(fallback);

  Future<L?> leftOrNull() async => (await this).leftOrNull();

  Future<R?> rightOrNull() async => (await this).rightOrNull();

  Future<L> leftOrThrow() async => (await this).leftOrThrow();

  Future<R> rightOrThrow() async => (await this).rightOrThrow();
}
