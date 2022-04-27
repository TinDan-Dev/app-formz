import 'package:flutter/material.dart' hide FormState;

import '../../../formz.dart';
import '../../utils/extensions.dart';
import 'form_builder.dart';

class FormInputState<T> {
  final T value;
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

class FormInputBuilder<Cubit extends FormCubit, T> extends StatelessWidget {
  final InputIdentifier<T> id;
  final String Function(Failure error)? mapError;
  final Widget Function(BuildContext context, FormInputState<T> state) builder;

  const FormInputBuilder({
    Key? key,
    this.mapError,
    required this.id,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormStateBuilder<Cubit>(
      buildWhen: (state) => [state.getInput(id), state.submission],
      builder: (context, state) {
        final input = state.getInput<T>(id);

        final inputState = FormInputState._(
          value: input.value,
          enabled: !state.submission,
          error: input.failure.let((some) => mapError?.call(some)),
          pure: input.pure,
        );

        return builder(context, inputState);
      },
    );
  }
}
