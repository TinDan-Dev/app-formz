import 'package:flutter_test/flutter_test.dart';
import 'package:formz_test/formz_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'form_state_test.mocks.dart';

@GenerateMocks([], customMocks: [MockSpec<Input<String, String>>(as: #MockInputState)])
void main() {
  late MockInputState pureInputState;
  late MockInputState invalidInputState;
  late MockInputState validInputState;

  setUp(() {
    pureInputState = MockInputState();
    invalidInputState = MockInputState();
    validInputState = MockInputState();

    when(pureInputState.name).thenReturn('test');
    when(pureInputState.value).thenReturn('');
    when(pureInputState.pure).thenReturn(true);
    when(pureInputState.valid).thenReturn(false);
    when(pureInputState.optional).thenReturn(false);
    when(pureInputState.pureCopy()).thenReturn(pureInputState);

    when(invalidInputState.name).thenReturn('test');
    when(invalidInputState.pure).thenReturn(false);
    when(invalidInputState.valid).thenReturn(false);
    when(invalidInputState.optional).thenReturn(false);
    when(invalidInputState.pureCopy()).thenReturn(pureInputState);

    when(validInputState.name).thenReturn('test');
    when(validInputState.pure).thenReturn(false);
    when(validInputState.valid).thenReturn(true);
    when(validInputState.optional).thenReturn(false);
    when(validInputState.pureCopy()).thenReturn(pureInputState);
  });
  group('getInput', () {
    test('should return the InputState when a input with the name was added', () {
      final state = FormState([pureInputState]);

      expect(state.getInput('test'), equals(pureInputState));
    });

    test('should throw an exception when no input with the name was added', () {
      final state = FormState([pureInputState]);

      expect(() => state.getInput('no'), throwsA(anything));
    });
  });

  group('getValue', () {
    test('should return the value if the InputState when a input with the name was added', () {
      when(pureInputState.value).thenReturn('testValue');

      final state = FormState([pureInputState]);

      expect(state.getInput('test').value, equals('testValue'));
    });

    test('should throw an exception when no input with the name was added', () {
      final state = FormState([pureInputState]);

      expect(() => state.getInput('no').value, throwsA(anything));
    });
  });

  group('copyWith', () {
    test('should return an equal copy when no parameters are passed', () {
      final state = FormState([pureInputState]);

      final result = state.copyWith();

      expect(result, equals(state));
    });

    test('should return a copy with new state when a state with name was added', () {
      final state = FormState([pureInputState]);

      final result = state.copyWith(inputs: [invalidInputState]);

      expect(
        result.getInput(invalidInputState.name),
        equals(invalidInputState),
      );
    });

    test('should throw a exception when a state should be updated but no state with this name was added', () {
      when(invalidInputState.name).thenReturn('no');

      final state = FormState([pureInputState]);

      expect(
        () => state.copyWith(inputs: [invalidInputState]),
        throwsA(anything),
      );
    });

    test('should update the status according to the new inputStates when no status but new states are passed in', () {
      final state = FormState([pureInputState]);

      final result = state.copyWith(inputs: [invalidInputState]);

      expect(state.pure, isTrue);

      expect(result.valid, isFalse);
      expect(result.pure, isFalse);
    });

    test('should update the failure when a failure was passed in', () {
      final state = FormState([pureInputState]);

      final result = state.copyWith(failure: () => const FakeFailure());

      expect(result.failure, isNotNull);
    });
  });

  group('status', () {
    const list = [
      // pure, pure, not optional
      [
        [true, true, false],
        [true, true, false],
        [true, true],
      ],
      [
        [true, false, false],
        [true, true, false],
        [true, false],
      ],
      [
        [true, false, false],
        [true, false, false],
        [true, false],
      ],
      // not pure, pure, not optional
      [
        [false, true, false],
        [true, true, false],
        [false, true],
      ],
      [
        [false, false, false],
        [true, true, false],
        [false, false],
      ],
      [
        [false, false, false],
        [true, false, false],
        [false, false],
      ],
      // not pure, not pure, not optional
      [
        [false, true, false],
        [false, true, false],
        [false, true],
      ],
      [
        [false, false, false],
        [false, true, false],
        [false, false],
      ],
      [
        [false, false, false],
        [false, false, false],
        [false, false],
      ],
      // pure, pure, optional
      [
        [true, true, true],
        [true, true, true],
        [true, true],
      ],
      [
        [true, false, true],
        [true, true, true],
        [true, true],
      ],
      [
        [true, false, true],
        [true, false, true],
        [true, true],
      ],
      // not pure, pure, optional
      [
        [false, true, true],
        [true, true, true],
        [false, true],
      ],
      [
        [false, false, true],
        [true, true, true],
        [false, false],
      ],
      [
        [false, false, true],
        [true, false, true],
        [false, false],
      ],
      // not pure, not pure, optional
      [
        [false, true, true],
        [false, true, true],
        [false, true],
      ],
      [
        [false, false, true],
        [false, true, true],
        [false, false],
      ],
      [
        [false, false, true],
        [false, false, true],
        [false, false],
      ],
    ];

    test('should change state according to list', () {
      for (final test in list) {
        final input1 = MockInputState();
        final input2 = MockInputState();

        when(input1.name).thenReturn('1');
        when(input2.name).thenReturn('2');
        when(input1.pure).thenReturn(test[0][0]);
        when(input2.pure).thenReturn(test[1][0]);
        when(input1.valid).thenReturn(test[0][1]);
        when(input2.valid).thenReturn(test[1][1]);
        when(input1.optional).thenReturn(test[0][2]);
        when(input2.optional).thenReturn(test[1][2]);

        final state = FormState([input1, input2]);

        expect(
          state.pure,
          equals(test[2][0]),
          reason: '''
Input: (pure: ${input1.pure}, valid: ${input1.valid}, optional: ${input1.optional})
Input: (pure: ${input2.pure}, valid: ${input2.valid}, optional: ${input2.optional})
State should be pure: ${test[2][0]}
''',
        );
        expect(
          state.valid,
          equals(test[2][1]),
          reason: '''
Input: (pure: ${input1.pure}, valid: ${input1.valid}, optional: ${input1.optional})
Input: (pure: ${input2.pure}, valid: ${input2.valid}, optional: ${input2.optional})
State should be valid: ${test[2][1]}
''',
        );
      }
    });
  });
}
