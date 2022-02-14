import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../form_cubit.dart';
import '../form_state.dart';

typedef FormStateBuilderCondition = List<Object?> Function(FormState state);

BlocBuilderCondition<FormState>? _buildWhen(FormStateBuilderCondition? condition) {
  if (condition == null) {
    return null;
  }

  return (previous, current) {
    final previousConditions = condition(previous);
    final currentConditions = condition(current);

    if (previousConditions.length != currentConditions.length) {
      return true;
    } else {
      for (var i = 0; i < previousConditions.length; i++) {
        if (previousConditions[i] != currentConditions[i]) {
          return true;
        }
      }

      return false;
    }
  };
}

class FormStateBuilder<T extends FormCubit> extends BlocBuilder<T, FormState> {
  FormStateBuilder({
    Key? key,
    required BlocWidgetBuilder<FormState> builder,
    FormStateBuilderCondition? buildWhen,
    T? bloc,
  }) : super(key: key, builder: builder, buildWhen: _buildWhen(buildWhen), bloc: bloc);
}

class FormStateListener<T extends FormCubit> extends BlocListener<T, FormState> {
  FormStateListener({
    Key? key,
    required BlocWidgetListener<FormState> listener,
    T? bloc,
    FormStateBuilderCondition? listenWhen,
    Widget? child,
  }) : super(key: key, listener: listener, listenWhen: _buildWhen(listenWhen), bloc: bloc);
}
