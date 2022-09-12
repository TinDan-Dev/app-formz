import 'dart:async';

import '../either/either_map.dart';
import '../task/cancellation_token.dart';
import 'result.dart';
import 'result_failures.dart';

extension NullableResultExtension<T> on Result<T?> {
  Result<T> notNull() => mapRightFlat((value) {
        if (value == null) {
          return NullFailure<T>(T.toString());
        } else {
          return Result<T>.right(value);
        }
      });
}

extension FutureNullableResultExtension<T> on FutureOr<Result<T?>> {
  Future<Result<T>> notNull() async => (await this).notNull();
}

extension ResultExtension<T> on Result<T> {
  Result<T> cancel(CancellationReceiver receiver, [String msg = 'Result was canceled']) {
    if (receiver.canceled) {
      return CanceledFailure(msg);
    } else {
      return this;
    }
  }
}

extension FutureResultExtension<T> on FutureOr<Result<T>> {
  Future<Result<T>> cancel(CancellationReceiver receiver, [String msg = 'Result was canceled']) async =>
      (await this).cancel(receiver, msg);
}
