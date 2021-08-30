import 'dart:async';

import '../../formz.con.dart';
import 'cancellation_token.dart';
import 'consumable.dart';
import 'failure.dart';
import 'impl/value_action_result.dart';
import 'retries.dart';

bool _defaultShouldContinue(_) => true;

/// Wraps a function and applies retry logic to it. Thus the function is called multiple times if it throws a exception.
/// Make sure there are no side effects when calling the function multiple times.
class Retry<T> extends ConsumableAsync<T> {
  final _completer = Completer<Consumable<T>>();

  /// This function is tried.
  ///
  /// If this function throws an exception it can be called again.
  final FutureOr<T> Function() action;

  /// Maps exception thrown by the [action] to a [Failure] or a valid value.
  ///
  /// If a value is returned, the invocation attempt is considered successful.
  final Consumable<T> Function(Object? error, StackTrace? trace, CancellationToken token) errorToResult;

  /// Thid function returns whether to continue retring after a failure was returened or not.
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
          errorToResult: (error, trace, _) => ValueActionResult<T>.fail(errorToFailure(error, trace)),
          shouldContinue: shouldContinue,
        );

  Retry.cancel({
    required FutureOr<T> action(),
    required Failure errorToFailure(Object? error, StackTrace? trace, CancellationToken token),
    bool shouldContinue(Failure failure) = _defaultShouldContinue,
  }) : this.explicit(
          action: action,
          errorToResult: (error, trace, token) => ValueActionResult<T>.fail(errorToFailure(error, trace, token)),
          shouldContinue: shouldContinue,
        );

  // TODO: add test for shouldContinue

  /// Starts the retry cycle.
  ///
  /// Returns whether the [action] could be executed successfully or not.
  Future<Consumable<T>> invoke() async {
    // make sure the count does not change during one request
    final attempts = Retries.retryAttempts;
    final cancellationToken = CancellationToken();

    late Consumable<T> result;
    for (var i = 0; i <= attempts; i++) {
      try {
        result = ValueActionResult.success(await action());
        break;
      } catch (e, s) {
        result = errorToResult(e, s, cancellationToken);
        result.onError((failure) => Retries.logFunction?.call('Retry $i / $attempts failed', failure));

        final shouldCancel = !result.consume(
          onSuccess: (_) => false,
          onError: shouldContinue,
        );

        if (cancellationToken.canceled || shouldCancel) break;
      }

      await Future.delayed(Retries.timeInterpolation(i));
    }

    _completer.complete(result);
    return result;
  }

  @override
  Future<S> consume<S>({
    required FutureOr<S> onSuccess(T value),
    required FutureOr<S> onError(Failure failure),
  }) async =>
      (await _completer.future).consume(
        onSuccess: (value) async => onSuccess(value),
        onError: (failure) async => onError(failure),
      );
}
