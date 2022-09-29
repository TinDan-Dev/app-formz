import '../../functional/result/result.dart';
import '../../functional/result/result_state.dart';
import '../input.dart';
import 'default_input.dart';

Input<Result<T>> createResultInput<T>({
  required InputIdentifier<Result<T>> id,
  required Result<T> value,
  bool pure = true,
}) =>
    createInput<Result<T>>(
      (value) => value,
      id: id,
      pure: pure,
      value: value,
    );

Input<Result<T>> createOptionalResultInput<T>({
  required InputIdentifier<Result<T>> id,
  required PureDelegate<Result<T>> pureDelegate,
  required Result<T> value,
  bool pure = true,
}) =>
    createOptionalInput<Result<T>>(
      (value) => value,
      pureDelegate: pureDelegate,
      id: id,
      pure: pure,
      value: value,
    );

class _ResultStateInput<T> extends Input<ResultState<T>> with LoadingMixin<ResultState<T>> {
  _ResultStateInput(
    ValidationDelegate<ResultState<T>> delegate, {
    required ResultState<T> value,
    required InputIdentifier<ResultState<T>> id,
    required bool pure,
  }) : super(delegate, value: value, id: id, pure: pure);

  @override
  PureDelegate<ResultState<T>> get loadingDelegate => pure ? (_) => false : (value) => value.isLoading;

  @override
  Input<ResultState<T>> copyWith({required ResultState<T> value, bool pure = false}) => _ResultStateInput<T>(
        delegate,
        value: value,
        pure: pure,
        id: id,
      );
}

Input<ResultState<T>> createResultStateInput<T>(
  InputIdentifier<ResultState<T>> id, {
  ResultState<T> value = const ResultState.loading(),
  bool pure = true,
}) =>
    _ResultStateInput<T>(
      (value) => value.when(
        loading: (_) => ResultStateFailure('result is loading'),
        success: (value) => Result.right(value),
        error: (failure) => Result.left(failure),
      ),
      id: id,
      pure: pure,
      value: value,
    );
