import 'dart:async';

import '../../utils/extensions.dart';
import '../either/either.dart';
import '../either/either_future.dart';

typedef Result<T> = Either<Failure, T>;
typedef ResultFuture<T> = EitherFuture<Failure, T>;
typedef ResultFutureMixin<T> = EitherFutureMixin<Failure, T>;

typedef LocalizationsDelegate<T> = String Function(T context);

class Failure {
  static LocalizationsDelegate? defaultLocalization;

  final String message;
  final Object? cause;
  final StackTrace? trace;

  Failure({
    required this.message,
    this.cause,
    this.trace,
  }) : assert(cause is! AssertionError, 'Failure of assertion error: ${cause.message}\n\n${cause.stackTrace}');

  @override
  String toString() {
    final builder = StringBuffer('Failure ($runtimeType): $message\n');

    cause.let((some) => builder.writeln('Caused by: $some'));
    trace.let((some) => builder.writeln('Trace: $some'));

    return builder.toString();
  }

  String localize(dynamic context) => defaultLocalization?.call(context) ?? 'Could not localize failure';

  Failure copyWith({
    String message()?,
    Object? cause()?,
    StackTrace? trace()?,
  }) {
    return Failure(
      message: message.fold(() => this.message, (some) => some()),
      cause: cause.fold(() => this.cause, (some) => some()),
      trace: trace.fold(() => this.trace, (some) => some()),
    );
  }
}

Result<T> runCatching<T>({
  required T action(),
  required Failure onError(Object? cause, StackTrace? trace),
}) {
  try {
    return Result.right(action());
  } catch (e, s) {
    return Result.left(onError(e, s));
  }
}

Future<Result<T>> runCatchingAsync<T>({
  required FutureOr<T> action(),
  required Failure onError(Object? cause, StackTrace? trace),
}) async {
  try {
    return Result.right(await action());
  } catch (e, s) {
    return Result.left(onError(e, s));
  }
}
