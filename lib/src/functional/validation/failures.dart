part of 'validator.dart';

class ValidationFailure extends Failure {
  ValidationFailure(
    String msg, {
    String? name,
    Object? cause,
    StackTrace? trace,
  }) : super(
          message: name.fold(() => msg, (some) => '$name\nMessage: $msg\n'),
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class MatchFailure extends ValidationFailure {
  MatchFailure(
    String msg, {
    String? name,
    Object? cause,
    StackTrace? trace,
  }) : super(
          msg,
          name: name,
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}
