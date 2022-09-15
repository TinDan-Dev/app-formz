import '../result/result.dart';
import '../result/result_stream.dart';

abstract class NBR<T> extends ResultStream<T> {
  final String id;

  NBR(this.id);

  factory NBR.success(String id, {required T value}) = _NBRSuccess<T>;

  factory NBR.error(String id, {required Failure failure}) = _NBRError<T>;

  void dispose();
}

class _NBRSuccess<T> extends NBR<T> with ResultStreamValueMixin<T> {
  @override
  final Result<T> value;

  _NBRSuccess(String id, {required T value})
      : value = Result.right(value),
        super(id);

  @override
  void dispose() {}
}

class _NBRError<T> extends NBR<T> with ResultStreamValueMixin<T> {
  @override
  final Result<T> value;

  _NBRError(String id, {required Failure failure})
      : value = Result.left(failure),
        super(id);

  @override
  void dispose() {}
}
