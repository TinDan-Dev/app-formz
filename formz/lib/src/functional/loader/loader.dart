import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/extensions.dart';
import '../../utils/lazy.dart';
import '../result/result_state.dart';
import 'loader_emitter.dart';
import 'loader_result.dart';

part 'loader_impl.dart';

typedef LoadCallback = FutureOr<void> Function(LoaderResult previousResult, LoaderEmitter emitter);

abstract class Loader {
  static Loader delegating(LoadCallback callback) => _DelegatingLoader(callback);

  static Loader instance<T>({required T create(), void dispose(T instance)?}) =>
      _InstanceLoader<T>(create: create, dispose: dispose);

  static Loader config(Map<String, Object?> config) => _ConfigLoader(config);

  final Loader? child;

  const Loader({this.child});

  FutureOr<void> load(LoaderResult result, LoaderEmitter emitter);

  Stream<ResultState<LoaderResult>> _mapToLoaderState(Stream<EmitterUpdate> stream, LoaderResult previousResult) {
    return stream.map(
      (event) {
        return event.when(
          error: (failure) => ResultState.error(failure),
          config: (configs) => ResultState.success(previousResult.addConfigs(configs)),
          result: (key, value) {
            if (key == dynamic || key == Null) {
              return ResultState.success(previousResult);
            } else {
              return ResultState.success(previousResult.addResults({key: value}));
            }
          },
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

    final emitter = LoaderEmitter();

    unawaited(Future.microtask(() => load(previousResult, emitter)));
    yield* _switchWithChild(_mapToLoaderState(emitter.stream.distinct(), previousResult));
  }

  Loader addChild(Loader other) {
    return child.fold(
      () => _DelegatingLoader(load, child: other),
      (some) => _DelegatingLoader(load, child: some.addChild(other)),
    );
  }

  Loader operator >>(Loader other) => addChild(other);
}
