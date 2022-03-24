import 'package:flutter/material.dart' hide Path;

import '../form_memory.dart';
import '../nav/path.dart';
import '../utils/extensions.dart';

class MemoryProvider extends StatefulWidget {
  static FormMemory? of(BuildContext context) {
    return context.findAncestorStateOfType<_MemoryProviderState>()?.memory;
  }

  final Widget child;

  final void Function(FormMemory memory)? initMemory;

  MemoryProvider({
    required Path path,
    required this.child,
    this.initMemory,
  }) : super(key: ValueKey(path));

  @override
  State<MemoryProvider> createState() => _MemoryProviderState();
}

class _MemoryProviderState extends State<MemoryProvider> {
  late final FormMemory memory;

  @override
  void initState() {
    memory = FormMemory();
    widget.initMemory.let((some) => some(memory));

    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
