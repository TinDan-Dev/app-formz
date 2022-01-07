import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/extensions.dart';
import '../either/either.dart';
import '../either_future/either_future.dart';

typedef Result<T> = Either<Failure, T>;
typedef ResultFuture<T> = EitherFuture<Failure, T>;

class Failure {
  static String Function(BuildContext context)? defaultLocalization;

  final String message;
  final Object? cause;
  final StackTrace? trace;

  const Failure({
    required this.message,
    this.cause,
    this.trace,
  });

  @override
  String toString() {
    final builder = StringBuffer('Failure ($runtimeType):\n');

    cause.let((some) => builder.writeln('Caused by: $some'));
    trace.let((some) => builder.writeln('Trace: $some'));

    return builder.toString();
  }

  String localize(BuildContext context) => defaultLocalization?.call(context) ?? 'Could not localize failure';

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
