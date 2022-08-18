import '../functional/either/either.dart';

Never unreachable() {
  throw UnimplementedError('This should be unreachable');
}

void assertRight<L, R>(Either<L, R> either, String message(L value)) {
  either.consume(
    onRight: (_) {},
    onLeft: (value) {
      assert(false, message(value));
    },
  );
}

void assertLeft<L, R>(Either<L, R> either, String message(R value)) {
  either.consume(
    onLeft: (_) {},
    onRight: (value) {
      assert(false, message(value));
    },
  );
}
