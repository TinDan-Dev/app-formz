import 'package:equatable/equatable.dart';

import 'input/input.dart';
import 'input_container.dart';
import 'utils/extensions.dart';
import 'utils/failure.dart';

class FormState extends Equatable with InputContainer {
  final List<Input> _inputs;
  final Map<String, Object> _properties;
  final Failure? failure;
  final bool submission;

  const FormState(this._inputs, [this._properties = const {}, this.failure, this.submission = false]);

  T getProperty<T extends Object>(String key) {
    assert(_properties.containsKey(key), 'No property found for key: $key');

    return _properties[key]! as T;
  }

  @override
  List<Object?> get props => [submission, failure, ..._inputs, ..._properties.values];

  @override
  Iterable<Input> get inputs => _inputs;

  bool get pure => _inputs.every((e) => e.pure);

  bool get valid => _inputs.every((e) => e.valid || (e.optional && e.pure));

  FormState copyWith({
    Iterable<Input> inputs = const [],
    Map<String, Object> properties = const {},
    bool? submission,
    Failure? failure()?,
  }) {
    assert(
      inputs.every((e) => _inputs.any((o) => o.name == e.name)),
      'Cannot add inputs that where not defined in the constructor',
    );
    assert(
      properties.keys.every((e) => _properties.keys.any((o) => o == e)),
      'Cannot add properties that where not defined in the constructor',
    );

    return FormState(
      [
        for (final input in _inputs) inputs.firstWhere((e) => e.name == input.name, orElse: () => input),
      ],
      {
        for (final key in _properties.keys) key: properties.containsKey(key) ? properties[key]! : _properties[key]!,
      },
      failure.fold(() => this.failure, (some) => some()),
      submission ?? this.submission,
    );
  }
}
