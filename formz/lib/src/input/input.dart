import 'package:equatable/equatable.dart';

import '../functional/either/either.dart';
import '../functional/result/result.dart';
import '../utils/lazy.dart';

part 'input_identifier.dart';

typedef ValidationDelegate<T> = Result<void> Function(T input);

// Using lazy validation to improve performance, thus this class is still immutable but the validation function is only called
// once. The mixin is used to avoid immutable warnings.
class Input<T> extends Equatable implements Result<T> {
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

  bool get loading => false;

  @override
  // uses the final pure to ensure the equality does not change
  List<Object?> get props => [_pure, value, id];

  @override
  String toString() {
    return '$runtimeType: { value: $value, valid: $valid, pure: $pure, failure: $failure}';
  }

  @override
  S consume<S>({required S onRight(T value), required S onLeft(Failure value)}) {
    if (valid) {
      return onRight(value);
    } else {
      return onLeft(failure ?? Failure(message: 'Unexpected state: Input invalid but no failure provided'));
    }
  }
}

typedef PureDelegate<T> = bool Function(T value);

mixin PureMixin<T> on Input<T> {
  PureDelegate<T> get pureDelegate;

  @override
  bool get pure => super.pure || pureDelegate(value);
}

mixin OptionalMixin<T> on PureMixin<T> {
  @override
  bool get optional => true;
}

typedef LoadingDelegate<T> = bool Function(T value);

mixin LoadingMixin<T> on Input<T> {
  PureDelegate<T> get loadingDelegate;

  @override
  bool get loading => loadingDelegate(value);
}
