part of 'resource.dart';

abstract class DBResource<T extends Object, Id extends Object> extends Resource<T, Id> {
  StreamSubscription? _streamSubscription;

  final Completer<Result<T?>> _completer;

  DBResource(Id identifier)
      : _completer = Completer(),
        super._(identifier);

  FutureOr<Result<Stream<Result<T?>>>> fetch();

  Future<Result<T>> get initial =>
      _completer.future.mapRightFlat((v) => v.fold(() => NullFailure('initial result'), Result.right));

  @override
  Future<void> _execute(CancellationReceiver receiver) async {
    await fetch().cancel(receiver).tapRightAsync((stream) {
      _streamSubscription = stream.listen(
        (data) {
          if (!_completer.isCompleted) _completer.complete(data);

          data.consume(
            onRight: (value) => value.let(_addValue),
            onLeft: _addFailure,
          );
        },
      );
    }).tapLeft((failure) {
      if (!_completer.isCompleted) _completer.complete(Result.left(failure));
    }).invoke();
  }

  @override
  Future<void> close() async {
    if (!_completer.isCompleted) _completer.complete(UnexpectedFailure('no result was published'));

    await _streamSubscription?.cancel();
    await super.close();
  }
}
