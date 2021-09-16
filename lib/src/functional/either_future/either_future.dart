import 'dart:async';

import 'package:equatable/equatable.dart';

import '../either/either.dart';

abstract class EitherFuture<L, R> {
  const factory EitherFuture.left(FutureOr<L> value) = _Left;

  const factory EitherFuture.right(FutureOr<R> value) = _Right;

  Future<T> consume<T>({required FutureOr<T> onRight(R value), required FutureOr<T> onLeft(L value)});
}

class _Left<L, R> extends Equatable implements EitherFuture<L, R> {
  final FutureOr<L> value;

  const _Left(this.value);

  @override
  Future<T> consume<T>({
    required FutureOr<T> onRight(R value),
    required FutureOr<T> onLeft(L value),
  }) async =>
      onLeft(await value);

  @override
  List<Object?> get props => [value];
}

class _Right<L, R> extends Equatable implements EitherFuture<L, R> {
  final FutureOr<R> value;

  const _Right(this.value);

  @override
  Future<T> consume<T>({
    required FutureOr<T> onRight(R value),
    required FutureOr<T> onLeft(L value),
  }) async =>
      onRight(await value);

  @override
  List<Object?> get props => [value];
}

extension EitherFutureExtension<L, R> on EitherFuture<L, R> {
  Future<bool> get left => consume(onLeft: (_) => true, onRight: (_) => false);

  Future<bool> get right => consume(onLeft: (_) => false, onRight: (_) => true);

  Future<Either<L, R>> get future => consume(
        onLeft: (value) => Either.left(value),
        onRight: (value) => Either.right(value),
      );

  Future<void> invoke() => consume(onLeft: (_) {}, onRight: (_) {});

  Future<T?> onLeft<T>(FutureOr<T> onLeft(L value)) => consume(onLeft: onLeft, onRight: (_) => null);

  Future<T?> onRight<T>(FutureOr<T> onRight(R value)) => consume(onLeft: (_) => null, onRight: onRight);

  Future<L> leftOr(FutureOr<L> fallback()) => consume(onLeft: (value) => value, onRight: (_) => fallback());

  Future<R> rightOr(FutureOr<R> fallback()) => consume(onLeft: (_) => fallback(), onRight: (value) => value);

  Future<L?> leftOrNullable(FutureOr<L?> fallback()) => consume(onLeft: (value) => value, onRight: (_) => fallback());

  Future<R?> rightOrNullable(FutureOr<R?> fallback()) => consume(onLeft: (_) => fallback(), onRight: (value) => value);

  Future<L?> leftOrNull() => consume(onLeft: (value) => value, onRight: (_) => null);

  Future<R?> rightOrNull() => consume(onLeft: (_) => null, onRight: (value) => value);

  Future<L> leftOrThrow() => consume(
        onLeft: (value) => value,
        onRight: (value) => throw EitherException(side: 'left', otherSide: value),
      );

  Future<R> rightOrThrow() => consume(
        onLeft: (value) => throw EitherException(side: 'right', otherSide: value),
        onRight: (value) => value,
      );
}

extension FutureOfEitherFutureExtension<L, R> on FutureOr<EitherFuture<L, R>> {
  Future<T> consume<T>({required FutureOr<T> onLeft(L value), required FutureOr<T> onRight(R value)}) async =>
      (await this).consume(
        onLeft: onLeft,
        onRight: onRight,
      );

  Future<bool> get left async => (await this).left;

  Future<bool> get right async => (await this).right;

  Future<Either<L, R>> get future async => (await this).future;

  Future<void> invoke() async => (await this).invoke();

  Future<T?> onLeft<T>(FutureOr<T> onLeft(L value)) async => (await this).onLeft(onLeft);

  Future<T?> onRight<T>(FutureOr<T> onRight(R value)) async => (await this).onRight(onRight);

  Future<L> leftOr(FutureOr<L> fallback()) async => (await this).leftOr(fallback);

  Future<R> rightOr(FutureOr<R> fallback()) async => (await this).rightOr(fallback);

  Future<L?> leftOrNullable(FutureOr<L?> fallback()) async => (await this).leftOrNullable(fallback);

  Future<R?> rightOrNullable(FutureOr<R?> fallback()) async => (await this).rightOrNullable(fallback);

  Future<L?> leftOrNull() async => (await this).leftOrNull();

  Future<R?> rightOrNull() async => (await this).rightOrNull();

  Future<L> leftOrThrow() async => (await this).leftOrThrow();

  Future<R> rightOrThrow() async => (await this).rightOrThrow();
}
