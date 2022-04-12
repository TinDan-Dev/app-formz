import '../../../formz.dart';

class NullFailure<R> extends Failure<R> {
  NullFailure(
    String sourceDescription, {
    Object? cause,
    StackTrace? trace,
  }) : super(
          message: 'The value of $sourceDescription was null or not found',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class UnexpectedFailure<R> extends Failure<R> {
  UnexpectedFailure(
    String stateDescription, {
    Object? cause,
    StackTrace? trace,
  }) : super(
          message: 'This was not expected: $stateDescription',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class ExceptionFailure<R> extends Failure<R> {
  ExceptionFailure(
    Object cause, {
    StackTrace? trace,
  }) : super(
          message: 'Failure cause by: ${cause.runtimeType}',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class TimeoutFailure<R> extends Failure<R> {
  TimeoutFailure(
    String msg, {
    required Duration duration,
    Object? cause,
    StackTrace? trace,
  }) : super(
          message: 'Timeout after $duration: $msg',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class IOFailure<R> extends Failure<R> {
  IOFailure(
    String msg, {
    Object? cause,
    StackTrace? trace,
  }) : super(
          message: 'IO operation failed: $msg',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}
