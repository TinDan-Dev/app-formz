import '../../functional/parser/exception.dart';
import '../../functional/result/result.dart';
import '../input.dart';

Input<T> createInput<T>(
  ValidationDelegate<T> delegate, {
  required InputIdentifier<T> id,
  required T value,
  bool pure = true,
}) =>
    Input<T>(
      delegate,
      id: id,
      pure: pure,
      value: value,
    );

Input<T> createSimpleInput<T>(
  bool validate(T value), {
  required InputIdentifier<T> id,
  required T value,
  bool pure = true,
}) =>
    Input<T>(
      (value) {
        if (validate(value)) {
          return const Result.right(null);
        } else {
          return ViolationFailure('value could not be validated');
        }
      },
      id: id,
      pure: pure,
      value: value,
    );

class _PureableInput<T> extends Input<T> with PureMixin<T> {
  @override
  final PureDelegate<T> pureDelegate;

  _PureableInput(
    ValidationDelegate<T> delegate, {
    required this.pureDelegate,
    required T value,
    required InputIdentifier<T> id,
    required bool pure,
  }) : super(delegate, value: value, id: id, pure: pure);

  @override
  Input<T> copyWith({required T value, bool pure = false}) => _PureableInput<T>(
        delegate,
        pureDelegate: pureDelegate,
        value: value,
        pure: pure,
        id: id,
      );
}

Input<T> createPureableInput<T>(
  ValidationDelegate<T> delegate, {
  required PureDelegate<T> pureDelegate,
  required InputIdentifier<T> id,
  required T value,
  bool pure = true,
}) =>
    _PureableInput(delegate, pureDelegate: pureDelegate, value: value, id: id, pure: pure);

class _OptionalInput<T> extends _PureableInput<T> with OptionalMixin<T> {
  _OptionalInput(
    ValidationDelegate<T> delegate, {
    required PureDelegate<T> pureDelegate,
    required T value,
    required InputIdentifier<T> id,
    required bool pure,
  }) : super(delegate, pureDelegate: pureDelegate, value: value, id: id, pure: pure);

  @override
  Input<T> copyWith({required T value, bool pure = false}) => _OptionalInput<T>(
        delegate,
        pureDelegate: pureDelegate,
        value: value,
        pure: pure,
        id: id,
      );
}

Input<T> createOptionalInput<T>(
  ValidationDelegate<T> delegate, {
  required PureDelegate<T> pureDelegate,
  required InputIdentifier<T> id,
  required T value,
  bool pure = true,
}) =>
    _OptionalInput(delegate, pureDelegate: pureDelegate, value: value, id: id, pure: pure);

class _LoadingInput<T> extends Input<T> with LoadingMixin<T> {
  @override
  final LoadingDelegate<T> loadingDelegate;

  _LoadingInput(
    ValidationDelegate<T> delegate, {
    required this.loadingDelegate,
    required T value,
    required InputIdentifier<T> id,
    required bool pure,
  }) : super(delegate, value: value, id: id, pure: pure);

  @override
  Input<T> copyWith({required T value, bool pure = false}) => _LoadingInput<T>(
        delegate,
        loadingDelegate: loadingDelegate,
        value: value,
        pure: pure,
        id: id,
      );
}

Input<T> createLoadingInput<T>(
  ValidationDelegate<T> delegate, {
  required LoadingDelegate<T> loadingDelegate,
  required InputIdentifier<T> id,
  required T value,
  bool pure = true,
}) =>
    _LoadingInput(delegate, loadingDelegate: loadingDelegate, value: value, id: id, pure: pure);
