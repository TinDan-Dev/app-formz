import '../either/either_map.dart';
import 'result.dart';

extension NullableResult<T> on Result<T?> {
  Result<T> notNull() => mapRightFlat((value) {
        if (value == null) {
          return Failure<T>(message: 'Value $T is null');
        } else {
          return Result<T>.right(value);
        }
      });
}
