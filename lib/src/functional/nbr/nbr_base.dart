import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../formz.tuple.dart';
import '../../utils/extensions.dart';
import '../either/either.dart';
import '../result/result.dart';
import '../result/result_state.dart';
import 'nbr.dart';

typedef ResourceLoadFunc<T> = FutureOr<Result<T>> Function();
typedef ResourceSaveFunc<T> = FutureOr<void> Function(T value);
typedef ResourceStreamFunc<T> = ResourceLoadFunc<Stream<T?>>;

/// Handles the loading cycle of remote resources.
///
/// The current state of the resources is exposed as a stream and the resource can also be consumed via a [Either].
/// The resource is considered successful when it's either successful or offline.
abstract class NBRBase<T, Local, Remote> extends NBR<T> {
  final BehaviorSubject<ResultState<T>> _subject;

  final ResourceLoadFunc<Local> fetchLocal;
  final ResourceLoadFunc<Remote> fetchRemote;
  final ResourceSaveFunc<T> saveLocal;
  final ResourceStreamFunc<Local>? fetchLocalStream;

  bool _disposed;

  NBRBase({
    required String id,
    required this.fetchLocal,
    required this.fetchRemote,
    required this.saveLocal,
    this.fetchLocalStream,
  })  : _subject = BehaviorSubject.seeded(const ResultState.loading()),
        _disposed = false,
        super(id) {
    _load(StackTrace.current);
  }

  @override
  ResultState<T> get currentState => _subject.value;

  /// Converts the resource from the locally stored format to the runtime format.
  FutureOr<Result<T>> fromLocal(Local local);

  /// Converts the resource received from the remote host to the runtime format.
  FutureOr<Result<T>> fromRemote(Remote remote);

  /// Determines whether the locally stored resource can be used at runtime. If
  /// true, the remote fetch won't be invoked.
  bool localValid(Local local, T localParsed) => false;

  /// Determines whether the locally stored resource can be used at runtime, if
  /// the remote fetch returns an error.
  bool localValidOnError(Local local, T localParsed, Failure remoteFailure) => false;

  /// When a local version and a remote version where fetched successfully this
  /// method decides which version to keep.
  ///
  /// Defaults to only keeping the remote version.
  FutureOr<T> combine(T local, T remote) => remote;

  @override
  Stream<ResultState<T>> get stream => _subject.stream;

  void _addStatus(ResultState<T> status) {
    if (_disposed) return;

    _subject.add(status);
  }

  Future<Result<void>> _loadWithLocal(Local local, T parsedLocal) async {
    _addStatus(ResultState.loading(parsedLocal));

    if (localValid(local, parsedLocal)) {
      _addStatus(ResultState.success(parsedLocal));
      return const Result.right(null);
    }

    final remoteResult = fetchRemote().mapRightFlatAsync(fromRemote);

    return remoteResult.consume(
      onRight: (parsedRemote) async {
        final combined = await combine(parsedLocal, parsedRemote);
        _addStatus(ResultState.success(combined));

        await saveLocal(combined);

        return const Result.right(null);
      },
      onLeft: (remoteFailure) async {
        if (localValidOnError(local, parsedLocal, remoteFailure)) {
          _addStatus(ResultState.success(parsedLocal));

          return const Result.right(null);
        } else {
          return Result.left(remoteFailure);
        }
      },
    );
  }

  Future<Result<void>> _loadWithoutLocal() async {
    final remoteResult = fetchRemote().mapRightFlatAsync(fromRemote);

    return remoteResult.tapRightAsync((parsedRemote) async {
      _addStatus(ResultState.success(parsedRemote));

      await saveLocal(parsedRemote);
    });
  }

  Future<void> _load(StackTrace invocationTrace) async {
    final localResult = fetchLocal().mapRightFlatAsync(
      (local) => fromLocal(local).mapRight((localParsed) => Tuple(first: local, second: localParsed)),
    );

    final result = localResult.consume(
      onLeft: (_) => _loadWithoutLocal(),
      onRight: (result) => _loadWithLocal(result.first, result.second),
    );

    await result.consume(
      onLeft: (failure) async {
        _addStatus(ResultState.error(failure.prependStackTrace(invocationTrace)));
        await _subject.close();
      },
      onRight: (_) async {
        final localStream = await fetchLocalStream?.call().rightOrNull();
        if (localStream != null) {
          final parsedStream = localStream
              .whereNotNull()
              .asyncMap((event) => fromLocal(event))
              .whereRight()
              .map((event) => ResultState.success(event));

          unawaited(_subject.addStream(parsedStream));
        } else {
          await _subject.close();
        }
      },
    );
  }

  @override
  Future<ResultState<T>> get toFuture async {
    final invocationTrace = StackTrace.current;

    try {
      return stream.firstWhere(
        (element) => element.map(
          loading: (_) => false,
          success: (_) => true,
          error: (_) => true,
        ),
        orElse: () => ResultState.error(
          Failure(
            message: 'stream was closed before a valid state was published',
            trace: invocationTrace,
          ),
        ),
      );
    } catch (e, s) {
      return ResultState.error(
        Failure(message: 'Unexpected error', trace: s, cause: e).prependStackTrace(invocationTrace),
      );
    }
  }

  @override
  void dispose() {
    assert(!_disposed, 'Do not dispose a nbr twice');

    if (_disposed) return;
    _disposed = true;

    _subject.close();
  }
}
