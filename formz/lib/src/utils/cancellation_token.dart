/// Used by actions that can be cancelled.
abstract class CancellationReceiver {
  /// Whether the action should stop executing.
  bool get canceled;
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
