part of 'resource.dart';

abstract class NBResource<T extends Object> extends Resource<T> {
  StreamSubscription? _streamSubscription;

  NBResource(Object identifier) : super._(identifier);

  FutureOr<Either<Result<T>, Result<Stream<Result<T?>>>>> fetchLocal();

  FutureOr<Result<void>> saveLocal(T result);

  FutureOr<Result<T>> fetchRemote();

  @override
  Future<void> _execute(CancellationReceiver receiver) async {
    final localResult = await fetchLocal();

    if (receiver.canceled) return;

    await localResult.consume(
      onRight: (stream) => _streamLocal(receiver, stream),
      onLeft: (simple) => _simpleLocal(receiver, simple),
    );
  }

  Future<void> _streamLocal(CancellationReceiver receiver, Result<Stream<Result<T?>>> local) async {
    local.tapRight((stream) {
      _streamSubscription = stream.listen((data) => data.tapRight((value) => value.let(_addValue)));
    }).invoke();

    await _fetch(receiver);
  }

  Future<void> _simpleLocal(CancellationReceiver receiver, Result<T> local) async {
    local.tapRight(_addValue).invoke();

    await _fetch(receiver);
  }

  Future<void> _fetch(CancellationReceiver receiver) async {
    await fetchRemote().cancel(receiver).consume(
          onRight: (value) async {
            saveLocal(value);
            _addValue(value);
          },
          onLeft: (failure) => snapshot.consume(
            onRight: (value) {
              if (value == null) {
                _addFailure(failure);
              }
            },
            onLeft: (_) => _addFailure(failure),
          ),
        );
  }

  @override
  Future<void> close() async {
    await _streamSubscription?.cancel();
    await super.close();
  }
}
