import '../result/result.dart';

class ViolationFailure extends Failure implements Exception {
  final String? field;

  ViolationFailure(
    String msg, {
    this.field,
    Object? cause,
    StackTrace? trace,
  }) : super(
          message: 'Violated${field == null ? '' : ' $field'}: $msg',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}
