import 'package:freezed_annotation/freezed_annotation.dart';

import '../../utils/extensions.dart';
import 'result.dart';

part 'result_state.freezed.dart';

class ResultStateFailure<T> extends Failure<T> {
  ResultStateFailure(String msg)
      : super(
          message: msg,
          trace: StackTrace.current,
        );
}

/// Represents the current state of a result on a stream.
@freezed
class ResultState<T> with _$ResultState<T> implements Result<T> {
  const ResultState._();

  factory ResultState.from(Result<T> result) => result.consume(
        onRight: (v) => ResultState.success(v),
        onLeft: (v) => ResultState.error(v),
      );

  /// The loading state.
  ///
  /// If the task for the result is currently running or waiting.
  const factory ResultState.loading([T? value]) = ResultStateLoading;

  /// The success state.
  ///
  /// If the task for the result completed successfully. Contains the resulting
  /// value.
  const factory ResultState.success(T value) = ResultStateSuccess;

  /// The error state.
  ///
  /// If the task for the result could not be completed successfully. Contains
  /// the failure that caused the error.
  const factory ResultState.error(Failure failure) = ResultStateError;

  bool get isLoading => whenOrNull(loading: (_) => true) ?? false;
  bool get isSuccess => whenOrNull(success: (_) => true) ?? false;
  bool get isError => whenOrNull(error: (_) => true) ?? false;

  @override
  S consume<S>({
    required S onRight(T value),
    required S onLeft(Failure value),
  }) {
    return when(
      loading: (value) => value.fold(
        () => onLeft(ResultStateFailure('Result $T is loading without a value')),
        onRight,
      ),
      success: onRight,
      error: onLeft,
    );
  }
}
