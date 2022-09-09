import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import 'result.dart';
import 'result_failures.dart';
import 'result_state.dart';

abstract class ResultStream<T> extends Stream<ResultState<T>> {
  ResultState<T> get currentResult;

  Future<Result<T>> get nextResult async {
    await for (final result in this) {
      if (result.isLoading) continue;

      return result;
    }

    return UnexpectedFailure('Stream was closed before next result was published');
  }

  Future<Result<T>> get lastResult async {
    Result<T>? buffer;

    await for (final result in this) {
      if (result.isLoading) continue;

      buffer = result;
    }

    if (buffer != null) {
      return buffer;
    } else {
      return UnexpectedFailure('Stream was closed before a result was published');
    }
  }
}

class ResultStreamSubject<T> extends ResultStream<T> {
  final BehaviorSubject<ResultState<T>> _subject;

  ResultStreamSubject() : _subject = BehaviorSubject.seeded(const ResultState.loading());

  @override
  ResultState<T> get currentResult => _subject.value;

  @override
  StreamSubscription<ResultState<T>> listen(
    void onData(ResultState<T> event)?, {
    Function? onError,
    void onDone()?,
    bool? cancelOnError,
  }) =>
      _subject.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  void add(Result<T> result) => _subject.add(result.consume(onRight: ResultState.success, onLeft: ResultState.error));

  Future<void> close() => _subject.close();
}

mixin ResultStreamMixin<T> on ResultStream<T> {
  final _subject = ResultStreamSubject<T>();

  @override
  StreamSubscription<ResultState<T>> listen(
    void onData(ResultState<T> event)?, {
    Function? onError,
    void onDone()?,
    bool? cancelOnError,
  }) =>
      _subject.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  @override
  ResultState<T> get currentResult => _subject.currentResult;

  @protected
  void add(Result<T> result) => _subject.add(result);

  @protected
  Future<void> close() => _subject.close();
}

mixin ResultStreamValueMixin<T> on ResultStream<T> {
  Result<T> get value;

  @override
  ResultState<T> get currentResult => ResultState.from(value);

  @override
  StreamSubscription<ResultState<T>> listen(
    void onData(ResultState<T> event)?, {
    Function? onError,
    void onDone()?,
    bool? cancelOnError,
  }) =>
      Stream<ResultState<T>>.value(value.consume(onRight: ResultState.success, onLeft: ResultState.error))
          .listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
}
