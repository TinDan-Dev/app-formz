import 'package:flutter_test/flutter_test.dart';

Future<void> Function() expectNoEmits(Stream stream) {
  final subscription = stream.listen(
    (e) => fail('stream emitted: $e'),
    cancelOnError: true,
    onError: (e) => fail('stream emitted error: $e'),
  );

  return () async {
    await Future.delayed(const Duration(milliseconds: 10));

    subscription.cancel();
  };
}
