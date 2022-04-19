import 'result.dart';

Duration _timeInterpolation({
  required int maxRetries,
  required int retry,
  required Duration delay,
}) {
  final fraction = retry.toDouble() / maxRetries.toDouble();

  return Duration(milliseconds: (delay.inMilliseconds * fraction).toInt());
}

mixin ActionFailure<T> on Failure<T> {
  bool get shouldRetry;
}

abstract class ActionExecutor {
  static const _defaultRetries = 3;
  static const _defaultDelay = Duration(seconds: 2);
  static const _defaultTimeout = Duration(seconds: 10);

  static int _retries = _defaultRetries;
  static Duration _delay = _defaultDelay;
  static Duration _timeout = _defaultTimeout;

  static int get retries => _retries;
  static Duration get delay => _delay;
  static Duration get timeout => _timeout;

  static void setParameters({
    int? retries,
    Duration? delay,
    Duration? timeout,
  }) {
    if (retries != null) {
      assert(retries > 0);
      _retries = retries;
    }
    if (delay != null) {
      _delay = delay;
    }
    if (timeout != null) {
      _timeout = timeout;
    }
  }

  static Future<Result<T>> run<T>(
    Future<T> action(), {
    required Failure onError(Object? error, StackTrace? trace),
  }) async {
    late Failure failure;
    for (var retry = 0; retry < _retries; retry++) {
      try {
        return Result.right(await action().timeout(_timeout));
      } catch (e, s) {
        if (e is Failure) {
          failure = e;
        } else {
          failure = onError(e, s);
        }

        if (failure is ActionFailure && !failure.shouldRetry) break;
      }

      await Future.delayed(_timeInterpolation(maxRetries: _retries, retry: retry, delay: _delay));
    }

    return Result.left(failure);
  }
}
