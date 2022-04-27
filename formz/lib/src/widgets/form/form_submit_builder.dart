import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../form_cubit.dart';
import '../../form_state.dart';

class FormSubmitBuilder<Cubit extends FormCubit> extends StatelessWidget {
  final Widget Function(BuildContext context, bool enabled) builder;

  const FormSubmitBuilder({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Cubit, FormState>(
      buildWhen: (previous, current) => previous.submission != current.submission || previous.valid != current.valid,
      builder: (context, state) => builder(context, state.valid && !state.submission),
    );
  }
}
