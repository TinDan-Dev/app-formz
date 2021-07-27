import 'package:flutter_test/flutter_test.dart';
import 'package:formz_test/formz_test.dart';

class TestMemoryFormCubit extends FormCubit with FormMemoryMixin {
  @override
  final FormMemory memory;

  TestMemoryFormCubit({
    required this.memory,
    required FormState state,
  }) : super(state) {
    initMemory();
  }
}

void main() {
  late FormMemory memory;

  final pureInput = GenericTestInput.pure('test', name: 'test');
  final dirtyInput = GenericTestInput.dirty('dirty', name: 'test');

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
    late FormCubit cubit;

    setUp(() {
      cubit = TestMemoryFormCubit(
        memory: memory,
        state: FormState([GenericTestInput.pure('', name: 'test')]),
      );
    });

    test('should not update the cubit when the cubit matches the input type', () {
      final expectation = expectNoEmits(cubit.stream);

      memory.saveAndNotify(TestMemoryFormCubit, [dirtyInput], null);

      return expectation;
    });

    test('should update the cubit when the cubit does not match the input type', () {
      final expectation = expectLater(
        cubit.stream,
        emits(predicate<FormState>((s) => s.getValue<String>('test') == 'dirty')),
      );

      memory.saveAndNotify(String, [dirtyInput], null);

      return expectation;
    });
  });
}
