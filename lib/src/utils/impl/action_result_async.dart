import 'dart:async';

import 'package:equatable/equatable.dart';

import '../consumable.dart';
import '../failure.dart';

abstract class ActionResultAsync extends ConsumableAsync<void> with EquatableMixin {
  const ActionResultAsync();

  const factory ActionResultAsync.success() = _ActionResultAsyncSuccess;
  const factory ActionResultAsync.fail(Failure failure) = _ActionResultAsyncFailure;
}

class _ActionResultAsyncSuccess extends ActionResultAsync {
  const _ActionResultAsyncSuccess();

  @override
  List<Object?> get props => [];

  @override
  Future<S> consume<S>({
    required FutureOr<S> onSuccess(void value),
    required FutureOr<S> onError(Failure failure),
  }) async =>
      onSuccess(null);
}

class _ActionResultAsyncFailure extends ActionResultAsync {
  final Failure failure;

  const _ActionResultAsyncFailure(this.failure);

  @override
  Future<S> consume<S>({
    required FutureOr<S> onSuccess(void value),
    required FutureOr<S> onError(Failure failure),
  }) async =>
      onError(failure);

  @override
  List<Object?> get props => [failure];
}
