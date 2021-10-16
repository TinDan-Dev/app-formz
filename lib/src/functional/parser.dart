import 'either/either.dart';
import 'result.dart';
import 'validation_functions.dart';

class ParserFailure<T> extends Failure {
  ParserFailure(String message, {Object? cause, StackTrace? trace})
      : super(
          message: 'Exception while parsing $T: $message',
          cause: cause,
          trace: trace ?? StackTrace.current,
        );
}

class Parser<T> {
  S parseValue<S>(
    S? value, {
    required ValidationFunc<S> validate,
    S fallback()?,
  }) {
    final valid = validate(value);
    if (valid) {
      if (value is! S) {
        throw ParserFailure<T>('Value is not of type $S: $value', cause: value);
      }

      return value;
    }
    if (fallback != null) {
      return fallback();
    }

    throw ParserFailure<T>('Invalid value $S: $value', cause: value);
  }

  S parseResult<S>(
    Either<dynamic, S?> result, {
    required ValidationFunc<S> validate,
    S fallback()?,
  }) {
    return result.consume(
      onRight: (value) => parseValue(value, validate: validate, fallback: fallback),
      onLeft: (left) => throw ParserFailure<T>('Value $S was left: $left'),
    );
  }

  void error(String message, {Object? cause}) {
    throw ParserFailure<T>(message, cause: cause);
  }

  void errorInvalidValue(String fieldName, {required Object? value}) {
    throw ParserFailure<T>('Invalid field $fieldName: $value', cause: value);
  }
}

Result<T> parse<T>(T parse(Parser parser)) {
  final parser = Parser<T>();

  try {
    return Result.right(parse(parser));
  } on ParserFailure catch (e) {
    return Result.left(e);
  } catch (e, s) {
    return Result.left(ParserFailure('Unknown exception: $e', cause: e, trace: s));
  }
}
