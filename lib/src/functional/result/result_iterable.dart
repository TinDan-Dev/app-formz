import '../either/either.dart';
import 'result.dart';

extension ResultIterableHelper<T> on Iterable<T> {
  Result<T> firstWhereOrResult(bool test(T element), {required Result<T> orElse()}) {
    for (final element in this) {
      if (test(element)) {
        return Result.right(element);
      }
    }

    return orElse();
  }
}

extension ResultIterableExtension<T> on Iterable<Result<T>> {
  Result<void> allRight() {
    for (final value in this) {
      if (value.left) {
        return value;
      }
    }

    return const Result.right(null);
  }
}

extension ResultStreamExtension<T> on Stream<Result<T>> {
  Future<Result<void>> allRight() async {
    await for (final value in this) {
      if (value.left) {
        return value;
      }
    }

    return const Result.right(null);
  }
}
