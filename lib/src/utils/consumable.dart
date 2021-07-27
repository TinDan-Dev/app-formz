import 'dart:async';

import '../../formz.dart';
import 'failure.dart';
import 'resolvable.dart';

part 'consumable_async.dart';

abstract class Consumable<T> implements IResolvable<Failure> {
  const Consumable();

  S consume<S>({
    required S onSuccess(T value),
    required S onError(Failure failure),
  });

  @override
  S? resolve<S>({
    required bool condition(Failure value),
    required S match(Failure value),
    required S? noMatch(),
  }) {
    return consume(
      onSuccess: (_) => noMatch(),
      onError: (failure) {
        if (condition(failure))
          return match(failure);
        else
          return noMatch();
      },
    );
  }

  ConsumableAsync<T> toConsumableAsync() => _ConsumableToAsyncWrapper<T>(this);
}

mixin ConsumableMixin<T> implements Consumable<T> {
  @override
  S? resolve<S>({
    required bool condition(Failure value),
    required S match(Failure value),
    required S? noMatch(),
  }) {
    return consume(
      onSuccess: (_) => noMatch(),
      onError: (failure) {
        if (condition(failure))
          return match(failure);
        else
          return noMatch();
      },
    );
  }

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
