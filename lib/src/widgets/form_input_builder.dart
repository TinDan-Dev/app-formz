import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../form_cubit.dart';
import '../form_state.dart';
import '../input/input.dart';
import '../utils/extensions.dart';

class FormInputState<T> {
  final T? value;
  final bool enabled;
  final String? error;
  final bool pure;

  FormInputState._({
    required this.value,
    required this.enabled,
    required this.error,
    required this.pure,
  });
}

class FormInputBuilder<Cubit extends FormCubit, T, E> extends StatelessWidget {
  final String name;
  final String Function(E error)? mapError;
  final Widget Function(BuildContext context, FormInputState<T> state) builder;

  const FormInputBuilder({
    Key? key,
    this.mapError,
    required this.name,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Cubit, FormState>(
      buildWhen: (previous, current) =>
          previous.getInput(name) != current.getInput(name) || previous.submission != current.submission,
      builder: (context, state) {
        final input = state.getInput<Input<T, E>>(name);
        final inputState = FormInputState._(
          value: input.value,
          enabled: !state.submission,
          error: input.error.let((some) => mapError?.call(some)),
          pure: input.pure,
        );

        return builder(context, inputState);
      },
    );
  }
}
