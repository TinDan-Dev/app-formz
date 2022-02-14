import 'package:equatable/equatable.dart';

import '../functional/either/either.dart';
import '../functional/result/result.dart';
import '../utils/lazy.dart';

typedef ValidationDelegate<T> = Result<void> Function(T? input);

// Using lazy validation to improve performance, thus this class is still immutable but the validation function is only called
// once. The mixin is used to avoid immutable warnings.
class Input<T> extends Equatable {
  final ValidationDelegate<T> delegate;

  final bool _pure;
  final T? value;
  final String name;

  final Lazy<Result<void>> _validate;

  Input._(
    this.delegate, {
    required this.value,
    required bool pure,
    required this.name,
  })  : _pure = pure,
        _validate = Lazy(() => delegate(value));

  Input.create(
    ValidationDelegate<T> delegate, {
    required String name,
    T? value,
    bool pure = true,
  }) : this._(delegate, value: value, pure: pure, name: name);

  Input<T> copyWith({required T? value, bool pure = false}) => Input._(
        delegate,
        value: value,
        pure: pure,
        name: name,
      );

  Failure? get failure => pure ? null : _validate.value.leftOrNull();

  bool get valid => _validate.value.right;

  bool get optional => false;

  bool get pure => _pure;

  @override
  // uses the final pure to ensure the equality does not change
  List<Object?> get props => [_pure, value, name];

  @override
  String toString() {
    return '$runtimeType: { value: $value, valid: $valid, pure: $pure, failure: $failure}';
  }
}

typedef PureDelegate<T> = bool Function(T? input);

class OptionalInput<T> extends Input<T> {
  final PureDelegate<T?> pureDelegate;

  OptionalInput.create(
    ValidationDelegate<T> delegate, {
    required this.pureDelegate,
    required String name,
    T? value,
    bool pure = true,
  }) : super._(delegate, value: value, pure: pure, name: name);

  @override
  bool get pure => super.pure || pureDelegate(value);

  @override
  bool get optional => true;
}
