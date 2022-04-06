import 'package:freezed_annotation/freezed_annotation.dart';

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

  /// The loading state.
  ///
  /// If the task for the result is currently running or waiting.
  const factory ResultState.loading() = ResultStateLoading;

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

  @override
  S consume<S>({
    required S onRight(T value),
    required S onLeft(Failure value),
  }) {
    return when(
      loading: () => onLeft(ResultStateFailure('Result $T is loading')),
      success: onRight,
      error: onLeft,
    );
  }
}
