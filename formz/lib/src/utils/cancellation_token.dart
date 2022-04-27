/// Used by cancellable actions.
class CancellationToken {
  /// Whether the token has been canceled or not.
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
