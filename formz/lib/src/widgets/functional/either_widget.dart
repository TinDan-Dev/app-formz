import 'package:flutter/material.dart';

import '../../functional/either/either.dart';
import '../../functional/result/result.dart';

typedef ResultWidget<T> = EitherWidget<Failure, T>;

class EitherWidget<L, R> extends StatelessWidget {
  final Either either;

  final Widget Function(BuildContext context, L left) onLeft;

  final Widget Function(BuildContext context, R right) onRight;

  const EitherWidget({
    Key? key,
    required this.either,
    required this.onLeft,
    required this.onRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return either.consume(
      onRight: (value) => onRight(context, value),
      onLeft: (value) => onLeft(context, value),
    );
  }
}
