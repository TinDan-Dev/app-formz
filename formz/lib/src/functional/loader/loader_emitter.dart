import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../result/result.dart';

part 'loader_emitter.freezed.dart';

@freezed
class EmitterUpdate with _$EmitterUpdate {
  const factory EmitterUpdate.result(Type key, dynamic value) = EmitterUpdateResult;

  const factory EmitterUpdate.error(Failure failure) = EmitterUpdateError;

  const factory EmitterUpdate.config(Map<String, Object?> configs) = EmitterUpdateConfig;
}

class LoaderEmitter {
  final PublishSubject<EmitterUpdate> _subject;
  final List<void Function()> _onDoneCallbacks;

  bool get done => _subject.isClosed;

  Stream<EmitterUpdate> get stream => _subject;

  LoaderEmitter()
      : _subject = PublishSubject(),
        _onDoneCallbacks = [] {
    _subject.onCancel = _onCancel;
  }

  void _onCancel() {
    _subject.close();

    for (final callback in _onDoneCallbacks) {
      callback();
    }
  }

  void addValue<T>(T value) {
    if (_subject.isClosed) return;

    _subject.add(EmitterUpdate.result(T, value));
  }

  void addError(Failure failure) {
    if (_subject.isClosed) return;

    _subject.add(EmitterUpdate.error(failure));
  }

  void addConfig(Map<String, Object?> configs) {
    if (_subject.isClosed) return;

    _subject.add(EmitterUpdate.config(configs));
  }

  void onDone(void callback()) {
    if (_subject.isClosed) {
      callback();
    } else {
      _onDoneCallbacks.add(callback);
    }
  }
}
