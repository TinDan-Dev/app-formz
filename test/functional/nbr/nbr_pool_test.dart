import 'package:flutter_test/flutter_test.dart';
import 'package:formz_test/formz_test.dart';
import 'package:mockito/mockito.dart';

class InvocationVerifier extends Mock {
  void invoke([dynamic input]) => super.noSuchMethod(Invocation.method(#invoke, [input]));
}

class FakeNBR extends NBR<String> {
  final InvocationVerifier disposeVerifier;

  FakeNBR()
      : disposeVerifier = InvocationVerifier(),
        super('fake');

  @override
  ResultState<String> get currentState => const ResultState.success('fake');

  @override
  Stream<ResultState<String>> get stream => Stream.value(currentState);

  @override
  Future<ResultState<String>> get toFuture => Future.value(currentState);

  @override
  void dispose() => disposeVerifier.invoke();
}

void main() {
  final now = DateTime(2001, 11, 01);
  const key = 'key';

  final keys = [
    for (int i = 0; i < 10; i++) i.toString(),
  ];

  const nbrSuccess = NBR.success('', value: 'value');
  final nbrError = NBR<String>.error('', failure: Failure(message: 'msg'));

  late NBRPool<NBR<String>> pool;

  setUp(() {
    pool = NBRPool();
  });

  group('add', () {
    test('should add the nbr with the key to the pool', () {
      pool.add(key, now: now, value: nbrSuccess);

      expect(pool.tryGet(key, now: now), equals(nbrSuccess));
    });

    test('should remove oldest entries when adding new ones', () {
      var time = now;
      final pool = NBRPool<NBR<String>>(maxSize: 10);

      const oldestKey = '-2';
      pool.add(oldestKey, now: time, value: nbrSuccess);

      time = time.add(const Duration(seconds: 1));

      const oldKey = '-1';
      pool.add(oldKey, now: time, value: nbrSuccess);

      time = time.add(const Duration(seconds: 1));

      expect(pool.currentSize, equals(2));
      expect(pool.tryGet(oldestKey, now: time), equals(nbrSuccess));
      expect(pool.tryGet(oldKey, now: time), equals(nbrSuccess));

      for (int i = 0; i < 9; i++) {
        pool.add(i.toString(), now: time, value: nbrSuccess);
      }

      expect(pool.currentSize, equals(10));
      expect(pool.tryGet(oldestKey, now: time), isNull);
      expect(pool.tryGet(oldKey, now: time), equals(nbrSuccess));
    });

    test('should remove elements to keep pool <= maxSize', () {
      final pool = NBRPool<NBR<String>>(maxSize: 10);

      for (int i = 0; i < 10; i++) {
        pool.add(i.toString(), now: now, value: nbrSuccess);
      }

      expect(pool.currentSize, equals(10));

      for (int i = 10; i < 100; i++) {
        pool.add(i.toString(), now: now, value: nbrSuccess);
        expect(pool.currentSize, equals(10));
      }
    });

    test('should remove elements that are outdated', () {
      var time = now;
      final pool = NBRPool<NBR<String>>(maxSize: 10);

      for (int i = 0; i < 10; i++) {
        pool.add(i.toString(), now: time, value: nbrSuccess);
      }

      expect(pool.currentSize, equals(10));

      time = time.add(const Duration(minutes: 1));

      pool.add('10', now: time, value: nbrSuccess);

      expect(pool.currentSize, equals(1));
    });
  });

  group('request', () {
    Tuple<InvocationVerifier, NBR<String>> request({
      bool outdatedOk = false,
      bool failedOk = false,
      required DateTime now,
    }) {
      final verifier = InvocationVerifier();

      final result = pool.request(
        key,
        now: now,
        failedOk: failedOk,
        outdatedOk: outdatedOk,
        create: () {
          verifier.invoke();
          return nbrSuccess;
        },
      );

      return Tuple(first: verifier, second: result);
    }

    test('should call create when key not found', () {
      final result = request(now: now);

      verify(result.first.invoke()).called(1);
    });

    test('should not call create and return nbr when key was found with valid nbr', () {
      pool.add(key, now: now, value: nbrSuccess);

      final result = request(now: now);

      verifyNever(result.first.invoke());
      expect(result.second, equals(nbrSuccess));
    });

    test('should call create when nbr with key is failed', () {
      pool.add(key, now: now, value: nbrError);

      final result = request(now: now);

      verify(result.first.invoke()).called(1);
    });

    test('should not call create and return nbr when nbr with key is failed but failedOk is true', () {
      pool.add(key, now: now, value: nbrError);

      final result = request(now: now, failedOk: true);

      verifyNever(result.first.invoke());
      expect(result.second, equals(nbrError));
    });

    test('should call create when nbr with key is outdated', () {
      var time = now;
      pool.add(key, now: now, value: nbrSuccess);

      final preResult = request(now: time);

      verifyNever(preResult.first.invoke());
      expect(preResult.second, equals(nbrSuccess));

      time = time.add(const Duration(minutes: 1));

      final result = request(now: time);

      verify(result.first.invoke()).called(1);
    });

    test('should not call create and return nbr when nbr with key is outdated but outdateOk is true', () {
      var time = now;
      pool.add(key, now: time, value: nbrSuccess);

      time = time.add(const Duration(minutes: 1));

      final result = request(now: time, outdatedOk: true);

      verifyNever(result.first.invoke());
      expect(result.second, equals(nbrSuccess));
    });
  });

  group('requestMultiple', () {
    Tuple<InvocationVerifier, Iterable<NBR<String>>> request({
      bool outdatedOk = false,
      bool failedOk = false,
      required DateTime now,
    }) {
      final verifier = InvocationVerifier();

      final result = pool.requestMultiple(
        keys,
        now: now,
        failedOk: failedOk,
        outdatedOk: outdatedOk,
        create: (_) {
          verifier.invoke();
          return nbrSuccess;
        },
      );

      return Tuple(first: verifier, second: result);
    }

    Iterable<T> repeated<T>(T value, int times) sync* {
      for (int i = 0; i < times; i++) {
        yield value;
      }
    }

    test('should call create when key not found', () {
      final result = request(now: now);

      verify(result.first.invoke()).called(keys.length);
      expect(result.second, hasLength(keys.length));
    });

    void addAll(NBR<String> nbr, {required DateTime now}) {
      for (final key in keys) {
        pool.add(key, now: now, value: nbr);
      }
    }

    test('should not call create and return nbr when key found', () {
      addAll(nbrSuccess, now: now);

      final result = request(now: now);

      verifyNever(result.first.invoke());
      expect(result.second, hasLength(keys.length));
    });

    test('should call create when nbr with key is failed', () {
      addAll(nbrError, now: now);

      final result = request(now: now);

      verify(result.first.invoke()).called(keys.length);
      expect(result.second, hasLength(keys.length));
    });

    test('should not call create return nbr when nbr with key is failed but failedOk is true', () {
      addAll(nbrError, now: now);

      final result = request(now: now, failedOk: true);

      verifyNever(result.first.invoke());
      expect(result.second, equals(repeated(nbrError, keys.length)));
    });

    test('should call create when nbr with key is outdated', () {
      var time = now;
      addAll(nbrSuccess, now: time);

      final preResult = request(now: time);

      verifyNever(preResult.first.invoke());
      expect(preResult.second, equals(repeated(nbrSuccess, keys.length)));

      time = time.add(const Duration(minutes: 1));

      final result = request(now: time);

      verify(result.first.invoke()).called(keys.length);
      expect(result.second, hasLength(keys.length));
    });

    test('should return nbr when nbr with key is outdated but outdateOk is true', () {
      var time = now;
      addAll(nbrSuccess, now: time);

      time = time.add(const Duration(minutes: 1));

      final result = request(now: time, outdatedOk: true);

      verifyNever(result.first.invoke());
      expect(result.second, equals(repeated(nbrSuccess, keys.length)));
    });
  });

  group('tryGet', () {
    test('should return null when key not found', () {
      final result = pool.tryGet(key, now: now);

      expect(result, isNull);
    });

    test('should return nbr when key was found with valid nbr', () {
      pool.add(key, now: now, value: nbrSuccess);

      final result = pool.tryGet(key, now: now);

      expect(result, equals(nbrSuccess));
    });

    test('should return null when nbr with key is failed', () {
      pool.add(key, now: now, value: nbrError);

      final result = pool.tryGet(key, now: now);

      expect(result, isNull);
    });

    test('should return nbr when nbr with key is failed but failedOk is true', () {
      pool.add(key, now: now, value: nbrError);

      final result = pool.tryGet(key, now: now, failedOk: true);

      expect(result, equals(nbrError));
    });

    test('should return null when nbr with key is outdated', () {
      var time = now;
      pool.add(key, now: time, value: nbrSuccess);

      expect(pool.tryGet(key, now: time), equals(nbrSuccess));
      time = time.add(const Duration(minutes: 1));

      expect(pool.tryGet(key, now: time), isNull);
    });

    test('should return nbr when nbr with key is outdated but outdateOk is true', () {
      var time = now;
      pool.add(key, now: time, value: nbrSuccess);

      time = time.add(const Duration(minutes: 1));

      expect(pool.tryGet(key, now: time), isNull);
      expect(pool.tryGet(key, now: time, outdatedOk: true), equals(nbrSuccess));
    });
  });

  group('dispose', () {
    test('should dispose nbr that are removed from the pool', () {
      final nbr = FakeNBR();

      var time = now;
      pool.add(key, now: time, value: nbr);

      time = time.add(const Duration(minutes: 1));
      pool.sweep(time);

      verify(nbr.disposeVerifier.invoke()).called(1);
    });

    test('should dispose old nbr on request', () {
      final nbr1 = FakeNBR();
      final nbr2 = FakeNBR();

      var time = now;
      pool.add(key, now: time, value: nbr1);

      time = time.add(const Duration(minutes: 1));
      pool.request(key, create: () => nbr2, now: time);

      verify(nbr1.disposeVerifier.invoke()).called(1);
      verifyNever(nbr2.disposeVerifier.invoke());
    });

    test('should ignore orphaned heap elements', () {
      final nbrs = List.generate(10, (index) => FakeNBR());

      var time = now;
      for (final nbr in nbrs) {
        pool.add(key, now: time, value: nbr);
      }

      time = time.add(const Duration(minutes: 1));
      pool.sweep(time);

      for (final nbr in nbrs) {
        verify(nbr.disposeVerifier.invoke()).called(1);
      }
    });
  });
}
