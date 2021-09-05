import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../form_cubit.dart';
import '../form_state.dart';
import '../functional/result.dart';
import '../utils/extensions.dart';

class FormErrorBuilder<Cubit extends FormCubit> extends StatelessWidget {
  final Widget Function(BuildContext context, Failure failure) builder;

  const FormErrorBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const placeholder = SizedBox.shrink();

    return BlocBuilder<Cubit, FormState>(
      buildWhen: (previous, current) =>
          previous.failure != current.failure || previous.submission != current.submission,
      builder: (context, state) {
        if (state.submission) return placeholder;

        return state.failure.fold(() => placeholder, (some) => builder(context, some));
      },
    );
  }
}
