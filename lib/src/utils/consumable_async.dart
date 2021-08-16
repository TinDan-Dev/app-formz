part of 'consumable.dart';

abstract class ConsumableAsync<T> {
  const ConsumableAsync();

  Future<S> consume<S>({
    required FutureOr<S> onSuccess(T value),
    required FutureOr<S> onError(Failure failure),
  });

  Future<Consumable<T>> toSync() async {
    return consume(
      onSuccess: (value) => ValueActionResult.success(value),
      onError: (failure) => ValueActionResult.fail(failure),
    );
  }
}

mixin ConsumableAsyncMixin<T> implements ConsumableAsync<T> {
  @override
  Future<Consumable<T>> toSync() async {
    return consume(
      onSuccess: (value) => ValueActionResult.success(value),
      onError: (failure) => ValueActionResult.fail(failure),
    );
  }
}

Future<Consumable<T>> tryAsyncConsumable<T>({
  required Future<T> action(),
  required Failure toFailure(Object error, StackTrace stackTrace),
}) async {
  try {
    return ValueActionResult.success(await action());
  } catch (e, s) {
    return ValueActionResult.fail(toFailure(e, s));
  }
}
