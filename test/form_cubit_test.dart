import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz_test/formz_test.dart';

class TestMemoryFormCubit extends FormCubit with FormMemoryMixin {
  @override
  final FormMemory memory;

  @override
  final String identifier = 'cubit';

  TestMemoryFormCubit({required this.memory, required FormState state}) : super(state) {
    initMemory();
  }
}

void main() {
  final input = GenericTestInput.dirty('value', name: 'test');
  final input2 = GenericTestInput.pure('value2', name: 'test2');

  late FormMemory memory;
  late FormCubit cubit;

  setUp(() {
    memory = FormMemory();
    memory.save(input);
    memory.save(input2);

    cubit = TestMemoryFormCubit(
      memory: memory,
      state: FormState([GenericTestInput.pure('', name: 'test')]),
    );
  });

  group('with memory', () {
    test('should add all inputs from the memory to the state when no filter is passed in', () {
      final cubit = TestMemoryFormCubit(
        memory: memory,
        state: FormState([GenericTestInput.pure('', name: 'test')]),
      );
      final result = cubit.state.getInput(input.name);

      expect(result.value, equals(input.value));
    });
  });

  group('on memory update', () {
    blocTest<FormCubit, FormState>(
      'should update the state when the memory receives a update',
      build: () => cubit,
      act: (_) => memory.saveAndNotify(String, [GenericTestInput.dirty('new value', name: 'test')], null),
      expect: () => [isA<FormState>()],
      verify: (cubit) => expect(
        cubit.state.getInput(input.name).value,
        equals('new value'),
      ),
    );

    blocTest<FormCubit, FormState>(
      'should ignore the memory update when it updates itself',
      build: () => cubit,
      act: (cubit) => cubit.setInput('new value', name: 'test'),
      expect: () => [isA<FormState>()],
      verify: (cubit) => expect(
        cubit.state.getInput(input.name).value,
        equals('new value'),
      ),
    );
  });

  group('setInput', () {
    blocTest<FormCubit, FormState>(
      'should emit a new state with the updated input',
      build: () => cubit,
      act: (cubit) => cubit.setInput('new value', name: 'test'),
      expect: () => [isA<FormState>()],
      verify: (cubit) => expect(
        cubit.state.getInput(input.name).value,
        equals('new value'),
      ),
    );

    test('should throw an error when the input is not tracked', () {
      expect(
        () => cubit.setInput('new value', name: 'unknown'),
        throwsA(isAssertionError),
      );
    });

    test('should throw an error when the input has a different type then the old one', () {
      expect(
        () => cubit.setInput(1, name: 'unknown'),
        throwsA(isAssertionError),
      );
    });
  });

  group('updateInput', () {
    blocTest<FormCubit, FormState>(
      'should emit a new state with the updated input',
      build: () => cubit,
      act: (cubit) => cubit.updateInput<GenericTestInput>(
        update: (input) => input.copyWith(value: 'new value'),
        name: 'test',
      ),
      expect: () => [isA<FormState>()],
      verify: (cubit) => expect(
        cubit.state.getInput(input.name).value,
        equals('new value'),
      ),
    );

    test('should throw an error when the input is not tracked', () {
      expect(
        () => cubit.updateInput<GenericTestInput>(
          update: (input) => input.copyWith(value: 'new value'),
          name: 'unknown',
        ),
        throwsA(isAssertionError),
      );
    });

    test('should throw an error when the generic type does not match', () {
      expect(
        () => cubit.updateInput<CheckBoxInput>(
          update: (input) => input.copyWith(value: CheckBoxInputData([])),
          name: 'unknown',
        ),
        throwsA(isAssertionError),
      );
    });

    test('should throw an error when return type is different', () {
      expect(
        () => cubit.updateInput<Input>(
          update: (input) => CheckBoxInput.dirty(
            CheckBoxInputData(['key']),
            name: 'test',
            pattern: CheckBoxValidationPatter.atLeastOne,
          ),
          name: 'test',
        ),
        throwsA(isAssertionError),
      );
    });
  });

  group('getValue', () {
    test('should return the value from the requested input', () {
      final result = cubit.getValue('test');
      expect(result, equals('value'));
    });

    test('should throw an error when the requested input is not tracked', () {
      expect(
        () => cubit.getValue('unknown'),
        throwsA(isAssertionError),
      );
    });

    test('should throw an error when a different type was expected', () {
      expect(
        () => cubit.getValue<int>('test'),
        throwsA(isAssertionError),
      );
    });

    group('include memory', () {
      test('should return the value from the requested input when it is currently not tracked, but in the memory', () {
        final result = cubit.getValue('test2');
        expect(result, equals('value2'));
      });

      test('should return the value from the requested input, if it is found', () {
        final result = cubit.getValue('test');
        expect(result, equals('value'));
      });

      test('should throw an error when the requested input is not tracked', () {
        expect(
          () => cubit.getValue('unknown'),
          throwsA(isAssertionError),
        );
      });

      test('should throw an error when a different type was expected', () {
        expect(
          () => cubit.getValue<int>('test2'),
          throwsA(isAssertionError),
        );
      });
    });
  });
}
