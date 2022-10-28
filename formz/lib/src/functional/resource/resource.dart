import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import '../../utils/extensions.dart';
import '../either/either.dart';
import '../result/result.dart';
import '../result/result_extension.dart';
import '../result/result_failures.dart';
import '../task/cancellation_token.dart';

part 'db_resource.dart';
part 'nb_resource.dart';

abstract class Resource<T extends Object> {
  final Object identifier;

  final BehaviorSubject<Result<T>> _subject;
  final CancellationToken _cancellationToken;

  bool _closed;

  Resource._(this.identifier)
      : _subject = BehaviorSubject(),
        _cancellationToken = CancellationToken(),
        _closed = false {
    _execute(_cancellationToken);
  }

  Stream<Result<T>> get stream => _subject.stream.whereNotNull();

  Future<Result<T>> get value async {
    if (_closed) {
      return UnexpectedFailure('resource is closed');
    }

    final value = _subject.valueOrNull;

    if (value != null) {
      return value;
    } else {
      await for (final value in stream) {
        return value;
      }

      return UnexpectedFailure('no result was published');
    }
  }

  Result<T?> get snapshot {
    if (_closed) {
      return UnexpectedFailure('resource is closed');
    }

    return _subject.valueOrNull.fold(() => const Result.right(null), (some) => some);
  }

  Future<void> _execute(CancellationReceiver receiver);

  void _addValue(T value) => _subject.add(Result.right(value));

  void _addFailure(Failure failure) => _subject.add(Result.left(failure));

  Future<void> close() async {
    assert(!_closed);
    _closed = true;

    _cancellationToken.cancel();
    await _subject.close();
  }
}
