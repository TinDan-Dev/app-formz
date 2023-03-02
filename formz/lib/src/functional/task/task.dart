import 'dart:async';

import '../../utils/mutex.dart';
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

  Task<In, Out> synchronized(Mutex mutex) => _TaskSynchronized(this, mutex);

  Task<In, Out> listen({
    void onExecute(In input)?,
    void onResult(Result<Out> result, bool cancelled)?,
  }) =>
      _TaskListener(this, onExecute: onExecute, onResult: onResult);
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
  final FutureOr<Result<Out>> Function(In input, CancellationReceiver receiver) task;

  const _Task(this.task);

  @override
  FutureOr<Result<Out>> execute(In input, [CancellationReceiver receiver = const CancellationReceiver.unused()]) =>
      task(input, receiver);
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

class _TaskRetry<In, Out> extends Task<In, Out> {
  final Task<In, Out> task;
  final int _retries;
  final Duration _delay;

  _TaskRetry(this.task, int? retries, Duration? delay)
      : _retries = retries ?? Task.retries,
        _delay = delay ?? Task.retryDelay;

  @override
  Future<Result<Out>> execute(In input, [CancellationReceiver receiver = const CancellationReceiver.unused()]) =>
      _try(input, receiver, 1);

  Future<Result<Out>> _try(In input, CancellationReceiver receiver, int retry) async {
    if (receiver.canceled) return CanceledFailure('Task at retry: $retry');

    return task.execute(input, receiver).mapLeftAsyncFlat((failure) async {
      final shouldNotRetry = failure is TaskFailure && !failure.shouldRetry;
      final noMoreRetries = retry >= _retries;

      if (shouldNotRetry || noMoreRetries) {
        return Result.left(failure);
      }

      await Future.delayed(Task.timeInterpolation(maxRetries: _retries, retry: retry, delay: _delay));

      return _try(input, receiver, retry + 1);
    });
  }
}

class _TaskSynchronized<In, Out> extends Task<In, Out> {
  final Task<In, Out> task;
  final Mutex mutex;

  _TaskSynchronized(this.task, this.mutex);

  @override
  Future<Result<Out>> execute(In input, [CancellationReceiver receiver = const CancellationReceiver.unused()]) {
    return mutex.scope(() async {
      if (receiver.canceled) return CanceledFailure('Task after mutex acquired');

      return task.execute(input, receiver);
    });
  }
}

class _TaskListener<In, Out> extends Task<In, Out> {
  final Task<In, Out> task;

  final void Function(In input)? onExecute;
  final void Function(Result<Out> result, bool cancelled)? onResult;

  _TaskListener(this.task, {this.onExecute, this.onResult});

  @override
  Future<Result<Out>> execute(In input, [CancellationReceiver receiver = const CancellationReceiver.unused()]) async {
    onExecute?.call(input);

    final result = await task.execute(input, receiver);
    onResult?.call(result, receiver.canceled);

    return result;
  }
}
