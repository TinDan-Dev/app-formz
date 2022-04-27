import 'dart:async';

mixin DelegatingFuture<T> implements Future<T> {
  Future<T> get future;

  @override
  Stream<T> asStream() => future.asStream();

  @override
  Future<T> catchError(Function onError, {bool Function(Object error)? test}) => future.catchError(onError, test: test);

  @override
  Future<S> then<S>(FutureOr<S> onValue(T value), {Function? onError}) => future.then(onValue, onError: onError);

  @override
  Future<T> whenComplete(FutureOr Function() action) => future.whenComplete(action);

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) =>
      future.timeout(timeLimit, onTimeout: onTimeout);
}
