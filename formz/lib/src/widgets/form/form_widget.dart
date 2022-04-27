import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../attachments.dart';
import '../../form_cubit.dart';
import '../../form_memory.dart';
import 'memory_provider.dart';

class FormWidget<Cubit extends FormCubit> extends StatefulWidget {
  final Widget child;
  final Cubit Function(BuildContext context) create;
  final bool scroll;
  final bool unfocus;
  final bool initMemory;
  final EdgeInsetsGeometry padding;

  const FormWidget({
    Key? key,
    this.scroll = true,
    this.unfocus = true,
    this.initMemory = true,
    this.padding = const EdgeInsets.all(8),
    required this.create,
    required this.child,
  }) : super(key: key);

  @override
  _FormWidgetState<Cubit> createState() => _FormWidgetState<Cubit>();
}

class _FormWidgetState<Cubit extends FormCubit> extends State<FormWidget<Cubit>> {
  Widget _buildForm(BuildContext context) {
    final cubit = context.read<Cubit>();
    Widget child = Padding(padding: widget.padding, child: widget.child);

    if (widget.scroll) {
      child = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: child,
      );
    }

    if (widget.unfocus) {
      child = Container(
        constraints: const BoxConstraints.expand(),
        child: GestureDetector(
          onTap: () => cubit.unfocusAll(),
          child: child,
        ),
      );
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = widget.create(context);

        if (cubit is FormMemoryMixin && widget.initMemory) {
          final memory = MemoryProvider.of(context);
          assert(memory != null, 'No memory found for $Cubit');

          cubit.initMemory(memory!);
        }

        return cubit;
      },
      child: Builder(builder: _buildForm),
    );
  }
}
