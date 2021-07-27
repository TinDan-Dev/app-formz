import 'dart:async';

import 'package:equatable/equatable.dart';

import '../consumable.dart';
import '../failure.dart';

abstract class ValueActionResultAsync<T> extends ConsumableAsync<T> with EquatableMixin {
  const ValueActionResultAsync();

  const factory ValueActionResultAsync.success(T value) = _ValueActionResultAsyncSuccess;
  const factory ValueActionResultAsync.fail(Failure failure) = _ValueActionResultAsyncFailure;
}

class _ValueActionResultAsyncSuccess<T> extends ValueActionResultAsync<T> {
  final T value;

  const _ValueActionResultAsyncSuccess(this.value);

  @override
  List<Object?> get props => [value];

  @override
  Future<S> consume<S>({
    required FutureOr<S> onSuccess(T value),
    required FutureOr<S> onError(Failure failure),
  }) async =>
      onSuccess(value);
}

class _ValueActionResultAsyncFailure<T> extends ValueActionResultAsync<T> {
  final Failure failure;

  const _ValueActionResultAsyncFailure(this.failure);

  @override
  Future<S> consume<S>({
    required FutureOr<S> onSuccess(T value),
    required FutureOr<S> onError(Failure failure),
  }) async =>
      onError(failure);

  @override
  List<Object?> get props => [failure];
}
