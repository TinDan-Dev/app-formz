import 'dart:async';

import 'package:flutter/material.dart';

import 'form_cubit.dart';
import 'functional/result/result.dart';
import 'input/input.dart';
import 'input_container.dart';

class FormMemory with InputContainer {
  final _inputs = <Input>[];
  final _failures = <Object, Failure?>{};
  final _listeners = <Object, VoidCallback>{};

  @override
  Iterable<Input> get inputs => _inputs;

  void save(Input input) {
    _inputs.removeWhere((e) => e.id == input.id);
    _inputs.add(input);
  }

  @visibleForTesting
  void saveAndNotify(Object identifier, Iterable<Input> inputs, Failure? failure) {
    for (final input in inputs) {
      save(input);
    }
    _failures[identifier] = failure;

    _listeners.entries.where((e) => e.key != identifier).forEach((e) => e.value());
  }

  void _addListener(Object identifier, VoidCallback callback) => _listeners[identifier] = callback;

  void _removeListener(Object identifier) => _listeners.remove(identifier);

  Iterable<Input> _loadInputs(Iterable<InputIdentifier> targets) => _inputs.where((e) => targets.contains(e.id));

  Failure? _loadFailure(Object identifier) => _failures[identifier];
}

mixin FormMemoryMixin<T extends FormCubit> on FormCubit {
  bool _debugMemorySet = false;
  late final FormMemory memory;

  @protected
  Object get identifier;

  bool get syncManual => false;

  void initMemory(FormMemory memory) {
    assert(
      () {
        if (_debugMemorySet) return false;

        _debugMemorySet = true;
        return true;
      }(),
      'Do not call init memory twice',
    );

    this.memory = memory;

    memory._addListener(identifier, _load);
    _load();

    memory.saveAndNotify(identifier, state.inputs, state.failure);

    if (!syncManual) {
      stream.listen((e) => memory.saveAndNotify(identifier, e.inputs, e.failure));
    }
  }

  void _load() {
    emit(state.copyWith(
      inputs: memory
          ._loadInputs(state.inputs.where((e) => !e.id.ignoreMemory).map((e) => e.id))
          .followedBy(state.inputs.where((e) => e.id.ignoreMemory)),
      failure: () => memory._loadFailure(identifier),
    ));
  }

  @override
  Future<void> close() async {
    await super.close();

    memory._removeListener(identifier);
  }

  @override
  Input<I> getInput<I>(InputIdentifier<I> id) {
    assert(_debugMemorySet, 'Call initMemory before using the memory');

    final inputCandidates = state.inputs.where((e) => e.id == id);
    assert(inputCandidates.length <= 1, '${inputCandidates.length} with id: $id');

    if (inputCandidates.isNotEmpty) {
      final input = inputCandidates.first;
      assert(input is Input<I>, 'Input found of type ${input.runtimeType} but ${Input<I>} was requested');

      return input as Input<I>;
    } else {
      return memory.getInput<I>(id);
    }
  }

  void sync() {
    assert(_debugMemorySet, 'Call initMemory before using the memory');

    memory.saveAndNotify(identifier, state.inputs, state.failure);
  }
}
