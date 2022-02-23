import '../../functional/result/result.dart';
import '../input.dart';

Input<Result<T>> createResultInput<T>({
  required InputIdentifier<Result<T>> id,
  required Result<T> value,
  bool pure = true,
}) =>
    Input<Result<T>>(
      (value) => value,
      id: id,
      pure: pure,
      value: value,
    );

Input<Result<T>> createOptionalResultInput<T>({
  required InputIdentifier<Result<T>> id,
  required PureDelegate<Result<T>> pureDelegate,
  required Result<T> value,
  bool pure = true,
}) =>
    OptionalInput<Result<T>>(
      (value) => value,
      pureDelegate: pureDelegate,
      id: id,
      pure: pure,
      value: value,
    );
