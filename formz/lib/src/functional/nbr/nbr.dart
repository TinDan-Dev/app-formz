import '../either/either.dart';
import '../result/result.dart';
import '../result/result_state.dart';

abstract class NBR<T> extends EitherStream<ResultState<T>> {
  final String id;

  const NBR(this.id);

  const factory NBR.success(String id, {required T value}) = _NBRSuccess<T>;

  const factory NBR.error(String id, {required Failure failure}) = _NBRError<T>;

  ResultState<T> get currentState;

  void dispose();
}

class _NBRSuccess<T> extends NBR<T> {
  final T value;

  const _NBRSuccess(String id, {required this.value}) : super(id);

  @override
  ResultState<T> get currentState => ResultState.success(value);

  @override
  Stream<ResultState<T>> get stream => Stream.value(currentState);

  @override
  Future<ResultState<T>> get toFuture => Future.value(currentState);

  @override
  void dispose() {}
}

class _NBRError<T> extends NBR<T> {
  final Failure failure;

  const _NBRError(String id, {required this.failure}) : super(id);

  @override
  ResultState<T> get currentState => ResultState.error(failure);

  @override
  Stream<ResultState<T>> get stream => Stream.value(currentState);

  @override
  Future<ResultState<T>> get toFuture => Future.value(currentState);

  @override
  void dispose() {}
}
