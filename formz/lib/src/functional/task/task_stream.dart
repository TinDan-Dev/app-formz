import 'dart:async';

import 'package:rxdart/subjects.dart';

import '../result/result_state.dart';
import 'cancellation_token.dart';
import 'task.dart';

class TaskStream<In, Out> extends Stream<ResultState<Out>> {
  final BehaviorSubject<ResultState<Out>> _subject;
  final Task<In, Out> _task;

  CancellationToken? _currentToken;

  TaskStream(this._task) : _subject = BehaviorSubject();

  ResultState<Out> get state => _subject.valueOrNull ?? const ResultState.loading();

  bool get idle => _currentToken == null;

  @override
  StreamSubscription<ResultState<Out>> listen(
    void onData(ResultState<Out> event)?, {
    Function? onError,
    void onDone()?,
    bool? cancelOnError,
  }) =>
      _subject.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  void execute(In input) async {
    _currentToken?.cancel();

    state.when(
      loading: (_) {},
      success: (value) => _subject.add(ResultState.loading(value)),
      error: (_) => _subject.add(const ResultState.loading()),
    );

    final token = CancellationToken();
    final future = Future.microtask(() => _task.execute(input, token));

    _currentToken = token;

    final result = await future; // Await the task, every thing below is executed async
    if (token.canceled) return;

    assert(identical(token, _currentToken));

    result.consume(
      onRight: (value) => _subject.add(ResultState.success(value)),
      onLeft: (failure) => _subject.add(ResultState.error(failure)),
    );
    _currentToken = null;
  }

  void cancel() {
    _currentToken?.cancel();
    _currentToken = null;
  }

  Future<void> close() async {
    _currentToken?.cancel();
    await _subject.close();
  }
}
