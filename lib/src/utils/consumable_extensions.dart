import 'dart:async';

import '../../formz.dart';
import '../functional/result.dart';
import 'consumable.dart';

part 'consumable_extensions_async.dart';

class _ConsumeResult<T> {
  final bool valid;
  final T? value;
  final Failure? failure;

  _ConsumeResult({
    required this.valid,
    this.value,
    this.failure,
  });
}

extension IterableConsumableExtension<T> on Iterable<Consumable<T>> {
  Iterable<T> whereSuccessful() sync* {
    for (final value in this) {
      final result = value.consume(
        onSuccess: (value) => _ConsumeResult(valid: true, value: value),
        onError: (_) => _ConsumeResult(valid: false),
      );

      if (result.valid) yield result.value as T;
    }
  }

  Iterable<Failure> whereError() sync* {
    for (final value in this) {
      final result = value.consume(
        onSuccess: (value) => _ConsumeResult(valid: false),
        onError: (failure) => _ConsumeResult(valid: true, failure: failure),
      );

      if (result.valid) yield result.failure!;
    }
  }

  Consumable<void> toConsumable() {
    for (final value in this) {
      final result = value.consume(
        onSuccess: (_) => null,
        onError: (failure) => ActionResult.fail(failure),
      );

      if (result != null) return result;
    }

    return ActionResult.success();
  }
}

extension HelperFutureConsumableExtension<T> on FutureOr<Consumable<T>> {
  Future<ConsumableAsync<T>> toConsumableAsync() async => (await this).toConsumableAsync();

  Future<S> consume<S>({
    required FutureOr<S> onSuccess(T value),
    required FutureOr<S> onError(Failure failure),
  }) async =>
      (await this).consume(onSuccess: onSuccess, onError: onError);
}
