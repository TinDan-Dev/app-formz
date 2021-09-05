import 'either.dart';

extension EitherIterableExtension<L, R> on Iterable<Either<L, R>> {
  Iterable<L> whereLeft() sync* {
    for (final value in this) {
      final result = value.leftOrNull();

      if (value.left) yield result as L;
    }
  }

  Iterable<R> whereRight() sync* {
    for (final value in this) {
      final result = value.rightOrNull();

      if (value.right) yield result as R;
    }
  }
}
