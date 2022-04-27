part of 'loader.dart';

class _ConfigLoader extends Loader<void> {
  final Map<String, Object?> config;

  const _ConfigLoader(this.config, {Loader? child}) : super(child: child);

  @override
  FutureOr<void> load(LoaderResult previousResult, LoaderEmitter<void> emitter) {
    emitter.addConfig(config);
  }
}

class _DelegatingLoader<T> extends Loader<T> {
  final LoadCallback<T> callback;

  const _DelegatingLoader(this.callback, {Loader? child}) : super(child: child);

  @override
  FutureOr<void> load(LoaderResult previousResult, LoaderEmitter<T> emitter) {
    return callback(previousResult, emitter);
  }
}

class _InstanceLoader<T> extends Loader<T> {
  final FutureOr<T> Function() create;
  final void Function(T instance)? dispose;

  const _InstanceLoader({required this.create, this.dispose, Loader? child}) : super(child: child);

  @override
  FutureOr<void> load(LoaderResult previousResult, LoaderEmitter<T> emitter) async {
    final result = await create();

    emitter.addValue(result);
    emitter.onDone(() => dispose?.call(result));
  }
}

abstract class DelegatingLoader<T> extends Loader<T> {
  late final Lazy<Loader<T>> _loader;

  DelegatingLoader() {
    _loader = Lazy(() => loader);
  }

  Loader<T> get loader;

  @override
  @nonVirtual
  FutureOr<void> load(LoaderResult previousResult, LoaderEmitter<T> emitter) => throw UnimplementedError();

  @override
  Stream<ResultState<LoaderResult>> invoke(LoaderResult previousResult) => _loader.value.invoke(previousResult);
}
