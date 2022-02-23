import 'dart:async';

import 'package:equatable/equatable.dart';

import '../../../formz.tuple.dart';
import '../../utils/lazy.dart';
import 'either.dart';

/// Joins the left side of one [Either] (L) with the left side of another
/// [Either] (S). The other Either is only invoked if the first one is left.
class _JoinLeftEither<S, L, R> extends Equatable implements Either<Tuple<L, S>, R> {
  final Either<L, R> source;
  final Lazy<Either<S, R>> _joiningLazy;

  _JoinLeftEither({
    required this.source,
    required Either<S, R> joining(),
  }) : _joiningLazy = Lazy(joining);

  @override
  T consume<T>({required T onLeft(Tuple<L, S> value), required T onRight(R value)}) {
    return source.consume(
      onLeft: (sourceValue) => _joiningLazy.value.consume(
        onLeft: (value) => onLeft(Tuple(first: sourceValue, second: value)),
        onRight: onRight,
      ),
      onRight: onRight,
    );
  }

  @override
  List<Object?> get props => [consume(onLeft: (value) => value, onRight: (value) => value)];
}

/// Joins the right side of one [Either] (R) with the right side of another
/// [Either] (S). The other Either is only invoked if the first one is right.
class _JoinRightEither<S, L, R> extends Equatable implements Either<L, Tuple<R, S>> {
  final Either<L, R> source;
  final Lazy<Either<L, S>> _joiningLazy;

  _JoinRightEither({
    required this.source,
    required Either<L, S> joining(),
  }) : _joiningLazy = Lazy(joining);

  @override
  T consume<T>({required T onLeft(L value), required T onRight(Tuple<R, S> value)}) {
    return source.consume(
      onLeft: onLeft,
      onRight: (sourceValue) => _joiningLazy.value.consume(
        onLeft: onLeft,
        onRight: (value) => onRight(Tuple(first: sourceValue, second: value)),
      ),
    );
  }

  @override
  List<Object?> get props => [consume(onLeft: (value) => value, onRight: (value) => value)];
}

/// Joins the left side of one [Either] (L) with the left side of another
/// [Future<Either>] (S). The other Either is only invoked if the first one is left.
class _JoinAsyncLeftEither<S, L, R> extends EitherFuture<Tuple<L, S>, R> {
  final Either<L, R> source;
  final LazyFuture<Either<S, R>> _joiningLazy;

  _JoinAsyncLeftEither({
    required this.source,
    required FutureOr<Either<S, R>> joining(),
  }) : _joiningLazy = LazyFuture(joining);

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(Tuple<L, S> value),
    required FutureOr<T> onRight(R value),
  }) {
    return source.consume(
      onLeft: (sourceValue) async => (await _joiningLazy.value).consume(
        onLeft: (value) => onLeft(Tuple(first: sourceValue, second: value)),
        onRight: onRight,
      ),
      onRight: (value) async => onRight(value),
    );
  }
}

/// Joins the right side of one [Either] (R) with the right side of another
/// [Future<Either>] (S). The other Either is only invoked if the first one is right.
class _JoinAsyncRightEither<S, L, R> extends EitherFuture<L, Tuple<R, S>> {
  final Either<L, R> source;
  final LazyFuture<Either<L, S>> _joiningLazy;

  _JoinAsyncRightEither({
    required this.source,
    required FutureOr<Either<L, S>> joining(),
  }) : _joiningLazy = LazyFuture(joining);

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(L value),
    required FutureOr<T> onRight(Tuple<R, S> value),
  }) {
    return source.consume(
      onLeft: (value) async => onLeft(value),
      onRight: (sourceValue) async => (await _joiningLazy.value).consume(
        onLeft: onLeft,
        onRight: (value) => onRight(Tuple(first: sourceValue, second: value)),
      ),
    );
  }
}

extension EitherJoiningExtension<L, R> on Either<L, R> {
  /// Joins the left side of one [Either] (L) with the left side of another
  /// [Either] (S). The other Either is only invoked if the first one is left.
  ///
  /// The [other] function is only invoked once to create or get the [Either]
  /// the result is then stored and used again when the joined [Either] is
  /// consumed again.
  Either<Tuple<L, S>, R> joinLeft<S>(Either<S, R> other()) => _JoinLeftEither(source: this, joining: other);

  /// Joins the right side of one [Either] (R) with the right side of another
  /// [Either] (S). The other Either is only invoked if the first one is right.
  ///
  /// The [other] function is only invoked once to create or get the [Either]
  /// the result is then stored and used again when the joined [Either] is
  /// consumed again.
  Either<L, Tuple<R, S>> joinRight<S>(Either<L, S> other()) => _JoinRightEither(source: this, joining: other);

  /// Joins the left side of one [Either] (L) with the left side of another
  /// [Future<Either>] (S). The other Either is only invoked if the first one is left.
  ///
  /// The [other] function is only invoked once to create or get the [Either]
  /// the result is then stored and used again when the joined [Either] is
  /// consumed again.
  Future<Either<Tuple<L, S>, R>> joinLeftAsync<S>(FutureOr<Either<S, R>> other()) =>
      _JoinAsyncLeftEither(source: this, joining: other);

  /// Joins the right side of one [Either] (R) with the right side of another
  /// [Future<Either>] (S). The other Either is only invoked if the first one is right.
  ///
  /// The [other] function is only invoked once to create or get the [Either]
  /// the result is then stored and used again when the joined [Either] is
  /// consumed again.
  Future<Either<L, Tuple<R, S>>> joinRightAsync<S>(FutureOr<Either<L, S>> other()) =>
      _JoinAsyncRightEither(source: this, joining: other);
}

extension FutureOfEitherJoiningExtension<L, R> on FutureOr<Either<L, R>> {
  /// Joins the left side of one [Either] (L) with the left side of another
  /// [Either] (S). The other Either is only invoked if the first one is left.
  ///
  /// The [other] function is only invoked once to create or get the [Either]
  /// the result is then stored and used again when the joined [Either] is
  /// consumed again.
  Future<Either<Tuple<L, S>, R>> joinLeft<S>(Either<S, R> other()) async => (await this).joinLeft(other);

  /// Joins the right side of one [Either] (R) with the right side of another
  /// [Either] (S). The other Either is only invoked if the first one is right.
  ///
  /// The [other] function is only invoked once to create or get the [Either]
  /// the result is then stored and used again when the joined [Either] is
  /// consumed again.
  Future<Either<L, Tuple<R, S>>> joinRight<S>(Either<L, S> other()) async => (await this).joinRight(other);

  /// Joins the left side of one [Either] (L) with the left side of another
  /// [Future<Either>] (S). The other Either is only invoked if the first one is left.
  ///
  /// The [other] function is only invoked once to create or get the [Either]
  /// the result is then stored and used again when the joined [Either] is
  /// consumed again.
  Future<Either<Tuple<L, S>, R>> joinLeftAsync<S>(FutureOr<Either<S, R>> other()) async =>
      (await this).joinLeftAsync(other);

  /// Joins the right side of one [Either] (R) with the right side of another
  /// [Future<Either>] (S). The other Either is only invoked if the first one is right.
  ///
  /// The [other] function is only invoked once to create or get the [Either]
  /// the result is then stored and used again when the joined [Either] is
  /// consumed again.
  Future<Either<L, Tuple<R, S>>> joinRightAsync<S>(FutureOr<Either<L, S>> other()) async =>
      (await this).joinRightAsync(other);
}
