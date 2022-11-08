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

  Result<T> handleFailure<S extends Failure>(Result<T> handler(S failure)) {
    return mapLeftFlat((failure) {
      if (failure is S) {
        return handler(failure);
      } else {
        return Result.left(failure);
      }
    });
  }

  Future<Result<T>> handleFailureAsync<S extends Failure>(FutureOr<Result<T>> handler(S failure)) {
    return mapLeftAsyncFlat((failure) async {
      if (failure is S) {
        return handler(failure);
      } else {
        return Result.left(failure);
      }
    });
  }
}

extension FutureResultExtension<T> on FutureOr<Result<T>> {
  Future<Result<T>> cancel(CancellationReceiver receiver, [String msg = 'Result was canceled']) async =>
      (await this).cancel(receiver, msg);

  Future<Result<T>> handleFailure<S extends Failure>(Result<T> handler(S failure)) async =>
      (await this).handleFailure(handler);

  Future<Result<T>> handleFailureAsync<S extends Failure>(FutureOr<Result<T>> handler(S failure)) async =>
      (await this).handleFailureAsync(handler);
}
