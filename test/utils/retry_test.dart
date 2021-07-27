import 'package:flutter_test/flutter_test.dart' hide Retry;
import 'package:formz_test/formz_test.dart';
import 'package:rxdart/subjects.dart';

void main() {
  Retries.maxDelay = const Duration(milliseconds: 100);
  Retries.retryAttempts = 10;

  late PublishSubject subject;

  setUp(() {
    subject = PublishSubject();
  });

  tearDown(() {
    subject.close();
  });

  Consumable<T> errorToFailure<T>(Object? error, StackTrace? trace, CancellationToken token) {
    return ValueActionResult<T>.fail(const FakeFailure());
  }

  test('should execute once when successful', () async {
    final obj = Retry.explicit(
      action: () => subject.add('x'),
      errorToResult: errorToFailure,
    );

    final expectLate = expectLater(subject, emits('x'));
    final result = await obj.invoke();

    expect(result, validConsumable);
    await expectLate;
  });

  test('should execute till successful', () async {
    int c = 0;

    final obj = Retry.explicit(
      action: () {
        if (c < 5) {
          c++;
          throw 'x';
        }
        subject.add('success');
      },
      errorToResult: (error, trace, token) {
        subject.add(error);
        return errorToFailure(error, trace, token);
      },
    );

    final expectLate = expectLater(subject, emitsInOrder(['x', 'x', 'x', 'x', 'x', 'success']));
    final result = await obj.invoke();

    expect(result, validConsumable);
    await expectLate;
  });

  test('should stop executing when no call was successful after all retry attempts', () async {
    final obj = Retry.explicit(
      action: () => throw 'x',
      errorToResult: (error, trace, token) {
        subject.add(error);
        return errorToFailure(error, trace, token);
      },
    );

    final expectLate = expectLater(subject, emitsInOrder(['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x']));
    final result = await obj.invoke();

    expect(result, invalidConsumable);
    await expectLate;
  });

  test('should return the received value when successful', () async {
    final obj = Retry<int>.explicit(
      action: () => 42,
      errorToResult: errorToFailure,
    );

    final result = await obj.invoke();

    expect(result, consumableHasValue(42));
  });

  test('should return the last failure when not successful', () async {
    int c = 0;

    final obj = Retry.explicit(
      action: () => throw 'x',
      errorToResult: (error, trace, token) => ValueActionResult.fail(FakeFailure(index: ++c)),
    );

    final result = await obj.invoke();

    result.consume(
      onSuccess: (_) => fail('expceted a failure'),
      onError: (failure) => expect(failure is FakeFailure && failure.index == c, isTrue),
    );
  });

  test('should stop attempts when canceled', () async {
    int c = 0;

    final obj = Retry.explicit(
      action: () => throw 'x',
      errorToResult: (error, trace, token) {
        c++;
        subject.add(error);

        if (c == 5) token.cancel();

        return ValueActionResult.fail(FakeFailure(index: c));
      },
    );

    final expectLate = expectLater(subject, emitsInOrder(['x', 'x', 'x', 'x', 'x']));
    final result = await obj.invoke();

    result.consume(
      onSuccess: (_) => fail('expceted a failure'),
      onError: (failure) => expect(failure is FakeFailure && failure.index == c, isTrue),
    );
    await expectLate;
  });
}
