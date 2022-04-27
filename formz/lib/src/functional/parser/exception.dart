import '../../utils/extensions.dart';
import '../result/result.dart';

class ViolationFailure<R> extends Failure<R> implements Exception {
  final String? field;
  final LocalizationsDelegate? localizationsDelegate;

  ViolationFailure._({
    required String message,
    this.field,
    this.localizationsDelegate,
    Object? cause,
    StackTrace? trace,
  }) : super(
          message: message,
          cause: cause,
          trace: trace ?? StackTrace.current,
        );

  ViolationFailure(
    String msg, {
    String? field,
    LocalizationsDelegate? localizationsDelegate,
    Object? cause,
    StackTrace? trace,
  }) : this._(
          message: 'Violated${field == null ? '' : ' $field'}: $msg',
          field: field,
          localizationsDelegate: localizationsDelegate,
          cause: cause,
          trace: trace ?? StackTrace.current,
        );

  @override
  String localize(dynamic context) =>
      localizationsDelegate.fold(() => super.localize(context), (some) => some(context));

  ViolationFailure setLocalization(LocalizationsDelegate localizationsDelegate) => ViolationFailure._(
        message: message,
        field: field,
        localizationsDelegate: localizationsDelegate,
        cause: cause,
        trace: trace,
      );
}
