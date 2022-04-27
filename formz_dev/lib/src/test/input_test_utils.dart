import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';

import 'input_matcher.dart';

InputMatcher wrapFailure(Object? _, Object? matcher) => failureMatches(matcher);

InputMatcher wrapValue(Object? _, Object? matcher) => valueMatches(matcher);

InputMatcher wrapValid(Object? _, Object? matcher) => validMatches(matcher);

InputMatcher wrapPure(Object? _, Object? matcher) => pureMatches(matcher);

typedef InputWrapper<T> = InputMatcher Function(T input, Object? matcher);

Map<T, InputMatcher> _inputToMatcher<T>(
  Map<T?, Object?> inputs,
  InputWrapper<T> wrapper,
) {
  return Map.fromIterable(
    inputs.keys,
    key: (key) => key,
    value: (key) {
      final value = inputs[key];
      if (value is InputMatcher)
        return value;
      else
        return wrapper(key, value);
    },
  );
}

void testInput<T>(
  String description, {
  required Input Function(T input) buildDirty,
  required Input Function(T input) buildPure,
  required Map<T, Object?> inputs,
  InputWrapper<T> wrapper = wrapFailure,
}) {
  final matchers = _inputToMatcher(inputs, wrapper);

  group(description, () {
    group('pure constructor', () {
      for (final io in matchers.entries) {
        test('when input: ${io.key}, state should be: ${io.value}', () {
          final result = buildPure(io.key);

          expect(
            result,
            io.value.ignoreError(),
            reason: 'expected the result to match the description',
          );
          expect(
            result.failure,
            isNull,
            reason: 'expected error to be none',
          );
          expect(
            result.pure,
            isTrue,
            reason: 'expected input to be pure',
          );
        });
      }
    });

    group('dirty constructor', () {
      for (final io in matchers.entries) {
        test('when input: ${io.key}, state should be: ${io.value}', () {
          final result = buildDirty(io.key);

          expect(
            result,
            io.value,
            reason: 'expected the result to match the description',
          );
          if (!result.optional) {
            expect(
              result.pure,
              isFalse,
              reason: 'expected input to be dirty',
            );
          }
        });
      }
    });
  });
}

void testStateInputMutation<T>(
  String description, {
  required Input pure,
  required Input Function(Input pure, T input) mutator,
  required Map<T, Object?> inputs,
  InputWrapper<T> wrapper = wrapValue,
}) {
  group(description, () {
    final matchers = _inputToMatcher(inputs, wrapper);

    for (final io in matchers.entries) {
      test('when input: ${io.key}, state should be: ${io.value}', () {
        final result = mutator(pure, io.key);

        expect(
          result,
          io.value.ignoreError(),
          reason: 'expected the result to match the description',
        );
      });
    }
  });
}
