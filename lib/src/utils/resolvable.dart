import 'dart:async';

part 'resolvable_async.dart';

abstract class IResolvable<T> {
  S? resolve<S>({
    required bool condition(T value),
    required S match(T value),
    required S? noMatch(),
  });
}

mixin SaveResolvableMixin<T, R> implements IResolvable<T> {
  S resolveSave<S>({
    required bool condition(T value),
    required S match(T value),
    required S noMatch(),
  }) =>
      resolve(condition: condition, match: match, noMatch: noMatch) as S;
}

extension IResolvableExtension<T> on IResolvable<T> {
  ResolvableChainElement<T, S> chain<S>({
    required bool condition(T value),
    required S callback(T value),
  }) {
    return ResolvableChainElement(
      this,
      (noMatch) {
        return resolve(
          condition: condition,
          match: callback,
          noMatch: noMatch,
        );
      },
    );
  }

  ResolvableAsyncChainElement<T, S> chainAsync<S>({
    required bool condition(T value),
    required FutureOr<S> callback(T value),
  }) {
    final thisAsync = toResolvableAsync();
    return ResolvableAsyncChainElement(
      thisAsync,
      (noMatch) {
        return thisAsync.resolve(
          condition: condition,
          match: callback,
          noMatch: noMatch,
        );
      },
    );
  }
}

class ResolvableChainElement<T, S> {
  final IResolvable<T> _target;
  final S? Function(S? Function() noMatch) _resolvePrevious;

  ResolvableChainElement(this._target, this._resolvePrevious);

  ResolvableChainElement<T, S> chain({
    required bool condition(T value),
    required S callback(T value),
  }) {
    return ResolvableChainElement(
      _target,
      (noMatch) {
        return _resolvePrevious(
          () => _target.resolve(
            condition: condition,
            match: callback,
            noMatch: noMatch,
          ),
        );
      },
    );
  }

  S? apply() => _resolvePrevious(() => null);

  S end({required S callback(T value)}) {
    return _resolvePrevious(
      () => _target.resolve(
        condition: (_) => true,
        match: callback,
        noMatch: () => null,
      ),
    ) as S;
  }
}
