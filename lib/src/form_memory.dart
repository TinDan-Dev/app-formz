import 'dart:async';

import 'package:meta/meta.dart';

import 'form_cubit.dart';
import 'functional/result.dart';
import 'input/input.dart';
import 'input_container.dart';

class FormMemory with InputContainer {
  final _inputs = <Input>[];
  final _failures = <Type, Failure?>{};
  final _listeners = <Type, void Function()>{};

  @override
  Iterable<Input> get inputs => _inputs;

  void save<T extends Input>(T input) {
    _inputs.removeWhere((e) => e.name == input.name);
    _inputs.add(input);
  }

  @visibleForTesting
  void saveAndNotify(Type type, Iterable<Input> inputs, Failure? failure) {
    for (final input in inputs) save(input);
    _failures[type] = failure;

    _listeners.entries.where((e) => e.key != type).forEach((e) => e.value());
  }

  Iterable<Input> _loadInputs(Iterable<String> targets) => _inputs.where((e) => targets.contains(e.name));

  Failure? _loadFailure(Type type) => _failures[type];
}

mixin FormMemoryMixin on FormCubit {
  @protected
  FormMemory get memory;

  @protected
  void initMemory() {
    memory._listeners[runtimeType] = _load;
    _load();

    memory.saveAndNotify(runtimeType, state.inputs, null);
    stream.listen((e) => memory.saveAndNotify(runtimeType, e.inputs, e.failure));
  }

  @protected
  void _load() {
    emit(state.copyWith(
      inputs: memory._loadInputs(state.inputs.map((e) => e.name)),
      failure: () => memory._loadFailure(runtimeType),
    ));
  }

  @override
  Future<void> close() async {
    super.close();

    memory._listeners.remove(runtimeType);
  }

  @override
  T getInput<T extends Input>(String name) {
    final inputCandidates = state.inputs.where((e) => e.name == name);
    assert(inputCandidates.length <= 1, '${inputCandidates.length} with name: $name');

    if (inputCandidates.length > 0) {
      final input = inputCandidates.first;
      assert(input is T, 'Input found of type ${input.runtimeType} but $T was requested');

      return input as T;
    } else {
      final memoryCandidates = memory._inputs.where((e) => e.name == name);
      assert(memoryCandidates.length == 1, '${memoryCandidates.length} inputs found with name $name in memory');

      final input = memoryCandidates.first;
      assert(input is T, 'Input found in memory of type ${input.runtimeType} but $T was requested');

      return input as T;
    }
  }
}
