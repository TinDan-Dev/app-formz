import 'package:flutter/material.dart' hide FormState;

import '../../form_cubit.dart';
import '../../functional/result/result.dart';
import '../../utils/extensions.dart';
import 'form_builder.dart';

class FormErrorBuilder<Cubit extends FormCubit> extends StatelessWidget {
  final Widget Function(BuildContext context, Failure failure) builder;

  const FormErrorBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const placeholder = SizedBox.shrink();

    return FormStateBuilder<Cubit>(
      buildWhen: (state) => [state.failure, state.submission],
      builder: (context, state) {
        if (state.submission) return placeholder;

        return state.failure.fold(() => placeholder, (some) => builder(context, some));
      },
    );
  }
}
