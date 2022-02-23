import 'package:equatable/equatable.dart';

import 'functional/result/result.dart';
import 'input/input.dart';
import 'input_container.dart';
import 'utils/extensions.dart';
import 'utils/lazy.dart';

// TODO: test cirteria

class FormState extends Equatable with InputContainer {
  final List<Input> _inputs;
  final Map<String, Object> _properties;
  final List<bool Function(FormState state)> _criteria;

  final Failure? failure;
  final bool submission;

  late final Lazy<bool> _pure;
  late final Lazy<bool> _valid;

  FormState(
    this._inputs, {
    this.failure,
    this.submission = false,
    Map<String, Object> properties = const {},
    List<bool Function(FormState state)> criteria = const [],
  })  : _properties = properties,
        _criteria = criteria {
    _pure = Lazy(_isPure);
    _valid = Lazy(_isValid);
  }

  T getProperty<T extends Object>(String key) {
    assert(_properties.containsKey(key), 'No property found for key: $key');

    return _properties[key]! as T;
  }

  @override
  List<Object?> get props => [submission, failure, ..._inputs, ..._properties.values];

  @override
  Iterable<Input> get inputs => _inputs;

  bool _isPure() {
    return _inputs.every((e) => e.pure);
  }

  bool _isValid() {
    final inputsValid = _inputs.every((e) => e.valid || (e.optional && e.pure));

    if (inputsValid) {
      return _criteria.every((e) => e(this));
    } else {
      return false;
    }
  }

  bool get pure => _pure.value;

  bool get valid => _valid.value;

  FormState copyWith({
    Iterable<Input> inputs = const [],
    Map<String, Object> properties = const {},
    bool? submission,
    Failure? failure()?,
  }) {
    assert(
      inputs.every((e) => _inputs.any((o) => o.id == e.id)),
      'Cannot add inputs that where not defined in the constructor',
    );
    assert(
      properties.keys.every((e) => _properties.keys.any((o) => o == e)),
      'Cannot add properties that where not defined in the constructor',
    );

    return FormState(
      [
        for (final input in _inputs) inputs.firstWhere((e) => e.id == input.id, orElse: () => input),
      ],
      properties: {
        for (final key in _properties.keys) key: properties.containsKey(key) ? properties[key]! : _properties[key]!,
      },
      criteria: _criteria,
      failure: failure.fold(() => this.failure, (some) => some()),
      submission: submission ?? this.submission,
    );
  }
}
