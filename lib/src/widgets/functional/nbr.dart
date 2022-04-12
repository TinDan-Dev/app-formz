import 'package:flutter/material.dart';

import '../../functional/nbr/nbr.dart';
import '../../functional/result/result.dart';
import '../../functional/result/result_failures.dart';
import '../../functional/result/result_state.dart';
import 'result_state.dart';

class NBRWidget<T> extends StatelessWidget {
  /// The result state stream.
  final NBR<T> nbr;

  /// Builds the widget when the resource is loading.
  final Widget Function(BuildContext context) onLoading;

  /// Builds the widget when the resource was fetched successfully or when loading was called with some data.
  ///
  /// This method could be called multiple times with different data.
  final Widget Function(BuildContext context, T value) onSuccess;

  /// Builds the widget when the resource failed to load.
  final Widget Function(BuildContext context, Failure remoteFailure) onError;

  const NBRWidget({
    required this.nbr,
    required this.onLoading,
    required this.onSuccess,
    required this.onError,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ResultState<T>>(
      stream: nbr,
      initialData: nbr.currentState,
      builder: (context, snapshot) {
        final data = snapshot.data;

        if (data == null) {
          return onError(context, NullFailure('data'));
        } else {
          return ResultStateWidget<T>(
            state: data,
            onLoading: onLoading,
            onSuccess: onSuccess,
            onError: onError,
          );
        }
      },
    );
  }
}
