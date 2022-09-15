import 'dart:async';

import '../../../formz.tuple.dart';
import '../../utils/extensions.dart';
import '../either/either.dart';
import '../result/result.dart';
import '../result/result_failures.dart';
import '../result/result_state.dart';
import '../result/result_stream.dart';
import 'nbr.dart';

typedef ResourceLoadFunc<T> = FutureOr<Result<T>> Function();
typedef ResourceSaveFunc<T> = FutureOr<void> Function(T value);
typedef ResourceStreamFunc<T> = ResourceLoadFunc<Stream<T?>>;

/// Handles the loading cycle of remote resources.
///
/// The current state of the resources is exposed as a stream and the resource can also be consumed via a [Either].
/// The resource is considered successful when it's either successful or offline.
abstract class NBRBase<T, Local, Remote> extends NBR<T> with ResultStreamMixin<T> {
  final ResourceLoadFunc<Local> fetchLocal;
  final ResourceLoadFunc<Remote> fetchRemote;
  final ResourceSaveFunc<T> saveLocal;
  final ResourceStreamFunc<Local>? fetchLocalStream;

  bool _disposed;

  StreamSubscription<void>? _subscription;

  NBRBase({
    required String id,
    required this.fetchLocal,
    required this.fetchRemote,
    required this.saveLocal,
    this.fetchLocalStream,
  })  : _disposed = false,
        super(id) {
    _load(StackTrace.current);
  }

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

  void _addStatus(ResultState<T> status) {
    if (_disposed) return;

    add(status);
  }

  Future<void> _saveLocal(T value) async {
    try {
      await saveLocal(value);
    } catch (e, s) {
      assert(false, 'Failed to save $runtimeType: $e\n$s');
    }
  }

  Future<Result<void>> _loadWithLocal(Local local, T parsedLocal) async {
    _addStatus(ResultState.loading(parsedLocal));

    if (localValid(local, parsedLocal)) {
      _addStatus(ResultState.success(parsedLocal));
      return const Result.right(null);
    }

    final remoteResult = fetchRemote().mapRightAsyncFlat(fromRemote);

    return remoteResult.consume(
      onRight: (parsedRemote) async {
        final combined = await combine(parsedLocal, parsedRemote);
        _addStatus(ResultState.success(combined));

        await _saveLocal(combined);

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
    final remoteResult = fetchRemote().mapRightAsyncFlat(fromRemote);

    return remoteResult.tapRightAsync((parsedRemote) async {
      _addStatus(ResultState.success(parsedRemote));

      await _saveLocal(parsedRemote);
    });
  }

  Future<void> _load(StackTrace invocationTrace) async {
    final localResult = fetchLocal().mapRightAsyncFlat(
      (local) => fromLocal(local).mapRight((localParsed) => Tuple(first: local, second: localParsed)),
    );

    final result = localResult.consume(
      onLeft: (_) => _loadWithoutLocal(),
      onRight: (result) => _loadWithLocal(result.first, result.second),
    );

    await result.consume(
      onLeft: (failure) async {
        _addStatus(ResultState.error(failure.prependStackTrace(invocationTrace)));
        await close();
      },
      onRight: (_) async {
        final localStream = await fetchLocalStream?.call().rightOrNull();
        if (_disposed) return;

        if (localStream != null) {
          final parsedStream = localStream
              .whereNotNull()
              .asyncMap((event) => fromLocal(event))
              .whereRight()
              .map((event) => ResultState.success(event));

          _subscription = parsedStream.listen(add);
        } else {
          await close();
        }
      },
    );
  }

  @override
  Future<void> dispose() async {
    assert(!_disposed, 'Do not dispose a nbr twice');

    if (_disposed) return;
    _disposed = true;

    if (state.isLoading) {
      add(ResultState.error(UnexpectedFailure('NBR was disposed during loading')));
    }

    await _subscription?.cancel();
    await close();
  }
}
