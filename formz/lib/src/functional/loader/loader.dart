import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/extensions.dart';
import '../../utils/lazy.dart';
import '../result/result_state.dart';
import 'loader_emitter.dart';
import 'loader_result.dart';

part 'loader_impl.dart';

typedef LoadCallback<T> = FutureOr<void> Function(LoaderResult previousResult, LoaderEmitter<T> emitter);

abstract class Loader<T> {
  final Loader? child;

  const Loader({this.child});

  const factory Loader.delegating(LoadCallback<T> callback) = _DelegatingLoader;

  const factory Loader.instance({required T create(), void dispose(T instance)?}) = _InstanceLoader;

  static Loader<void> config(Map<String, Object?> config) => _ConfigLoader(config);

  FutureOr<void> load(LoaderResult previousResult, LoaderEmitter<T> emitter);

  Stream<ResultState<LoaderResult>> _mapToLoaderState(Stream<EmitterUpdate<T>> stream, LoaderResult previousResult) {
    return stream.map(
      (event) {
        return event.when(
          error: (failure) => ResultState.error(failure),
          result: (value) => ResultState.success(previousResult.addResults({T: value})),
          config: (configs) => ResultState.success(previousResult.addConfigs(configs)),
        );
      },
    );
  }

  Stream<ResultState<LoaderResult>> _switchWithChild(Stream<ResultState<LoaderResult>> stream) {
    return child.fold(
      () => stream,
      (child) => stream.switchMap((state) {
        if (state is ResultStateSuccess<LoaderResult>) {
          return child.invoke(state.value);
        } else {
          return Stream.value(state);
        }
      }),
    );
  }

  Stream<ResultState<LoaderResult>> invoke(LoaderResult previousResult) async* {
    yield const ResultState.loading();

    final emitter = LoaderEmitter<T>();

    unawaited(Future.microtask(() => load(previousResult, emitter)));
    yield* _switchWithChild(_mapToLoaderState(emitter.stream.distinct(), previousResult));
  }

  Loader<T> addChild(Loader other) {
    return child.fold(
      () => _DelegatingLoader<T>(load, child: other),
      (some) => _DelegatingLoader<T>(load, child: child!.addChild(other)),
    );
  }

  Loader<T> operator >>(Loader other) => addChild(other);
}
