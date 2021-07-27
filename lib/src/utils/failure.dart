import 'package:flutter/material.dart';

import 'extensions.dart';
import 'resolvable.dart';

class Failure implements IResolvable<Failure> {
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

  @override
  S? resolve<S>({
    required bool condition(Failure value),
    required S match(Failure value),
    required S? noMatch(),
  }) {
    if (condition(this))
      return match(this);
    else
      return noMatch();
  }
}
