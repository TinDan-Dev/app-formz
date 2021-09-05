import 'dart:async';

import '../either_future/either_future.dart';
import 'either.dart';

class _EitherToEitherFuture<L, R> implements EitherFuture<L, R> {
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

extension FutureOfEitherToEitherFutureExtension<L, R> on Future<Either<L, R>> {
  EitherFuture<L, R> get future => _EitherToEitherFuture(source: this);
}
