import 'package:flutter_test/flutter_test.dart';
import 'package:formz_test/formz_test.dart';

void main() {
  testInput<int?>(
    'test initial input states',
    buildDirty: (input) => CheckBoxGroupInput.dirty(
      input,
      name: 'name',
      pattern: const CheckBoxGroupValidationPattern.exactlyOne(inputCount: 8),
    ),
    buildPure: (input) => CheckBoxGroupInput.pure(
      input,
      name: 'name',
      pattern: const CheckBoxGroupValidationPattern.exactlyOne(inputCount: 8),
    ),
    inputs: {
      null: CheckBoxGroupInputError.empty,
      0: CheckBoxGroupInputError.empty,
      3: CheckBoxGroupInputError.invalid,
      11: CheckBoxGroupInputError.invalid,
      for (int i = 0; i < 8; i++) 1 << i: null,
      for (int i = 8; i < 12; i++) 1 << i: CheckBoxGroupInputError.invalid,
    },
  );

  bool shouldError(Object i) {
    if (i is List<int>) {
      if (i.isEmpty || i.length > 1) return true;
      return i[0] >= 8;
    }
    return true;
  }

  testStateInputMutation<List<int>>(
    'test update set values',
    pure: CheckBoxGroupInput.pure(
      0,
      name: 'name',
      pattern: const CheckBoxGroupValidationPattern.exactlyOne(inputCount: 8),
    ),
    mutator: (pure, value) => (pure as CheckBoxGroupInput).update(toSet: value),
    inputs: {
      for (int i = 0; i < 8; i++) [i]: 1 << i,
      for (int i = 8; i < 12; i++) [i]: 0,
      [1, 3]: (1 << 1) + (1 << 3),
      [5, 6, 4]: (1 << 5) + (1 << 6) + (1 << 4),
    },
    wrapper: (input, matcher) => inputMatches(
      error: shouldError(input) ? isNotNull : isNull,
      value: matcher,
    ),
  );

  testStateInputMutation<List<int>>(
    'test update clear values',
    pure: CheckBoxGroupInput.pure(
      0xff,
      name: 'name',
      pattern: const CheckBoxGroupValidationPattern.exactlyOne(inputCount: 8),
    ),
    mutator: (pure, value) => (pure as CheckBoxGroupInput).update(toClear: value),
    inputs: {
      for (int i = 0; i < 8; i++) [i]: 0xff & ~(1 << i),
      for (int i = 8; i < 12; i++) [i]: 0xff,
      [1, 3]: 0xff & ~((1 << 1) + (1 << 3)),
      [5, 6, 4]: 0xff & ~((1 << 5) + (1 << 6) + (1 << 4)),
    },
  );
}
