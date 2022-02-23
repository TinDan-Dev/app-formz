import '../result/result.dart';
import 'exception.dart';
import 'parser.dart';

abstract class MParser<Source, Target> extends Parser<Source, Target> {
  const MParser();

  @override
  Result<Target> parse(Source source) {
    try {
      return Result.right(createInstance(source));
    } on ViolationFailure catch (e) {
      return Result.left(e);
    }
  }

  Never error({String? msg, String? field, Object? cause, StackTrace? trace}) {
    if (msg == null) {
      if (field == null) {
        throw ViolationFailure('Unknown error', cause: cause, trace: trace);
      } else {
        throw ViolationFailure('Invalid value', field: field, cause: cause, trace: trace);
      }
    } else {
      throw ViolationFailure(msg, field: field, cause: cause, trace: trace);
    }
  }

  T right<T>(Result<T> result) {
    return result.consume(
      onRight: (value) => value,
      onLeft: (failure) => throw ViolationFailure('Result was left', cause: failure),
    );
  }

  Target createInstance(Source source);
}
