import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:formz_dev/formz_test.dart';

class TestMemoryFormCubit extends FormCubit with FormMemoryMixin {
  @override
  final String identifier = 'cubit';

  TestMemoryFormCubit({
    required FormState state,
  }) : super(state);
}

void main() {
  late FormMemory memory;

  final pureInput = createTestInput('test', pure: true);
  final dirtyInput = createTestInput('dirty', pure: true);

  setUp(() {
    memory = FormMemory();
  });

  group('save', () {
    test('should add the input when the the input was not already registered', () {
      memory.save(pureInput);

      expect(memory.inputs, contains(pureInput));
    });

    test('should override the old input when the the input was already registered', () {
      memory.save(pureInput);
      memory.save(dirtyInput);

      expect(memory.inputs, isNot(contains(pureInput)));
      expect(memory.inputs, contains(dirtyInput));
    });
  });

  group('saveAndNotify', () {
    late TestMemoryFormCubit cubit;

    setUp(() {
      cubit = TestMemoryFormCubit(
        state: FormState([createTestInput('')]),
      )..initMemory(memory);
    });

    test('should not update the cubit when the cubit matches the identifier', () {
      final expectation = expectNoEmits(cubit.stream);

      memory.saveAndNotify(cubit.identifier, [dirtyInput], null);

      return expectation;
    });

    test('should update the cubit when the cubit does not match the input type', () {
      final expectation = expectLater(
        cubit.stream,
        emits(predicate<FormState>((s) => s.getValue<String>(testInputId) == 'dirty')),
      );

      memory.saveAndNotify(String, [dirtyInput], null);

      return expectation;
    });

    test('should update the cubit when the cubit does not match the identifier', () {
      final expectation = expectLater(cubit.stream, emits(anything));

      memory.saveAndNotify('x', [dirtyInput], null);

      return expectation;
    });
  });
}
