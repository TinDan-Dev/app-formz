import 'dart:async';

import '../../formz.dart';
import '../functional/result.dart';

part 'consumable_async.dart';

abstract class Consumable<T> {
  const Consumable();

  S consume<S>({
    required S onSuccess(T value),
    required S onError(Failure failure),
  });

  ConsumableAsync<T> toConsumableAsync() => _ConsumableToAsyncWrapper<T>(this);
}

mixin ConsumableMixin<T> implements Consumable<T> {
  @override
  ConsumableAsync<T> toConsumableAsync() => _ConsumableToAsyncWrapper(this);
}

extension FutureConsumableToConsumableAsync<T> on Future<Consumable<T>> {
  ConsumableAsync<T> toConsumableAsync() => _ConsumableToAsyncWrapper(this);
}

class _ConsumableToAsyncWrapper<T> extends ConsumableAsync<T> {
  final FutureOr<Consumable<T>> _target;

  _ConsumableToAsyncWrapper(this._target);

  @override
  Future<S> consume<S>({
    required FutureOr<S> onSuccess(T value),
    required FutureOr<S> onError(Failure failure),
  }) async {
    return (await _target).consume(onSuccess: onSuccess, onError: onError);
  }
}

Consumable<T> tryConsumable<T>({
  required T action(),
  required Failure toFailure(Object error, StackTrace stackTrace),
}) {
  try {
    return ValueActionResult.success(action());
  } catch (e, s) {
    return ValueActionResult.fail(toFailure(e, s));
  }
}
