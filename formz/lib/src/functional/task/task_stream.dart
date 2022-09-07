import 'dart:async';

import 'package:rxdart/subjects.dart';

import '../../utils/cancellation_token.dart';
import '../result/result.dart';
import '../result/result_state.dart';

typedef Task<In, Out> = FutureOr<Result<Out>> Function(In input, CancellationReceiver receiver);

class TaskStream<In, Out> extends Stream<ResultState<Out>> {
  final BehaviorSubject<ResultState<Out>> _subject;
  final Task<In, Out> _task;

  CancellationToken? _currentToken;

  TaskStream(this._task) : _subject = BehaviorSubject.seeded(const ResultState.loading());

  ResultState<Out> get state => _subject.value;

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
      success: (value) => _subject.add(ResultState.success(value)),
      error: (_) => _subject.add(const ResultState.loading()),
    );

    final token = CancellationToken();
    final future = Future.microtask(() => _task(input, token));

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
}
