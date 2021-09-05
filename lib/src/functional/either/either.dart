import 'package:equatable/equatable.dart';

abstract class Either<L, R> {
  const factory Either.left(L value) = _Left;

  const factory Either.right(R value) = _Right;

  T consume<T>({required T onLeft(L value), required T onRight(R value)});
}

class _Left<L, R> extends Equatable implements Either<L, R> {
  final L value;

  const _Left(this.value);

  @override
  T consume<T>({required T onLeft(L value), required T onRight(R value)}) => onLeft(value);

  @override
  List<Object?> get props => [value];
}

class _Right<L, R> extends Equatable implements Either<L, R> {
  final R value;

  const _Right(this.value);

  @override
  T consume<T>({required T onLeft(L value), required T onRight(R value)}) => onRight(value);

  @override
  List<Object?> get props => [value];
}

extension EitherExtension<L, R> on Either<L, R> {
  bool get left => consume(onLeft: (_) => true, onRight: (_) => false);

  bool get right => consume(onLeft: (_) => false, onRight: (_) => true);

  void invoke() => consume(onLeft: (_) {}, onRight: (_) {});

  T? onLeft<T>(T onLeft(L value)) => consume(onLeft: onLeft, onRight: (_) => null);

  T? onRight<T>(T onRight(R value)) => consume(onLeft: (_) => null, onRight: onRight);

  L leftOr(L fallback()) => consume(onLeft: (value) => value, onRight: (_) => fallback());

  R rightOr(R fallback()) => consume(onLeft: (_) => fallback(), onRight: (value) => value);

  L? leftOrNullable(L? fallback()) => consume(onLeft: (value) => value, onRight: (_) => fallback());

  R? rightOrNullable(R? fallback()) => consume(onLeft: (_) => fallback(), onRight: (value) => value);

  L? leftOrNull() => consume(onLeft: (value) => value, onRight: (_) => null);

  R? rightOrNull() => consume(onLeft: (_) => null, onRight: (value) => value);
}

extension FutureOfEitherExtension<L, R> on Future<Either<L, R>> {
  Future<T> consume<T>({required T onLeft(L value), required T onRight(R value)}) async => (await this).consume(
        onLeft: onLeft,
        onRight: onRight,
      );

  Future<bool> get left async => (await this).left;

  Future<bool> get right async => (await this).right;

  Future<void> invoke() async => (await this).invoke();

  Future<T?> onLeft<T>(T onLeft(L value)) async => (await this).onLeft(onLeft);

  Future<T?> onRight<T>(T onRight(R value)) async => (await this).onRight(onRight);

  Future<L> leftOr(L fallback()) async => (await this).leftOr(fallback);

  Future<R> rightOr(R fallback()) async => (await this).rightOr(fallback);

  Future<L?> leftOrNullable(L? fallback()) async => (await this).leftOrNullable(fallback);

  Future<R?> rightOrNullable(R? fallback()) async => (await this).rightOrNullable(fallback);

  Future<L?> leftOrNull() async => (await this).leftOrNull();

  Future<R?> rightOrNull() async => (await this).rightOrNull();
}
