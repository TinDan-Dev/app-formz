import 'package:flutter/material.dart';

import '../../functional/result/result.dart';
import '../../functional/result/result_failures.dart';
import '../../functional/result/result_state.dart';
import 'result_state.dart';

class ResultStreamWidget<T> extends StatefulWidget {
  /// The result state stream.
  final Stream<ResultState<T>> stateStream;

  /// Builds the widget when the resource is loading.
  final Widget Function(BuildContext context) onLoading;

  /// Builds the widget when the resource was fetched successfully or when loading was called with some data.
  ///
  /// This method could be called multiple times with different data.
  final Widget Function(BuildContext context, T value) onSuccess;

  /// Builds the widget when the resource failed to load.
  final Widget Function(BuildContext context, Failure remoteFailure) onError;

  /// Whether to use the last known value as initial data or not.
  final bool gaplessPlayback;

  const ResultStreamWidget({
    required this.stateStream,
    required this.onLoading,
    required this.onSuccess,
    required this.onError,
    this.gaplessPlayback = true,
    Key? key,
  }) : super(key: key);

  @override
  State<ResultStreamWidget<T>> createState() => _ResultStreamWidgetState<T>();
}

class _ResultStreamWidgetState<T> extends State<ResultStreamWidget<T>> {
  ResultState<T>? lastValue;

  @override
  void didUpdateWidget(covariant ResultStreamWidget<T> oldWidget) {
    if (oldWidget.stateStream != widget.stateStream) {
      setState(() {});
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ResultState<T>>(
      stream: widget.stateStream,
      initialData: (widget.gaplessPlayback ? lastValue : null) ?? const ResultState.loading(),
      builder: (context, snapshot) {
        final data = lastValue = snapshot.data;

        if (data == null) {
          return widget.onError(context, NullFailure('data'));
        } else {
          return ResultStateWidget<T>(
            state: data,
            onLoading: widget.onLoading,
            onSuccess: widget.onSuccess,
            onError: widget.onError,
          );
        }
      },
    );
  }
}
