import 'package:equatable/equatable.dart';

import 'input/input.dart';
import 'input_container.dart';
import 'utils/extensions.dart';
import 'utils/failure.dart';

class FormState extends Equatable with InputContainer {
  final List<Input> _inputs;
  final Failure? failure;
  final bool submission;

  const FormState(this._inputs, [this.failure, this.submission = false]);

  @override
  List<Object?> get props => [submission, failure, ..._inputs];

  @override
  Iterable<Input> get inputs => _inputs;

  bool get pure => _inputs.every((e) => e.pure);

  bool get valid => _inputs.every((e) => e.valid || (e.optional && e.pure));

  FormState copyWith({
    Iterable<Input> inputs = const [],
    bool? submission,
    Failure? failure()?,
  }) {
    assert(
      inputs.every((e) => _inputs.any((o) => o.name == e.name)),
      'Cannot add inputs that where not defined in the constructor',
    );

    return FormState(
      [
        for (final input in _inputs) inputs.firstWhere((e) => e.name == input.name, orElse: () => input),
      ],
      failure.fold(() => this.failure, (some) => some()),
      submission ?? this.submission,
    );
  }
}
