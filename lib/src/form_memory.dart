import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'form_cubit.dart';
import 'functional/result.dart';
import 'input/input.dart';
import 'input_container.dart';

class FormMemory with InputContainer {
  final _inputs = <Input>[];
  final _failures = <Object, Failure?>{};
  final _listeners = <Object, VoidCallback>{};

  @override
  Iterable<Input> get inputs => _inputs;

  void save<T extends Input>(T input) {
    _inputs.removeWhere((e) => e.name == input.name);
    _inputs.add(input);
  }

  @visibleForTesting
  void saveAndNotify(Object identifier, Iterable<Input> inputs, Failure? failure) {
    for (final input in inputs) save(input);
    _failures[identifier] = failure;

    _listeners.entries.where((e) => e.key != identifier).forEach((e) => e.value());
  }

  void _addListener(Object identifier, VoidCallback callback) => _listeners[identifier] = callback;

  void _removeListener(Object identifier) => _listeners.remove(identifier);

  Iterable<Input> _loadInputs(Iterable<String> targets) => _inputs.where((e) => targets.contains(e.name));

  Failure? _loadFailure(Object identifier) => _failures[identifier];
}

mixin FormMemoryMixin<T extends FormCubit> on FormCubit {
  @protected
  FormMemory get memory;

  @protected
  Object get identifier;

  @protected
  void initMemory() {
    memory._addListener(identifier, _load);
    _load();

    memory.saveAndNotify(identifier, state.inputs, state.failure);
    stream.listen((e) => memory.saveAndNotify(identifier, e.inputs, e.failure));
  }

  @protected
  void _load() {
    emit(state.copyWith(
      inputs: memory._loadInputs(state.inputs.map((e) => e.name)),
      failure: () => memory._loadFailure(identifier),
    ));
  }

  @override
  Future<void> close() async {
    super.close();

    memory._removeListener(identifier);
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
      return memory.getInput<T>(name);
    }
  }
}
