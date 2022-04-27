import 'package:flutter_test/flutter_test.dart' hide Retry;
import 'package:formz/formz.dart';
import 'package:formz_dev/formz_test.dart';
import 'package:rxdart/subjects.dart';

void main() {
  Retries.maxDelay = const Duration(microseconds: 100);
  Retries.retryAttempts = 10;

  late PublishSubject subject;

  setUp(() {
    subject = PublishSubject();
  });

  tearDown(() {
    subject.close();
  });

  Result<T> errorToFailure<T>(Object? error, StackTrace? trace, CancellationToken token) {
    return Result.left(FakeFailure());
  }

  test('should execute once when successful', () async {
    final expectLate = expectLater(subject, emits('x'));

    final result = Retry.explicit(
      action: () => subject.add('x'),
      errorToResult: errorToFailure,
    );

    expect(result, isRight);
    await expectLate;
  });

  test('should execute till successful', () async {
    final expectLate = expectLater(subject, emitsInOrder(['x', 'x', 'x', 'x', 'x', 'success']));

    int c = 0;
    final result = Retry.explicit(
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

    expect(result, isRight);
    await expectLate;
  });

  test('should stop executing when no call was successful after all retry attempts', () async {
    final expectLate = expectLater(subject, emitsInOrder(['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x']));

    final result = Retry.explicit(
      action: () => throw 'x',
      errorToResult: (error, trace, token) {
        subject.add(error);
        return errorToFailure(error, trace, token);
      },
    );

    expect(result, isLeft);
    await expectLate;
  });

  test('should return the received value when successful', () async {
    final result = Retry<int>.explicit(
      action: () => 42,
      errorToResult: errorToFailure,
    );

    expect(result, isRightWith(42));
  });

  test('should return the last failure when not successful', () async {
    int c = 0;

    final result = Retry.explicit(
      action: () => throw 'x',
      errorToResult: (error, trace, token) => Result.left(FakeFailure(index: ++c)),
    );

    await result.consume(
      onRight: (_) => fail('expected a failure'),
      onLeft: (failure) => expect(failure is FakeFailure && failure.index == c, isTrue),
    );
  });

  test('should stop attempts when canceled', () async {
    final expectLate = expectLater(subject, emitsInOrder(['x', 'x', 'x', 'x', 'x']));

    int c = 0;
    final result = Retry.explicit(
      action: () => throw 'x',
      errorToResult: (error, trace, token) {
        c++;
        subject.add(error);

        if (c == 5) token.cancel();

        return Result.left(FakeFailure(index: c));
      },
    );

    await result.consume(
      onRight: (_) => fail('expected a failure'),
      onLeft: (failure) => expect(failure is FakeFailure && failure.index == c, isTrue),
    );
    await expectLate;
  });

  test('should stop attempts when shouldContinue returns false', () async {
    final expectLate = expectLater(subject, emitsInOrder(['x', 'x', 'x', 'x', 'x']));

    int c = 0;
    final result = Retry.explicit(
      action: () => throw 'x',
      errorToResult: (error, trace, token) {
        c++;
        subject.add(error);

        return Result.left(FakeFailure(index: c));
      },
      shouldContinue: (failure) {
        if (failure is FakeFailure) {
          return failure.index < 5;
        } else {
          return true;
        }
      },
    );

    await result.consume(
      onRight: (_) => fail('expected a failure'),
      onLeft: (failure) => expect(failure is FakeFailure && failure.index == c, isTrue),
    );
    await expectLate;
  });
}
