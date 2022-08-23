import '../either/either.dart';
import 'result.dart';
import 'result_failures.dart';

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
  Stream<Result<T>> notEmpty() async* {
    var empty = true;

    await for (final value in this) {
      yield value;
      empty = false;
    }

    if (empty) {
      yield UnexpectedFailure('stream was empty');
    }
  }

  Future<Result<void>> allRight() async {
    await for (final value in this) {
      if (value.left) {
        return value;
      }
    }

    return const Result.right(null);
  }
}
