import 'package:equatable/equatable.dart';

import '../functional/either/either.dart';
import '../functional/result/result.dart';
import '../utils/lazy.dart';

part 'input_identifier.dart';

typedef ValidationDelegate<T> = Result<void> Function(T input);

// Using lazy validation to improve performance, thus this class is still immutable but the validation function is only called
// once. The mixin is used to avoid immutable warnings.
class Input<T> extends Equatable implements Result<void> {
  final ValidationDelegate<T> delegate;

  final bool _pure;
  final T value;
  final InputIdentifier<T> id;

  final Lazy<Result<void>> _validate;

  Input(
    this.delegate, {
    required this.value,
    required this.id,
    required bool pure,
  })  : _pure = pure,
        _validate = Lazy(() => delegate(value));

  Input<T> copyWith({required T value, bool pure = false}) => Input<T>(
        delegate,
        value: value,
        pure: pure,
        id: id,
      );

  Failure? get failure => pure ? null : _validate.value.leftOrNull();

  bool get valid => _validate.value.right;

  bool get optional => false;

  bool get pure => _pure;

  @override
  // uses the final pure to ensure the equality does not change
  List<Object?> get props => [_pure, value, id];

  @override
  String toString() {
    return '$runtimeType: { value: $value, valid: $valid, pure: $pure, failure: $failure}';
  }

  @override
  S consume<S>({required S onRight(void value), required S onLeft(Failure value)}) =>
      _validate.value.consume(onRight: onRight, onLeft: onLeft);
}

typedef PureDelegate<T> = bool Function(T? input);

class OptionalInput<T> extends Input<T> {
  final PureDelegate<T?> pureDelegate;

  OptionalInput(
    ValidationDelegate<T> delegate, {
    required this.pureDelegate,
    required InputIdentifier<T> id,
    required T value,
    bool pure = true,
  }) : super(delegate, value: value, pure: pure, id: id);

  @override
  bool get pure => super.pure || pureDelegate(value);

  @override
  bool get optional => true;
}
