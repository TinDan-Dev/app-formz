import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz_test/formz_test.dart';

class TestMemoryFormCubit extends FormCubit with FormMemoryMixin {
  @override
  final String identifier = 'cubit';

  TestMemoryFormCubit({required FormState state}) : super(state);
}

void main() {
  const inputId1 = InputIdentifier<String>.named('1');
  const inputId2 = InputIdentifier<String>.named('2');

  final input1 = createInput<String>((_) => true, id: inputId1, value: '1', pure: true);
  final input2 = createInput<String>((_) => true, id: inputId2, value: '2', pure: false);

  late FormMemory memory;
  late FormCubit cubit;

  setUp(() {
    memory = FormMemory();
    memory.save(input1);
    memory.save(input2);

    cubit = TestMemoryFormCubit(
      state: FormState([createInput<String>((v) => true, id: inputId1, value: '')]),
    )..initMemory(memory);
  });

  group('with memory', () {
    test('should add all inputs from the memory to the state when no filter is passed in', () {
      final cubit = TestMemoryFormCubit(
        state: FormState([createInput<String>((v) => true, id: inputId1, value: '')]),
      )..initMemory(memory);
      final result = cubit.state.getInput(inputId1);

      expect(result.value, equals(input1.value));
    });
  });

  group('on memory update', () {
    blocTest<FormCubit, FormState>(
      'should update the state when the memory receives a update',
      build: () => cubit,
      act: (_) =>
          memory.saveAndNotify(String, [createInput<String>((v) => true, id: inputId1, value: '3', pure: false)], null),
      expect: () => [isA<FormState>()],
      verify: (cubit) => expect(
        cubit.state.getInput(inputId1).value,
        equals('3'),
      ),
    );

    blocTest<FormCubit, FormState>(
      'should ignore the memory update when it updates itself',
      build: () => cubit,
      act: (cubit) => cubit.setInput('3', id: inputId1),
      expect: () => [isA<FormState>()],
      verify: (cubit) => expect(
        cubit.state.getInput(inputId1).value,
        equals('3'),
      ),
    );
  });

  group('setInput', () {
    blocTest<FormCubit, FormState>(
      'should emit a new state with the updated input',
      build: () => cubit,
      act: (cubit) => cubit.setInput('3', id: inputId1),
      expect: () => [isA<FormState>()],
      verify: (cubit) => expect(
        cubit.state.getInput(inputId1).value,
        equals('3'),
      ),
    );

    test('should throw an error when the input is not tracked', () {
      expect(
        () => cubit.setInput('3', id: const InputIdentifier.named('3')),
        throwsA(isAssertionError),
      );
    });

    test('should throw an error when the input has a different type then the old one', () {
      expect(
        () => cubit.setInput(1, id: inputId1),
        throwsA(isAssertionError),
      );
    });
  });

  group('updateInput', () {
    blocTest<FormCubit, FormState>(
      'should emit a new state with the updated input',
      build: () => cubit,
      act: (cubit) => cubit.updateInput<String>(
        update: (input) => input.copyWith(value: '3'),
        id: inputId1,
      ),
      expect: () => [isA<FormState>()],
      verify: (cubit) => expect(
        cubit.state.getInput(inputId1).value,
        equals('3'),
      ),
    );

    test('should throw an error when the input is not tracked', () {
      expect(
        () => cubit.updateInput<String>(
          update: (input) => input.copyWith(value: '3'),
          id: const InputIdentifier.named('3'),
        ),
        throwsA(isAssertionError),
      );
    });

    test('should throw an error when return type is different', () {
      expect(
        () => cubit.updateInput(
          update: (input) => createInput<int>((_) => true, id: const InputIdentifier.named('3'), value: 3),
          id: inputId1,
        ),
        throwsA(isAssertionError),
      );
    });
  });

  group('getValue', () {
    test('should return the value from the requested input', () {
      final result = cubit.getValue(inputId1);
      expect(result, equals(input1.value));
    });

    test('should throw an error when the requested input is not tracked', () {
      expect(
        () => cubit.getValue(const InputIdentifier.named('3')),
        throwsA(isAssertionError),
      );
    });

    group('include memory', () {
      test('should return the value from the requested input when it is currently not tracked, but in the memory', () {
        final result = cubit.getValue(inputId2);
        expect(result, equals(input2.value));
      });

      test('should return the value from the requested input, if it is found', () {
        final result = cubit.getValue(inputId1);
        expect(result, equals(input1.value));
      });

      test('should throw an error when the requested input is not tracked', () {
        expect(
          () => cubit.getValue(const InputIdentifier.named('3')),
          throwsA(isAssertionError),
        );
      });
    });
  });
}
