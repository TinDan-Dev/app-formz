import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../utils/delegate/delegating_future.dart';
import 'either.dart';

typedef EitherFutureMixin<L, R> = DelegatingFuture<Either<L, R>>;

abstract class EitherFuture<L, R> with DelegatingFuture<Either<L, R>> {
  const EitherFuture();

  const factory EitherFuture.left(FutureOr<L> value) = _Left;

  const factory EitherFuture.right(FutureOr<R> value) = _Right;

  Future<T> consume<T>({required FutureOr<T> onRight(R value), required FutureOr<T> onLeft(L value)});

  Future<Either<L, R>> get future => consume(
        onLeft: (value) => Either.left(value),
        onRight: (value) => Either.right(value),
      );
}

class _Left<L, R> extends EitherFuture<L, R> with EquatableMixin {
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

class _Right<L, R> extends EitherFuture<L, R> with EquatableMixin {
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

class _EitherToEitherFuture<L, R> extends EitherFuture<L, R> {
  final FutureOr<Either<L, R>> source;

  const _EitherToEitherFuture({required this.source});

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(L value),
    required FutureOr<T> onRight(R value),
  }) async =>
      (await source).consume(
        onLeft: (value) async => onLeft(value),
        onRight: (value) async => onRight(value),
      );
}

extension EitherToEitherFutureExtension<L, R> on Either<L, R> {
  EitherFuture<L, R> get future => _EitherToEitherFuture(source: this);
}

extension FutureOfEitherToEitherFutureExtension<L, R> on FutureOr<Either<L, R>> {
  EitherFuture<L, R> get future => _EitherToEitherFuture(source: this);
}
