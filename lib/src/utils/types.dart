import 'package:flutter_bloc/flutter_bloc.dart';

import '../form_cubit.dart';
import '../form_state.dart';

typedef FormStateBuilder<T extends FormCubit> = BlocBuilder<T, FormState>;
typedef FormStateListener<T extends FormCubit> = BlocListener<T, FormState>;
