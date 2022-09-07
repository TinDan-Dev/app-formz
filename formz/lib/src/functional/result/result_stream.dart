import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';

import 'result.dart';
import 'result_state.dart';

abstract class ResultStream<T> extends Stream<ResultState<T>> implements ResultFuture<T> {}

class ResultStreamSubject<T> extends ResultStream<T> {
  final BehaviorSubject<ResultState<T>> _subject;

  ResultStreamSubject() : _subject = BehaviorSubject.seeded(const ResultState.loading());

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

  @override
  S consume<S>({required S Function(T value) onRight, required S Function(Failure value) onLeft}) {
    // TODO: implement consume
    throw UnimplementedError();
  }
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

  @protected
  void add(Result<T> result) => _subject.add(result);

  @protected
  Future<void> close() => _subject.close();
}
