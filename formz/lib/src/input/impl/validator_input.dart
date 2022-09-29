import '../../functional/parser/validator.dart';
import '../input.dart';
import 'default_input.dart';

Input<T> createValidatorInput<T>(
  Validator<T> validator, {
  required InputIdentifier<T> id,
  required T value,
  bool pure = true,
}) =>
    createInput<T>(
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
    createOptionalInput<T>(
      validator.validate,
      pureDelegate: pureDelegate,
      id: id,
      pure: pure,
      value: value,
    );
