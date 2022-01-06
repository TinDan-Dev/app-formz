import 'package:meta/meta.dart';

import 'input/input.dart';

mixin InputContainer {
  Iterable<Input> get inputs;

  T getInput<T extends Input>(String name) {
    final inputCandidates = inputs.where((e) => e.name == name);
    assert(inputCandidates.length == 1, '${inputCandidates.length} with name: $name');

    final input = inputCandidates.first;
    assert(input is T, 'Input found of type ${input.runtimeType} but $T was requested');

    return input as T;
  }

  T getValue<T>(String name) {
    final input = getInput(name);
    assert(input.value is T, 'Input has value of type ${input.value.runtimeType} but $T was requested');

    return input.value as T;
  }
}

mixin MutableInputContainer on InputContainer {
  @protected
  void replaceInput(Input input);

  void setInput<T extends Input>(
    dynamic value, {
    required String name,
    bool pure = false,
  }) {
    final input = getInput<T>(name);
    final result = input.copyWith(value: value, pure: pure);

    assert(
      result.runtimeType == input.runtimeType,
      'The input $name was ${input.runtimeType} but after the mutation it was ${result.runtimeType}',
    );
    replaceInput(result);
  }

  void mutateInput<T>(
    T mutate(T? value), {
    required String name,
    bool pure = false,
  }) {
    final input = getInput<Input<T, dynamic>>(name);
    final result = input.copyWith(value: mutate(input.value), pure: pure);

    assert(
      result.runtimeType == input.runtimeType,
      'The input $name was ${input.runtimeType} but after the mutation it was ${result.runtimeType}',
    );
    replaceInput(result);
  }

  @protected
  @visibleForTesting
  void updateInput<T extends Input>({
    required Input update(T input),
    required String name,
  }) {
    final input = getInput<T>(name);
    final result = update(input);

    assert(
      result.runtimeType == input.runtimeType,
      'The input $name was ${input.runtimeType} but after the mutation it was ${result.runtimeType}',
    );
    replaceInput(result);
  }
}
