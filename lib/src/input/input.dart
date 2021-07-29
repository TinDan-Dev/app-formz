import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../utils/lazy.dart';

// Using lazy validation to improve performance, thus this class is still immutable but the validation function is only called
// once. The mixin is used to avoid immutable warnings.
abstract class Input<T, E> with EquatableMixin {
  final bool _pure;
  final T? value;
  final String name;

  late final Lazy<E?> _validate;

  Input._({
    required this.value,
    required bool pure,
    required this.name,
  }) : _pure = pure {
    _validate = Lazy(() => validate(value));
  }

  Input.pure(T? value, String name)
      : this._(
          value: value,
          pure: true,
          name: name,
        );

  Input.dirty(T? value, String name)
      : this._(
          value: value,
          pure: false,
          name: name,
        );

  @protected
  E? validate(T? input);

  Input<T, E> copyWith({required T? value, bool pure = false});

  Input<T, E> pureCopy() => copyWith(value: value, pure: true);

  E? get error => pure ? null : _validate.value;

  bool get valid => _validate.value == null;

  bool get optional => false;

  bool get pure => _pure;

  @override
  // uses the final pure to ensure the equality does not change
  List<Object?> get props => [_pure, value, name];

  @override
  String toString() {
    return '$runtimeType: { value: $value, valid: $valid, pure: $pure, error: $error}';
  }
}

mixin OptionalInputMixin<T, E> on Input<T, E> {
  @protected
  bool isPure(T? input);

  @override
  bool get pure => super.pure || isPure(value);

  @override
  bool get optional => true;
}
