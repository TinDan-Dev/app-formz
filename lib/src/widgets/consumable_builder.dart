import 'package:flutter/material.dart';

import '../functional/result.dart';
import '../utils/consumable.dart';

class ConsumableBuilder<T> extends StatelessWidget {
  final Consumable<T> consumable;

  final Widget Function(BuildContext context, T value) onSuccess;
  final Widget Function(BuildContext context, Failure failure) onError;

  const ConsumableBuilder({
    Key? key,
    required this.consumable,
    required this.onSuccess,
    required this.onError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => consumable.consume(
        onSuccess: (value) => onSuccess(context, value),
        onError: (failure) => onError(context, failure),
      );
}
