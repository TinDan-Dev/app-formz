import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../functional/loader/loader.dart';
import '../functional/loader/loader_result.dart';
import '../functional/result/result.dart';
import '../functional/result/result_state.dart';
import '../utils/extensions.dart';
import '../utils/mutex.dart';

class LoaderWidgetFailure<T> extends Failure<T> {
  LoaderWidgetFailure(Object? cause)
      : super(
          message: 'Error while during loading',
          cause: cause,
          trace: StackTrace.current,
        );
}

class LoaderWidget extends StatefulWidget {
  final Loader loader;

  final Widget Function(BuildContext context) onLoading;
  final Widget Function(BuildContext context, LoaderResult result, Mutex updateMutex) onSuccess;
  final Widget Function(BuildContext context, Failure failure, void Function() retry) onError;

  final Mutex _updateMutex;

  LoaderWidget({
    required Loader loader,
    required this.onLoading,
    required this.onSuccess,
    required this.onError,
    Map<String, Object?> config = const {},
    Key? key,
  })  : loader = Loader.config(config) >> loader,
        _updateMutex = Mutex(),
        super(key: key);

  @override
  _LoaderWidgetState createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> {
  Stream<ResultState<LoaderResult>>? stream;
  StreamSubscription? sub;

  void _load() {
    sub?.cancel();

    final loaderStream = widget.loader.invoke(LoaderResult());
    final connectable = loaderStream.debounceMutex(widget._updateMutex).publish();

    sub = connectable.connect();
    stream = connectable;
  }

  @override
  void initState() {
    super.initState();

    _load();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ResultState<LoaderResult>>(
      stream: stream,
      initialData: const ResultState.loading(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.onError(context, LoaderWidgetFailure(snapshot.error), () => setState(_load));
        } else {
          return snapshot.data.fold(
            () => widget.onLoading(context),
            (some) => some.when(
              loading: () => widget.onLoading(context),
              success: (result) => widget.onSuccess(context, result, widget._updateMutex),
              error: (failure) => widget.onError(context, failure, () => setState(_load)),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    sub?.cancel();

    super.dispose();
  }
}
