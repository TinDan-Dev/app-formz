part of 'loader.dart';

class _ConfigLoader extends Loader {
  final Map<String, Object?> config;

  const _ConfigLoader(this.config, {Loader? child}) : super(child: child);

  @override
  FutureOr<void> load(LoaderResult previousResult, LoaderEmitter emitter) {
    emitter.addConfig(config);
  }
}

class _DelegatingLoader extends Loader {
  final LoadCallback callback;

  const _DelegatingLoader(this.callback, {Loader? child}) : super(child: child);

  @override
  FutureOr<void> load(LoaderResult previousResult, LoaderEmitter emitter) => callback(previousResult, emitter);
}

class _InstanceLoader<T> extends Loader {
  final FutureOr<T> Function() create;
  final void Function(T instance)? dispose;

  const _InstanceLoader({required this.create, this.dispose, Loader? child}) : super(child: child);

  @override
  FutureOr<void> load(LoaderResult previousResult, LoaderEmitter emitter) async {
    final result = await create();

    emitter.addValue<T>(result);
    emitter.onDone(() => dispose?.call(result));
  }
}

abstract class DelegatingLoader extends Loader {
  late final Lazy<Loader> _loader;

  DelegatingLoader() {
    _loader = Lazy(() => loader);
  }

  Loader get loader;

  @override
  @nonVirtual
  Loader get child => _loader.value;

  @override
  @nonVirtual
  FutureOr<void> load(LoaderResult result, LoaderEmitter emitter) {
    emitter.addValue(null);
  }
}
