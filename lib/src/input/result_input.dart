import '../functional/parser/exception.dart';
import '../functional/result/result.dart';
import 'input.dart';

Input<Result<T>> createResultInput<T>({
  required String name,
  bool pure = true,
  Result<T>? value,
}) =>
    Input<Result<T>>.create(
      (value) {
        if (value != null) {
          return value;
        } else {
          return Result.left(ViolationFailure('result is null'));
        }
      },
      name: name,
      pure: pure,
      value: value,
    );

Input<Result<T>> createOptionalResultInput<T>({
  required String name,
  required PureDelegate<Result<T>?> pureDelegate,
  bool pure = true,
  Result<T>? value,
}) =>
    OptionalInput<Result<T>>.create(
      (value) {
        if (value != null) {
          return value;
        } else {
          return Result.left(ViolationFailure('result is null'));
        }
      },
      pureDelegate: pureDelegate,
      name: name,
      pure: pure,
      value: value,
    );
