import 'package:flutter_test/flutter_test.dart';
import 'package:formz_test/formz_test.dart';

InputMatcher wrapInputMatcher(Object? _, Object? matcher) {
  if (matcher == null) {
    return errorMatches(isNull);
  } else {
    return errorMatches(select<CheckBoxInputError>((e) => e.keys, wrapMatcher(matcher)));
  }
}

void main() {
  testInput<CheckBoxInputData?>(
    'test initial input states',
    buildDirty: (input) => CheckBoxInput.dirty(
      input,
      name: 'name',
      pattern: CheckBoxValidationPatter.exactlyOne,
    ),
    buildPure: (input) => CheckBoxInput.pure(
      input,
      name: 'name',
      pattern: CheckBoxValidationPatter.exactlyOne,
    ),
    inputs: {
      null: isEmpty,
      CheckBoxInputData([]): isEmpty,
      CheckBoxInputData(['key']): null,
      CheckBoxInputData(['key1', 'key2']): hasLength(2),
    },
    wrapper: wrapInputMatcher,
  );

  testStateInputMutation<List<Object>>(
    'test update set values',
    pure: CheckBoxInput.pure(
      CheckBoxInputData([]),
      name: 'name',
      pattern: CheckBoxValidationPatter.exactlyOne,
    ),
    mutator: (pure, value) => (pure as CheckBoxInput).update(set: value),
    inputs: {
      ['key']: null,
      ['key1', 'key2']: hasLength(2),
      []: isEmpty,
    },
    wrapper: wrapInputMatcher,
  );

  testStateInputMutation<List<Object>>(
    'test update clear values',
    pure: CheckBoxInput.pure(
      CheckBoxInputData(['key']),
      name: 'name',
      pattern: CheckBoxValidationPatter.exactlyOne,
    ),
    mutator: (pure, value) => (pure as CheckBoxInput).update(clear: value),
    inputs: {
      ['key']: isEmpty,
      ['key1']: null,
      []: null,
    },
    wrapper: wrapInputMatcher,
  );

  testStateInputMutation<List<Object>>(
    'test update toggle values',
    pure: CheckBoxInput.pure(
      CheckBoxInputData(['key1', 'key2']),
      name: 'name',
      pattern: CheckBoxValidationPatter.exactlyOne,
    ),
    mutator: (pure, value) => (pure as CheckBoxInput).update(toggle: value),
    inputs: {
      ['key']: hasLength(3),
      ['key1']: null,
      []: hasLength(2),
      ['key1', 'key2']: isEmpty,
    },
    wrapper: (input, matcher) => errorMatches(select<CheckBoxInputError>((e) => e.keys, wrapMatcher(matcher))),
  );
}
