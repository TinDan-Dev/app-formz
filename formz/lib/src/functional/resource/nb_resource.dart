part of 'resource.dart';

class NBResource<T extends Object, Id extends Object> extends Resource<T, Id> {
  StreamSubscription? _streamSubscription;

  final Task<Id, T>? fetchLocal;
  final Task<Id, Stream<Result<T>>>? streamLocal;

  final bool localSufficient;

  final Task<Id, T> fetchRemote;
  final Task<Tuple<Id, T>, void> saveLocal;

  NBResource(
    Id identifier, {
    this.fetchLocal,
    this.streamLocal,
    required this.fetchRemote,
    required this.saveLocal,
    this.localSufficient = false,
  })  : assert(fetchLocal != null || streamLocal != null),
        assert(fetchLocal == null || streamLocal == null),
        assert(!localSufficient || fetchLocal != null),
        super._(identifier);

  @override
  Future<void> _execute(CancellationReceiver receiver) async {
    if (fetchLocal != null) {
      final localResult = await fetchLocal!.execute(identifier).cancel(receiver).tapRight(_addValue);

      await localResult.consume(
        onLeft: (_) => _fetch(receiver),
        onRight: (_) async {
          if (!localSufficient) await _fetch(receiver);
        },
      );
    } else {
      await streamLocal!.execute(identifier).cancel(receiver).tapRight((stream) {
        _streamSubscription = stream.listen((data) => data.tapRight((value) => value.let(_addValue)));
      }).invoke();

      await _fetch(receiver);
    }
  }

  Future<void> _fetch(CancellationReceiver receiver) async {
    await fetchRemote.execute(identifier).cancel(receiver).consume(
          onRight: (value) async {
            saveLocal.execute(Tuple(first: identifier, second: value));
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
