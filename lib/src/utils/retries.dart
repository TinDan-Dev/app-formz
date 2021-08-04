import 'dart:math';

import 'retry.dart';

/// Global configuration for all [Retry] objects
abstract class Retries {
  /// The maximum amount of attempts the action is tried by the retry object.
  static int retryAttempts = 2;

  /// The maximum delay between each retry.
  static Duration maxDelay = const Duration(seconds: 3);

  /// Determines the duration to wait till the next attempt.
  static Duration timeInterpolation(int attempt) {
    final fraction = (1.0 / (1 + exp(-((attempt * 5.5) / (retryAttempts - 1)) + 1.5)));

    return Duration(milliseconds: (maxDelay.inMilliseconds * fraction).toInt());
  }
}
