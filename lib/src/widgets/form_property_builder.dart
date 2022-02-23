import 'package:flutter/material.dart' hide FormState;

import '../../formz.dart';
import '../form_cubit.dart';
import '../form_state.dart';

class FormPropertyBuilder<Cubit extends FormCubit, T> extends StatelessWidget {
  final Widget Function(BuildContext context, FormState state, T value) builder;

  final String propertyKey;

  const FormPropertyBuilder({
    Key? key,
    required this.builder,
    required this.propertyKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormStateBuilder<Cubit>(
      buildWhen: (state) => [state.getProperty(propertyKey)],
      builder: (context, state) => builder(context, state, state.getProperty(propertyKey)),
    );
  }
}
