part of 'consumable_extensions.dart';

extension IterableConsumableAsyncExtension<T> on Iterable<ConsumableAsync<T>> {
  Stream<T> whereSuccessful() async* {
    for (final value in this) {
      final result = await value.consume(
        onSuccess: (value) => _ConsumeResult(valid: true, value: value),
        onError: (_) => _ConsumeResult(valid: false),
      );

      if (result.valid) yield result.value as T;
    }
  }

  Stream<Failure> whereError() async* {
    for (final value in this) {
      final result = await value.consume(
        onSuccess: (value) => _ConsumeResult(valid: false),
        onError: (failure) => _ConsumeResult(valid: true, failure: failure),
      );

      if (result.valid) yield result.failure!;
    }
  }
}

extension HelperConsumableAsyncFutureExtensions<T> on FutureOr<ConsumableAsync<T>> {
  Future<Consumable<T>> toSync() async => (await this).toSync();

  Future<S> consume<S>({
    required FutureOr<S> onSuccess(T value),
    required FutureOr<S> onError(Failure failure),
  }) async =>
      (await this).consume(onSuccess: onSuccess, onError: onError);
}
