import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../attachments.dart';
import '../form_cubit.dart';

class FormWidget<Cubit extends FormCubit> extends StatefulWidget {
  final Widget child;
  final Cubit Function(BuildContext context) create;
  final bool scroll;
  final bool unfocus;
  final EdgeInsetsGeometry padding;

  const FormWidget({
    Key? key,
    this.scroll = true,
    this.unfocus = true,
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
      create: widget.create,
      child: Builder(builder: _buildForm),
    );
  }
}
