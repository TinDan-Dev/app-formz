import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/consumable.dart';
import '../utils/extensions.dart';
import '../utils/failure.dart';

class ConsumableAsyncBuilder<T> extends StatelessWidget {
  final FutureOr<ConsumableAsync<T>> consumable;

  final Widget Function(BuildContext context) onLoading;
  final Widget Function(BuildContext context, T value) onSuccess;
  final Widget Function(BuildContext context, Failure failure) onError;

  const ConsumableAsyncBuilder({
    Key? key,
    required this.consumable,
    required this.onLoading,
    required this.onSuccess,
    required this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Consumable<T>>(
      future: (() async => (await consumable).toSync())(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return onLoading(context);

        if (snapshot.hasError) {
          return onError(
              context,
              Failure(
                message: 'Future completed with error',
                cause: snapshot.error,
                trace: StackTrace.current,
              ));
        }

        return snapshot.data.fold(
          () => onError(
              context,
              Failure(
                message: 'Future completed with null',
                trace: StackTrace.current,
              )),
          (some) => some.consume(
            onSuccess: (value) => onSuccess(context, value),
            onError: (failure) => onError(context, failure),
          ),
        );
      },
    );
  }
}
