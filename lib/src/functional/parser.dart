import 'correction_functions.dart';
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
  S _parseValue<S>(
    S? value, {
    required ValidationFunc<S> validate,
    CorrectionFunction<S>? correction,
    S fallback()?,
  }) {
    assert(
      fallback == null || correction == null,
      'User either a fallback value or a correction function',
    );

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
    if (correction != null && value is S) {
      return correction(value);
    }

    throw ParserFailure<T>('Invalid value $S: $value', cause: value);
  }

  S parseValue<S>(
    S? value, {
    required ValidationFunc<S> validate,
    S fallback()?,
  }) =>
      _parseValue(value, validate: validate, fallback: fallback);

  S correctValue<S>(
    S? value, {
    required CorrectionFunction<S> correction,
  }) =>
      _parseValue(value, validate: (value) => false, correction: correction);

  S _parseResult<S>(
    Either<dynamic, S?>? result, {
    ValidationFunc<S>? validate,
    CorrectionFunction<S>? correction,
    S fallback()?,
  }) {
    if (result == null) {
      throw ParserFailure<T>('Result of $S was null');
    }

    return result.consume(
      onRight: (value) => _parseValue(
        value,
        validate: validate ?? (_) => true,
        fallback: fallback,
        correction: correction,
      ),
      onLeft: (left) => throw ParserFailure<T>('Value $S was left: $left'),
    );
  }

  S parseResult<S>(
    Either<dynamic, S?>? result, {
    ValidationFunc<S>? validate,
    S fallback()?,
  }) =>
      _parseResult(result, validate: validate, fallback: fallback);

  S correctResult<S>(
    Either<dynamic, S?>? result, {
    required CorrectionFunction<S> correction,
  }) =>
      _parseResult(result, validate: (value) => false, correction: correction);

  Never error(String message, {Object? cause}) {
    throw ParserFailure<T>(message, cause: cause);
  }

  Never errorInvalidField(String fieldName, {Object? value}) {
    throw ParserFailure<T>('Invalid field $fieldName: $value', cause: value);
  }

  Never errorInvalidState(String description) {
    throw ParserFailure<T>('Invalid state of $T: $description');
  }
}

Result<T> withParser<T>(T parse(Parser parser)) {
  final parser = Parser<T>();

  try {
    return Result.right(parse(parser));
  } on ParserFailure catch (e) {
    return Result.left(e);
  } catch (e, s) {
    return Result.left(ParserFailure('Unknown exception: $e', cause: e, trace: s));
  }
}
