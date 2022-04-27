import 'package:flutter/material.dart';

import '../../functional/result/result.dart';
import '../../functional/result/result_state.dart';
import '../../utils/extensions.dart';

class ResultStateWidget<T> extends StatelessWidget {
  /// The result state.
  final ResultState<T> state;

  /// Builds the widget when the resource is loading.
  final Widget Function(BuildContext context) onLoading;

  /// Builds the widget when the resource was fetched successfully or when loading was called with some data.
  ///
  /// This method could be called multiple times with different data.
  final Widget Function(BuildContext context, T value) onSuccess;

  /// Builds the widget when the resource failed to load.
  final Widget Function(BuildContext context, Failure remoteFailure) onError;

  const ResultStateWidget({
    required this.state,
    required this.onLoading,
    required this.onSuccess,
    required this.onError,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return state.when(
      loading: (value) => value.fold(
        () => onLoading(context),
        (value) => onSuccess(context, value),
      ),
      success: (value) => onSuccess(context, value),
      error: (failure) => onError(context, failure),
    );
  }
}
