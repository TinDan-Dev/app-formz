import 'package:flutter/foundation.dart';

/// Used by actions that can be cancelled.
abstract class CancellationReceiver implements ChangeNotifier {
  const CancellationReceiver();

  const factory CancellationReceiver.unused() = _UnusedCancellationReceiver;

  /// Whether the action should stop executing.
  bool get canceled;
}

class _UnusedCancellationReceiver extends CancellationReceiver {
  const _UnusedCancellationReceiver();

  @override
  bool get canceled => false;

  @override
  bool get hasListeners => false;

  @override
  void addListener(VoidCallback listener) {}

  @override
  void dispose() {}

  @override
  void notifyListeners() {}

  @override
  void removeListener(VoidCallback listener) {}
}

/// Used to cancel an ongoing action.
class CancellationToken extends CancellationReceiver with ChangeNotifier {
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

    notifyListeners();
    dispose();
  }
}
