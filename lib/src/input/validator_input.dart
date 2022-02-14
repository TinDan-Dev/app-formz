import '../functional/parser/exception.dart';
import '../functional/parser/validator.dart';
import '../functional/result/result.dart';
import 'input.dart';

Input<T> createValidatorInput<T>(
  Validator<T?> validator, {
  required String name,
  bool pure = true,
  T? value,
}) =>
    Input<T>.create(
      validator.validate,
      name: name,
      pure: pure,
      value: value,
    );

Input<T> createOptionalValidatorInput<T>(
  Validator<T?> validator, {
  required PureDelegate<T?> pureDelegate,
  required String name,
  bool pure = true,
  T? value,
}) =>
    OptionalInput<T>.create(
      validator.validate,
      pureDelegate: pureDelegate,
      name: name,
      pure: pure,
      value: value,
    );

Input<T> createInput<T>(
  bool validate(T? value), {
  required String name,
  bool pure = true,
  T? value,
}) =>
    Input<T>.create(
      (value) {
        if (validate(value)) {
          return const Result.right(null);
        } else {
          return Result.left(ViolationFailure('value is null'));
        }
      },
      name: name,
      pure: pure,
      value: value,
    );

Input<T> createOptionalInput<T>(
  bool validate(T? value), {
  required String name,
  required PureDelegate<T?> pureDelegate,
  bool pure = true,
  T? value,
}) =>
    OptionalInput<T>.create(
      (value) {
        if (validate(value)) {
          return const Result.right(null);
        } else {
          return Result.left(ViolationFailure('value is null'));
        }
      },
      pureDelegate: pureDelegate,
      name: name,
      pure: pure,
      value: value,
    );
