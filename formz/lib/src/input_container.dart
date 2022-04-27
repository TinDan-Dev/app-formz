import 'package:meta/meta.dart';

import 'input/input.dart';

mixin InputContainer {
  Iterable<Input> get inputs;

  Input<T> getInput<T>(InputIdentifier<T> id) {
    final inputCandidates = inputs.where((e) => e.id == id);
    assert(inputCandidates.length == 1, '${inputCandidates.length} Inputs with id: $id');

    final input = inputCandidates.first;
    assert(input is Input<T>, '${input.id.toString()} requested but ${input.runtimeType} was found');

    return input as Input<T>;
  }

  T getValue<T>(InputIdentifier<T> id) {
    final input = getInput<T>(id);

    return input.value;
  }
}

mixin MutableInputContainer on InputContainer {
  @protected
  void replaceInput(Input input);

  void setInput<T>(
    T value, {
    required InputIdentifier<T> id,
    bool pure = false,
  }) {
    assert(id.checkType(value), 'Value ($value) is not assignable to the input $id');

    final input = getInput<T>(id);
    final result = input.copyWith(value: value, pure: pure);

    replaceInput(result);
  }

  void mutateInput<T>(
    T mutate(T value), {
    required InputIdentifier<T> id,
    bool pure = false,
  }) {
    final input = getInput<T>(id);
    final result = input.copyWith(value: mutate(input.value), pure: pure);

    replaceInput(result);
  }

  @protected
  @visibleForTesting
  void updateInput<T>({
    required Input<T> update(Input<T> input),
    required InputIdentifier<T> id,
  }) {
    final input = getInput<T>(id);
    final result = update(input);

    assert(result.id == id, 'The id of the input is not allowed to change');

    replaceInput(result);
  }
}
