import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/extensions.dart';
import 'input.dart';

enum CheckBoxValidationPatter { always, atLeastOne, exactlyOne }

class CheckBoxInputError extends Equatable {
  final List<Object> _keys;
  final CheckBoxValidationPatter pattern;

  CheckBoxInputError(this._keys, this.pattern);

  List<Object> get keys => UnmodifiableListView(_keys);

  @override
  List<Object?> get props => [..._keys, pattern];

  bool operator [](Object key) => _keys.contains(key);
}

class CheckBoxInputData extends Equatable {
  final List<Object> _keys;

  const CheckBoxInputData(this._keys);

  @override
  List<Object?> get props => _keys;

  bool valid(CheckBoxValidationPatter pattern) {
    switch (pattern) {
      case CheckBoxValidationPatter.always:
        return true;
      case CheckBoxValidationPatter.atLeastOne:
        return _keys.length > 0;
      case CheckBoxValidationPatter.exactlyOne:
        return _keys.length == 1;
    }
  }

  bool operator [](Object key) => _keys.contains(key);
}

class CheckBoxInput extends Input<CheckBoxInputData, CheckBoxInputError> {
  final CheckBoxValidationPatter pattern;

  CheckBoxInput.pure(
    CheckBoxInputData? value, {
    required String name,
    required this.pattern,
  }) : super.pure(value, name);

  CheckBoxInput.dirty(
    CheckBoxInputData? value, {
    required String name,
    required this.pattern,
  }) : super.dirty(value, name);

  @override
  Input<CheckBoxInputData, CheckBoxInputError> copyWith({required CheckBoxInputData? value, bool pure = false}) {
    if (pure)
      return CheckBoxInput.pure(value, name: name, pattern: pattern);
    else
      return CheckBoxInput.dirty(value, name: name, pattern: pattern);
  }

  @override
  CheckBoxInputError? validate(CheckBoxInputData? input) {
    if (input != null) {
      if (!input.valid(pattern))
        return CheckBoxInputError(input._keys, pattern);
      else
        return null;
    }

    if (pattern != CheckBoxValidationPatter.always)
      return CheckBoxInputError([], pattern);
    else
      return null;
  }

  Input<CheckBoxInputData, CheckBoxInputError> update({
    List<Object> set = const [],
    List<Object> clear = const [],
    List<Object> toggle = const [],
  }) {
    return value.fold(
      () => CheckBoxInput.dirty(CheckBoxInputData(set + toggle), name: name, pattern: pattern),
      (some) {
        final clearList = [...clear];
        final setList = [...set];

        for (final key in toggle) {
          if (some[key])
            clearList.add(key);
          else
            setList.add(key);
        }

        for (final key in some._keys) {
          if (!clearList.contains(key)) setList.add(key);
        }

        return CheckBoxInput.dirty(CheckBoxInputData(setList), name: name, pattern: pattern);
      },
    );
  }

  bool operator [](Object key) => value?[key] ?? false;
}

extension NullableCheckboxInputData on CheckBoxInputData? {
  bool operator [](Object key) => this?[key] ?? false;
}
