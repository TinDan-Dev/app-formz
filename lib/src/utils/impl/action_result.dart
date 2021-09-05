import 'package:equatable/equatable.dart';

import '../../functional/result.dart';
import '../consumable.dart';

abstract class ActionResult extends Consumable<void> with EquatableMixin {
  const ActionResult();

  const factory ActionResult.success() = _ActionResultSuccess;
  const factory ActionResult.fail(Failure failure) = _ActionResultFailure;
}

class _ActionResultSuccess extends ActionResult {
  const _ActionResultSuccess();

  @override
  S consume<S>({
    required S onSuccess(void value),
    required S onError(Failure failure),
  }) =>
      onSuccess(null);

  @override
  List<Object?> get props => [];
}

class _ActionResultFailure extends ActionResult {
  final Failure failure;

  const _ActionResultFailure(this.failure);

  @override
  S consume<S>({
    required S onSuccess(void value),
    required S onError(Failure failure),
  }) =>
      onError(failure);

  @override
  List<Object?> get props => [failure];
}
