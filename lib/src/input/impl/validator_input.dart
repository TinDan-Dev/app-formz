import '../../functional/parser/exception.dart';
import '../../functional/parser/validator.dart';
import '../../functional/result/result.dart';
import '../input.dart';

Input<T> createValidatorInput<T>(
  Validator<T> validator, {
  required InputIdentifier<T> id,
  required T value,
  bool pure = true,
}) =>
    Input<T>(
      validator.validate,
      id: id,
      pure: pure,
      value: value,
    );

Input<T> createOptionalValidatorInput<T>(
  Validator<T> validator, {
  required PureDelegate<T?> pureDelegate,
  required InputIdentifier<T> id,
  required T value,
  bool pure = true,
}) =>
    OptionalInput<T>(
      validator.validate,
      pureDelegate: pureDelegate,
      id: id,
      pure: pure,
      value: value,
    );

Input<T> createInput<T>(
  bool validate(T value), {
  required InputIdentifier<T> id,
  required T value,
  bool pure = true,
}) =>
    Input<T>(
      (value) {
        if (validate(value)) {
          return const Result.right(null);
        } else {
          return ViolationFailure('value could not be validated');
        }
      },
      id: id,
      pure: pure,
      value: value,
    );

Input<T> createOptionalInput<T>(
  bool validate(T? value), {
  required InputIdentifier<T> id,
  required PureDelegate<T?> pureDelegate,
  required T value,
  bool pure = true,
}) =>
    OptionalInput<T>(
      (value) {
        if (validate(value)) {
          return const Result.right(null);
        } else {
          return ViolationFailure('value could not be validated');
        }
      },
      pureDelegate: pureDelegate,
      id: id,
      pure: pure,
      value: value,
    );
