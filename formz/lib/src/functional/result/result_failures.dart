import '../../../formz.dart';

class NullFailure<R> extends Failure<R> with ActionFailure<R> {
  @override
  final bool shouldRetry;

  NullFailure(
    String sourceDescription, {
    Object? cause,
    StackTrace? trace,
    this.shouldRetry = true,
  }) : super(
          message: 'The value of $sourceDescription was null or not found',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class UnsupportedFailure<R> extends Failure<R> with ActionFailure<R> {
  @override
  final bool shouldRetry;

  UnsupportedFailure(
    String description, {
    Object? cause,
    StackTrace? trace,
    this.shouldRetry = false,
  }) : super(
          message: 'Unsupported: $description',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class InvalidFailure<R> extends Failure<R> with ActionFailure<R> {
  @override
  final bool shouldRetry;

  InvalidFailure(
    String description, {
    Object? cause,
    StackTrace? trace,
    this.shouldRetry = true,
  }) : super(
          message: 'Invalid: $description',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class UnexpectedFailure<R> extends Failure<R> with ActionFailure<R> {
  @override
  final bool shouldRetry;

  UnexpectedFailure(
    String description, {
    Object? cause,
    StackTrace? trace,
    this.shouldRetry = true,
  }) : super(
          message: 'Unexpected: $description',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class ExceptionFailure<R> extends Failure<R> with ActionFailure<R> {
  @override
  final bool shouldRetry;

  ExceptionFailure(
    Object cause, {
    StackTrace? trace,
    this.shouldRetry = true,
  }) : super(
          message: 'Failure cause by: ${cause.runtimeType}',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class TimeoutFailure<R> extends Failure<R> with ActionFailure<R> {
  @override
  final bool shouldRetry;

  final Duration duration;

  TimeoutFailure(
    String msg, {
    required this.duration,
    Object? cause,
    StackTrace? trace,
    this.shouldRetry = true,
  }) : super(
          message: 'Timeout after $duration: $msg',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class IOFailure<R> extends Failure<R> with ActionFailure<R> {
  @override
  final bool shouldRetry;

  IOFailure(
    String msg, {
    Object? cause,
    StackTrace? trace,
    this.shouldRetry = true,
  }) : super(
          message: 'IO operation failed: $msg',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class PermissionFailure<R> extends Failure<R> with ActionFailure<R> {
  @override
  final bool shouldRetry;

  final bool permanently;

  PermissionFailure(
    String msg, {
    this.permanently = false,
    Object? cause,
    StackTrace? trace,
    this.shouldRetry = false,
  }) : super(
          message: 'Permission denied${permanently ? ' permanently' : ''}: $msg',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}
