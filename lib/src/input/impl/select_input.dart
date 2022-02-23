import '../../functional/result/result.dart';
import '../input.dart';

class SelectInputFailure<R> extends Failure<R> {
  SelectInputFailure(
    Object? value,
  ) : super(
          message: 'Value was not fund in list',
          cause: value,
          trace: StackTrace.current,
        );
}

Input<T> createSelectInput<T>(
  Iterable<T> values, {
  required InputIdentifier<T> id,
  required T value,
  bool pure = false,
}) =>
    Input<T>(
      (input) {
        if (values.contains(input)) {
          return Result.right(input);
        } else {
          return SelectInputFailure(input);
        }
      },
      id: id,
      pure: pure,
      value: value,
    );
