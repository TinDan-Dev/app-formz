import 'dart:async';

import '../../../formz.tuple.dart';
import '../../utils/lazy.dart';
import '../either/either.dart';
import 'either_future.dart';

/// Joins the left side of one [EitherFuture] (L) with the left side of another
/// [EitherFuture] (S). The other Either is only invoked if the first one is left.
class _JoinLeftEitherFuture<S, L, R> implements EitherFuture<Tuple<L, S>, R> {
  final FutureOr<EitherFuture<L, R>> source;
  final LazyFuture<EitherFuture<S, R>> _joiningLazy;

  _JoinLeftEitherFuture({
    required this.source,
    required FutureOr<EitherFuture<S, R>> joining(),
  }) : _joiningLazy = LazyFuture(joining);

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(Tuple<L, S> value),
    required FutureOr<T> onRight(R value),
  }) async {
    return (await source).consume(
      onLeft: (sourceValue) async => (await _joiningLazy.value).consume(
        onLeft: (value) => onLeft(Tuple(first: sourceValue, second: value)),
        onRight: onRight,
      ),
      onRight: onRight,
    );
  }
}

/// Joins the right side of one [EitherFuture] (R) with the right side of another
/// [EitherFuture] (S). The other Either is only invoked if the first one is right.
class _JoinRightEitherFuture<S, L, R> implements EitherFuture<L, Tuple<R, S>> {
  final FutureOr<EitherFuture<L, R>> source;
  final LazyFuture<EitherFuture<L, S>> _joiningLazy;

  _JoinRightEitherFuture({
    required this.source,
    required FutureOr<EitherFuture<L, S>> joining(),
  }) : _joiningLazy = LazyFuture(joining);

  @override
  Future<T> consume<T>({
    required FutureOr<T> onLeft(L value),
    required FutureOr<T> onRight(Tuple<R, S> value),
  }) async {
    return (await source).consume(
      onLeft: onLeft,
      onRight: (sourceValue) async => (await _joiningLazy.value).consume(
        onLeft: onLeft,
        onRight: (value) => onRight(Tuple(first: sourceValue, second: value)),
      ),
    );
  }
}

extension EitherFutureJoiningExtension<L, R> on EitherFuture<L, R> {
  /// Joins the left side of one [EitherFuture] (L) with the left side of another
  /// [EitherFuture] (S). The other Either is only invoked if the first one is left.
  ///
  /// The [other] function is only invoked once to create or get the [Either]
  /// the result is then stored and used again when the joined [Either] is
  /// consumed again.
  EitherFuture<Tuple<L, S>, R> joinLeft<S>(FutureOr<EitherFuture<S, R>> other()) =>
      _JoinLeftEitherFuture(source: this, joining: other);

  /// Joins the right side of one [EitherFuture] (R) with the right side of another
  /// [EitherFuture] (S). The other Either is only invoked if the first one is right.
  ///
  /// The [other] function is only invoked once to create or get the [Either]
  /// the result is then stored and used again when the joined [Either] is
  /// consumed again.
  EitherFuture<L, Tuple<R, S>> joinRight<S>(FutureOr<EitherFuture<L, S>> other()) =>
      _JoinRightEitherFuture(source: this, joining: other);
}

extension FutureOfEitherFutureJoiningExtension<L, R> on Future<EitherFuture<L, R>> {
  /// Joins the left side of one [EitherFuture] (L) with the left side of another
  /// [EitherFuture] (S). The other Either is only invoked if the first one is left.
  ///
  /// The [other] function is only invoked once to create or get the [Either]
  /// the result is then stored and used again when the joined [Either] is
  /// consumed again.
  EitherFuture<Tuple<L, S>, R> joinLeft<S>(FutureOr<EitherFuture<S, R>> other()) =>
      _JoinLeftEitherFuture(source: this, joining: other);

  /// Joins the right side of one [EitherFuture] (R) with the right side of another
  /// [EitherFuture] (S). The other Either is only invoked if the first one is right.
  ///
  /// The [other] function is only invoked once to create or get the [Either]
  /// the result is then stored and used again when the joined [Either] is
  /// consumed again.
  EitherFuture<L, Tuple<R, S>> joinRight<S>(FutureOr<EitherFuture<L, S>> other()) =>
      _JoinRightEitherFuture(source: this, joining: other);
}
