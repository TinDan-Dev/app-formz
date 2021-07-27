import 'package:equatable/equatable.dart';

import '../consumable.dart';
import '../failure.dart';

abstract class ValueActionResult<T> extends Consumable<T> with EquatableMixin {
  const ValueActionResult();

  const factory ValueActionResult.success(T value) = _ValueActionResultSuccess;
  const factory ValueActionResult.fail(Failure failure) = _ValueActionResultFailure;
}

class _ValueActionResultSuccess<T> extends ValueActionResult<T> {
  final T value;

  const _ValueActionResultSuccess(this.value);

  @override
  S consume<S>({
    required S onSuccess(T value),
    required S onError(Failure failure),
  }) =>
      onSuccess(value);

  @override
  List<Object?> get props => [value];
}

class _ValueActionResultFailure<T> extends ValueActionResult<T> {
  final Failure failure;

  const _ValueActionResultFailure(this.failure);

  @override
  S consume<S>({
    required S onSuccess(T value),
    required S onError(Failure failure),
  }) =>
      onError(failure);

  @override
  List<Object?> get props => [failure];
}
