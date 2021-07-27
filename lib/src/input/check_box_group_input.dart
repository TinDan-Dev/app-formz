import 'dart:math';

import 'package:equatable/equatable.dart';

import '../utils/extensions.dart';
import '../utils/lazy.dart';
import '../widgets/form_input_builder.dart';
import 'input.dart';

// ignore_for_file: avoid_field_initializers_in_const_classes

enum CheckBoxGroupInputError { empty, invalid }

typedef CheckBoxValidationFunc = bool Function(int value, int inputCount);

// TODO: add test and refactor to use an enum or something
class CheckBoxGroupValidationPattern extends Equatable {
  final int inputCount;
  final CheckBoxValidationFunc _validator;

  const CheckBoxGroupValidationPattern.atLeastOne({required this.inputCount})
      : assert(inputCount <= 32),
        _validator = _atLeastOne;

  const CheckBoxGroupValidationPattern.exactlyOne({required this.inputCount})
      : assert(inputCount <= 32),
        _validator = _exactlyOne;

  static bool _atLeastOne(int value, int inputCount) => value > 0 && value < pow(2, inputCount);

  static bool _exactlyOne(int value, int inputCount) => (value & (value - 1)) == 0 && value < pow(2, inputCount);

  @override
  List<Object?> get props => [inputCount, _validator];
}

int _updateInt(int status, {int toSet = 0, int toClear = 0}) {
  return (status | toSet) & (~toClear);
}

class CheckBoxGroupInput extends Input<int, CheckBoxGroupInputError> {
  final CheckBoxGroupValidationPattern pattern;

  late Lazy<List<int>> _lazySelectedIndices;

  // TODO: add tests
  List<int> get selectedIndices => _lazySelectedIndices.value;

  CheckBoxGroupInput.pure(
    int? value, {
    required String name,
    required this.pattern,
  }) : super.pure(value, name) {
    _initLazy();
  }

  CheckBoxGroupInput.dirty(
    int? value, {
    required String name,
    required this.pattern,
  }) : super.dirty(value, name) {
    _initLazy();
  }

  void _initLazy() => _lazySelectedIndices = Lazy(() => _selectedIndices().toList());

  @override
  CheckBoxGroupInputError? validate(int? input) {
    // if the input is null or 0 then the input is considered empty
    if (input == null || input == 0) return CheckBoxGroupInputError.empty;

    if (!pattern._validator(input, pattern.inputCount)) return CheckBoxGroupInputError.invalid;

    return null;
  }

  // toSet: the numbers of the inputs to set to true
  // toClear: the numbers of the inputs to set to false
  CheckBoxGroupInput update({
    List<int> toSet = const [],
    List<int> toClear = const [],
  }) {
    final toSetInt = toSet.where((i) => i < pattern.inputCount).map((i) => 1 << i).fold<int>(0, (a, b) => a + b);
    final toClearInt = toClear.where((i) => i < pattern.inputCount).map((i) => 1 << i).fold<int>(0, (a, b) => a + b);

    final newValue = _updateInt(value ?? 0, toSet: toSetInt, toClear: toClearInt);

    return copyWith(value: newValue) as CheckBoxGroupInput;
  }

  Iterable<int> _selectedIndices() sync* {
    final value = this.value ?? 0;
    if (value <= 0) return;

    for (int i = 0; i < 32; i++) {
      if (value & (1 << i) > 0) yield i;
    }
  }

  @override
  Input<int, CheckBoxGroupInputError> copyWith({
    required int? value,
    bool pure = false,
  }) {
    if (pure)
      return CheckBoxGroupInput.pure(
        value,
        name: name,
        pattern: pattern,
      );
    else
      return CheckBoxGroupInput.dirty(
        value,
        name: name,
        pattern: pattern,
      );
  }

  bool getButtonValue(int index) {
    assert(index < pattern.inputCount);

    return _getButtonValue(value ?? 0, index);
  }
}

bool _getButtonValue(int state, int index) => state & (1 << index) > 0;

extension CheckBoxGroupInputMetaExtension on FormInputState<int> {
  bool getButtonValue(int index) => _getButtonValue(value.or(0), index);
}
