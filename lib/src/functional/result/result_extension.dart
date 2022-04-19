import '../either/either_map.dart';
import 'result.dart';
import 'result_failures.dart';

extension NullableResult<T> on Result<T?> {
  Result<T> notNull() => mapRightFlat((value) {
        if (value == null) {
          return NullFailure<T>(T.toString());
        } else {
          return Result<T>.right(value);
        }
      });
}
