/// Used by actions that can be cancelled.
abstract class CancellationReceiver {
  const factory CancellationReceiver.unused() = _UnusedCancellationReceiver;

  /// Whether the action should stop executing.
  bool get canceled;
}

class _UnusedCancellationReceiver implements CancellationReceiver {
  const _UnusedCancellationReceiver();

  @override
  bool get canceled => false;
}

/// Used to cancel an ongoing action.
class CancellationToken implements CancellationReceiver {
  /// Whether the token has been canceled or not.
  @override
  bool get canceled => _canceled;

  bool _canceled = false;

  /// Cancels this token.
  ///
  /// This should only be called once.
  void cancel() {
    assert(!_canceled, 'A cancellation token can not be canceled twice');
    _canceled = true;
  }
}
