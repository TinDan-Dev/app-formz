part of 'resolvable.dart';

abstract class IResolvableAsync<T> {
  Future<S?> resolve<S>({
    required bool condition(T value),
    required FutureOr<S> match(T value),
    required FutureOr<S?> noMatch(),
  });
}

mixin SaveResolvableAsyncMixin<T, R> implements IResolvableAsync<T> {
  Future<S> resolveSave<S>({
    required bool condition(T value),
    required FutureOr<S> match(T value),
    required FutureOr<S> noMatch(),
  }) =>
      resolve(condition: condition, match: match, noMatch: noMatch) as Future<S>;
}

extension IResolvableAsyncExtension<T> on IResolvableAsync<T> {
  ResolvableAsyncChainElement<T, S> chain<S>({
    required bool condition(T failure),
    required FutureOr<S> callback(T failure),
  }) {
    return ResolvableAsyncChainElement(
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
}

class ResolvableAsyncChainElement<T, S> {
  final IResolvableAsync<T> _target;
  final Future<S?> Function(FutureOr<S?> Function() noMatch) _resolvePrevious;

  ResolvableAsyncChainElement(this._target, this._resolvePrevious);

  ResolvableAsyncChainElement<T, S> chain({
    required bool condition(T value),
    required FutureOr<S> callback(T value),
  }) {
    return ResolvableAsyncChainElement(
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

  Future<S?> apply() => _resolvePrevious(() => null);

  Future<S> end({required FutureOr<S> callback(T value)}) {
    return _resolvePrevious(
      () => _target.resolve(
        condition: (_) => true,
        match: callback,
        noMatch: () => null,
      ),
    ) as Future<S>;
  }
}

class _ResolvableToAsyncWrapper<T> extends IResolvableAsync<T> {
  final IResolvable<T> _target;

  _ResolvableToAsyncWrapper(this._target);

  @override
  Future<S?> resolve<S>({
    required bool condition(T value),
    required FutureOr<S> match(T value),
    required FutureOr<S?> noMatch(),
  }) async {
    final result = _target.resolve(
      condition: condition,
      match: match,
      noMatch: noMatch,
    );

    return result;
  }
}

extension ResolvableToAsyncExtension<T> on IResolvable<T> {
  IResolvableAsync<T> toResolvableAsync() => _ResolvableToAsyncWrapper(this);
}
