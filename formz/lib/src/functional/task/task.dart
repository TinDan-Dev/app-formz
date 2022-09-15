import 'dart:async';

import '../../utils/extensions.dart';
import '../either/either.dart';
import '../result/result.dart';
import '../result/result_failures.dart';
import 'cancellation_token.dart';

mixin TaskFailure<T> on Failure<T> {
  bool get shouldRetry;
}

abstract class Task<In, Out> {
  static Duration timeInterpolation({
    required int maxRetries,
    required int retry,
    required Duration delay,
  }) {
    final fraction = retry.toDouble() / maxRetries.toDouble();

    return Duration(milliseconds: (delay.inMilliseconds * fraction).toInt());
  }

  static Future<Result<T>> run<T>(
    FutureOr<T> task(), {
    FutureOr<Failure?> onError(Object? error, StackTrace? trace)?,
  }) async =>
      Task.catching((_, __) => task(), onError: onError).retry().execute(null);

  static int retries = 3;
  static Duration retryDelay = const Duration(seconds: 2);

  const Task();

  const factory Task.from(FutureOr<Result<Out>> task(In input, CancellationReceiver receiver)) = _Task;

  const factory Task.catching(FutureOr<Out> task(In input, CancellationReceiver receiver),
      {FutureOr<Failure?> onError(Object? error, StackTrace? trace)?}) = _TaskCatching;

  FutureOr<Result<Out>> execute(In input, [CancellationReceiver receiver = const CancellationReceiver.unused()]);

  Task<In, Out> timeout(Duration timeout) => _TaskTimeout(this, timeout);

  Task<In, Out> retry({int? retries, Duration? delay}) => _TaskRetry(this, retries, delay);
}

abstract class SimpleTask<In, Out> extends Task<In, Out> {
  FutureOr<Out> executeSimple(In input, CancellationReceiver receiver);

  @override
  Future<Result<Out>> execute(In input, [CancellationReceiver receiver = const CancellationReceiver.unused()]) async {
    try {
      return Result.right(await executeSimple(input, receiver));
    } catch (e, s) {
      return UnexpectedFailure('Simple task ($runtimeType) failed', cause: e, trace: s);
    }
  }
}

class _Task<In, Out> extends Task<In, Out> {
  final FutureOr<Result<Out>> Function(In input, CancellationReceiver receiver) _task;

  const _Task(this._task);

  @override
  FutureOr<Result<Out>> execute(In input, [CancellationReceiver receiver = const CancellationReceiver.unused()]) =>
      _task(input, receiver);
}

class _TaskCatching<In, Out> extends Task<In, Out> {
  final FutureOr<Out> Function(In input, CancellationReceiver receiver) task;
  final FutureOr<Failure?> Function(Object? error, StackTrace? trace)? onError;

  const _TaskCatching(this.task, {this.onError});

  @override
  Future<Result<Out>> execute(In input, [CancellationReceiver receiver = const CancellationReceiver.unused()]) async {
    try {
      return Result.right(await task(input, receiver));
    } on Failure catch (e) {
      return Result.left(e);
    } catch (e, s) {
      final error = await onError?.call(e, s);

      if (error != null) {
        return Result.left(error);
      } else {
        return Result.left(ExceptionFailure(e, trace: s));
      }
    }
  }
}

class _TaskTimeout<In, Out> extends Task<In, Out> {
  final Task<In, Out> task;
  final Duration _timeout;

  const _TaskTimeout(this.task, this._timeout);

  @override
  Future<Result<Out>> execute(In input, [CancellationReceiver receiver = const CancellationReceiver.unused()]) async {
    try {
      return await Future.microtask(() => task.execute(input, receiver)).timeout(_timeout);
    } on TimeoutException {
      return TimeoutFailure('task', duration: _timeout);
    }
  }
}

class _RetryFailure<R> extends Failure<R> {
  static String _createMessage(_RetryFailure? next, Failure? cause) {
    if (next == null) {
      return 'No more retires ' + cause.fold(() => '', (some) => '(${some.message})');
    } else {
      return 'Retry failed ' +
          cause.fold(() => '', (some) => '(${some.message})') +
          '\n' +
          _createMessage(next.next, next.cause as Failure?);
    }
  }

  final _RetryFailure? next;

  _RetryFailure(
    this.next, {
    Failure? cause,
    StackTrace? trace,
  }) : super(
          message: _createMessage(next, cause),
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class _TaskRetry<In, Out> extends Task<In, Out> {
  final Task<In, Out> task;
  final int _retries;
  final Duration _delay;

  _TaskRetry(this.task, int? retries, Duration? delay)
      : _retries = retries ?? Task.retries,
        _delay = delay ?? Task.retryDelay;

  @override
  Future<Result<Out>> execute(In input, [CancellationReceiver receiver = const CancellationReceiver.unused()]) =>
      _try(input, receiver, 0);

  Future<Result<Out>> _try(In input, CancellationReceiver receiver, int retry) async {
    if (retry >= _retries) {
      return _RetryFailure(null);
    }
    if (receiver.canceled) {
      return _RetryFailure(null, cause: CanceledFailure('task'));
    }

    return task.execute(input, receiver).mapLeftAsyncFlat((failure) async {
      if (failure is TaskFailure && !failure.shouldRetry) {
        return _RetryFailure(null, cause: failure);
      }

      await Future.delayed(Task.timeInterpolation(maxRetries: _retries, retry: retry, delay: _delay));

      return _try(input, receiver, retry + 1).mapLeft((next) => _RetryFailure(next as _RetryFailure, cause: failure));
    });
  }
}