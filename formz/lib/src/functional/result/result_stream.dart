import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../../utils/delegate/delegating_stream.dart';
import 'result.dart';
import 'result_state.dart';

abstract class ResultStream<T> with DelegatingStream<ResultState<T>> {
  final BehaviorSubject<Result<T>> _result;

  ResultState<T>? _state;

  ResultStream() : _result = BehaviorSubject() {
    stream.listen(
      (e) {
        _state = e;

        if (e.hasValue) {
          _result.add(e);
        }
      },
      onDone: () => _result.close(),
    );
  }

  ResultState<T> get state => _state ?? const ResultState.loading();

  Future<Result<T>> get result => _result.first;
}

class ResultStreamSubject<T> extends ResultStream<T> {
  final BehaviorSubject<ResultState<T>> _subject;

  ResultStreamSubject() : _subject = BehaviorSubject.seeded(const ResultState.loading());

  void add(Result<T> result) => _subject.add(result.consume(onRight: ResultState.success, onLeft: ResultState.error));

  Future<void> close() => _subject.close();

  @override
  Stream<ResultState<T>> get stream => _subject;
}

mixin ResultStreamMixin<T> on ResultStream<T> {
  final _subject = ResultStreamSubject<T>();

  @override
  Stream<ResultState<T>> get stream => _subject;

  @protected
  void add(Result<T> result) => _subject.add(result);

  @protected
  Future<void> close() => _subject.close();
}

mixin ResultStreamValueMixin<T> on ResultStream<T> {
  Result<T> get value;

  @override
  Stream<ResultState<T>> get stream =>
      Stream<ResultState<T>>.value(value.consume(onRight: ResultState.success, onLeft: ResultState.error));
}
