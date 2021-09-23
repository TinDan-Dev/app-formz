import 'dart:async';

import '../functional/either/either.dart';
import '../functional/result.dart';
import 'cancellation_token.dart';
import 'retries.dart';

bool _defaultShouldContinue(_) => true;

/// Wraps a function and applies retry logic to it. Thus the function is called multiple times if it throws a exception.
/// Make sure there are no side effects when calling the function multiple times.
class Retry<T> implements ResultFuture<T> {
  final _completer = Completer<Result<T>>();

  /// This function is tried.
  ///
  /// If this function throws an exception it can be called again.
  final FutureOr<T> Function() action;

  /// Maps exception thrown by the [action] to a [Failure] or a valid value.
  ///
  /// If a value is returned, the invocation attempt is considered successful.
  final Result<T> Function(Object? error, StackTrace? trace, CancellationToken token) errorToResult;

  /// This function returns whether to continue retrying after a failure was returned or not.
  ///
  /// If this returns false no further retries will be issued.
  final bool Function(Failure failure) shouldContinue;

  Retry.explicit({
    required this.action,
    required this.errorToResult,
    this.shouldContinue = _defaultShouldContinue,
  });

  Retry({
    required FutureOr<T> action(),
    required Failure errorToFailure(Object? error, StackTrace? trace),
    bool shouldContinue(Failure failure) = _defaultShouldContinue,
  }) : this.explicit(
          action: action,
          errorToResult: (error, trace, _) => Result<T>.left(errorToFailure(error, trace)),
          shouldContinue: shouldContinue,
        );

  Retry.cancel({
    required FutureOr<T> action(),
    required Failure errorToFailure(Object? error, StackTrace? trace, CancellationToken token),
    bool shouldContinue(Failure failure) = _defaultShouldContinue,
  }) : this.explicit(
          action: action,
          errorToResult: (error, trace, token) => Result<T>.left(errorToFailure(error, trace, token)),
          shouldContinue: shouldContinue,
        );

  /// Starts the retry cycle.
  ///
  /// Returns whether the [action] could be executed successfully or not.
  Future<Result<T>> invoke() async {
    // make sure the count does not change during one request
    final attempts = Retries.retryAttempts;
    final cancellationToken = CancellationToken();

    Result<T>? result;
    for (var i = 0; i <= attempts; i++) {
      try {
        result = Result.right(await action());
        break;
      } catch (e, s) {
        result = errorToResult(e, s, cancellationToken);
        result.onLeft((failure) => Retries.logFunction?.call('Retry $i / $attempts failed', failure));

        final shouldCancel = !result.consume(
          onLeft: shouldContinue,
          onRight: (_) => false,
        );

        if (cancellationToken.canceled || shouldCancel) break;
      }

      await Future.delayed(Retries.timeInterpolation(i));
    }

    // the attempts need to be greater then 0, therefor [result] cannot be null
    // here and the bang operator is safe

    _completer.complete(result!);
    return result;
  }

  @override
  Future<S> consume<S>({
    required FutureOr<S> onLeft(Failure value),
    required FutureOr<S> onRight(T value),
  }) async {
    return (await _completer.future).consume(
      onLeft: (value) async => onLeft(value),
      onRight: (value) async => onRight(value),
    );
  }
}
