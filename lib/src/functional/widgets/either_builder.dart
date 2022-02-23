import 'package:flutter/material.dart';

import '../either/either.dart';

class EitherBuilder<L, R> extends StatelessWidget {
  final Either<L, R> source;

  final Widget Function(BuildContext context, R value) onRight;
  final Widget Function(BuildContext context, L value) onLeft;

  const EitherBuilder({
    Key? key,
    required this.source,
    required this.onRight,
    required this.onLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => source.consume(
        onRight: (value) => onRight(context, value),
        onLeft: (value) => onLeft(context, value),
      );
}
