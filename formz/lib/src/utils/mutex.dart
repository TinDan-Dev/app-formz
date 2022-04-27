import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'extensions.dart';

class MutexLock {
  final Completer _completer;

  MutexLock() : _completer = Completer();

  bool get isLocked => !_completer.isCompleted;

  void unlock() {
    assert(!_completer.isCompleted, 'a lock can only be unlocked once');
    _completer.complete();
  }
}

class Mutex {
  final PublishSubject<void> _debounceSubject;

  MutexLock? _currentLock;

  Mutex() : _debounceSubject = PublishSubject();

  bool get isLocked => _currentLock.fold(() => false, (some) => some.isLocked);

  Future<MutexLock> lock() async {
    final prevLock = _currentLock;

    final lock = MutexLock();
    unawaited(lock._completer.future.then((value) => _debounceSubject.add(null)));

    _currentLock = lock;
    if (prevLock != null) await prevLock._completer.future;

    return lock;
  }

  Future<T> scope<T>(FutureOr<T> action()) async {
    final scopeLock = await lock();

    try {
      final result = await action();
      return result;
    } finally {
      scopeLock.unlock();
    }
  }

  Future<void> awaitRelease() => _currentLock?._completer.future ?? Future.value(null);

  Future<void> dispose() => _debounceSubject.close();
}

extension MutexDebounceExtension<T> on Stream<T> {
  Stream<T> debounceMutex(Mutex mutex) {
    return debounce((event) {
      if (mutex.isLocked) {
        return mutex._debounceSubject.stream;
      } else {
        return const Stream.empty();
      }
    });
  }
}
