import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/src/functional/nbr/nbr_base.dart';
import 'package:formz/src/functional/result/result_state.dart';
import 'package:formz/src/utils/extensions.dart';
import 'package:formz_test/formz_test.dart';

const localContent = 'local content';
const remoteContent = 'remote content';

final localFailure = FakeFailure(index: 1);
final remoteFailure = FakeFailure(index: 2);
final conversionFailure = FakeFailure(index: 3);

ResultFuture<String> defaultFetchLocalSuccess() => const ResultFuture.right(localContent);
ResultFuture<String> defaultFetchLocalFailure() => ResultFuture.left(localFailure);

ResultFuture<String> defaultFetchRemoteSuccess() => const ResultFuture.right(remoteContent);
ResultFuture<String> defaultFetchRemoteFailure() => ResultFuture.left(remoteFailure);

FutureOr<Result<String>> defaultConversionFailure(String _) => Result.left(conversionFailure);

Future<void> defaultSaveLocalSuccess(String value) async {}

class SaveLocalTest {
  bool invoked = false;
  String? value;

  void invoke(String value) {
    this.value = value;
    invoked = true;
  }
}

class TestNetworkBoundResource extends NBRBase<String, String, String> {
  final FutureOr<Result<String>> Function(String local)? fromLocalFunc;
  final FutureOr<Result<String>> Function(String remote)? fromRemoteFunc;

  final bool isLocalValid;
  final bool isLocalValidOnError;

  TestNetworkBoundResource({
    ResourceLoadFunc<String> fetchLocal = defaultFetchLocalFailure,
    ResourceLoadFunc<String> fetchRemote = defaultFetchRemoteSuccess,
    ResourceSaveFunc<String> saveLocal = defaultSaveLocalSuccess,
    this.fromLocalFunc,
    this.fromRemoteFunc,
    this.isLocalValid = false,
    this.isLocalValidOnError = false,
  }) : super(id: '', fetchLocal: fetchLocal, fetchRemote: fetchRemote, saveLocal: saveLocal);

  @override
  bool localValid(String local, String localParsed) => isLocalValid;

  @override
  bool localValidOnError(String local, String localParsed, Failure remoteFailure) => isLocalValidOnError;

  @override
  FutureOr<Result<String>> fromLocal(String local) async {
    return fromLocalFunc.fold(() => Result.right(local), (some) => some(local));
  }

  @override
  FutureOr<Result<String>> fromRemote(String remote) {
    return fromRemoteFunc.fold(() => Result.right(remote), (some) => some(remote));
  }
}

Future<void> shouldReturnRemote(TestNetworkBoundResource resource) async {
  await resource.consume(
    onRight: (result) => expect(result, equals(remoteContent)),
    onLeft: (failure) => fail(failure.toString()),
  );
}

Future<void> shouldReturnRemoteFailure(TestNetworkBoundResource resource) async {
  expect(resource, isLeft);
}

Future<void> shouldReturnConversionFailure(TestNetworkBoundResource resource) async {
  expect(resource, isLeft);
}

Future<void> shouldReturnLocal(TestNetworkBoundResource resource) async {
  await resource.consume(
    onRight: (result) => expect(result, equals(localContent)),
    onLeft: (failure) => fail(failure.toString()),
  );
}

Future<void> shouldInvokeSaveLocal(SaveLocalTest test, TestNetworkBoundResource resource) async {
  expect(test.invoked, isTrue);
  expect(test.value, remoteContent);
}

Future<void> shouldNotInvokeSaveLocal(SaveLocalTest test, TestNetworkBoundResource resource) async {
  expect(test.invoked, isFalse);
  expect(test.value, isNull);
}

Future<void> shouldEmitLoading(TestNetworkBoundResource resource) async {
  final expectation = expectLater(resource, emitsThrough(isA<ResultStateLoading>()));

  await expectation;
}

Future<void> shouldEmitLoadingWithLocal(TestNetworkBoundResource resource) async {
  final expectation = expectLater(
    resource,
    emitsThrough(
      predicate<ResultState>(
        (state) => state.maybeWhen(
          loading: (value) => value == localContent,
          orElse: () => false,
        ),
      ),
    ),
  );

  await expectation;
}

Future<void> shouldEmitRemote(TestNetworkBoundResource resource) async {
  final expectation = expectLater(
    resource,
    emitsThrough(
      predicate<ResultState>(
        (state) => state.maybeWhen(
          success: (value) => value == remoteContent,
          orElse: () => false,
        ),
      ),
    ),
  );

  await expectation;
}

Future<void> shouldEmitFailure(TestNetworkBoundResource resource) async {
  final expectation = expectLater(
    resource,
    emitsThrough(
      predicate<ResultState>(
        (state) => state.maybeWhen(
          error: (_) => true,
          orElse: () => false,
        ),
      ),
    ),
  );

  await expectation;
}

Future<void> shouldEmitLocal(TestNetworkBoundResource resource) async {
  final expectation = expectLater(
    resource,
    emitsThrough(
      predicate<ResultState>(
        (state) => state.maybeWhen(
          success: (value) => value == localContent,
          orElse: () => false,
        ),
      ),
    ),
  );

  await expectation;
}

void defaultRemoteFetchTest({bool isLocalValid = false, bool isLocalValidOnError = false}) {
  test('should return the remote result when the remote fetch was successful', () async {
    final resource = TestNetworkBoundResource(isLocalValid: isLocalValid, isLocalValidOnError: isLocalValidOnError);

    await shouldReturnRemote(resource);
  });

  test('should return an error when the remote fetch was not successful', () async {
    final resource = TestNetworkBoundResource(
      fetchRemote: defaultFetchRemoteFailure,
      isLocalValid: isLocalValid,
      isLocalValidOnError: isLocalValidOnError,
    );

    await shouldReturnRemoteFailure(resource);
  });

  test('should return an error when the remote conversion was not successful', () async {
    final resource = TestNetworkBoundResource(
      fromRemoteFunc: defaultConversionFailure,
      isLocalValid: isLocalValid,
      isLocalValidOnError: isLocalValidOnError,
    );

    await shouldReturnConversionFailure(resource);
  });

  test('should emit loading first', () async {
    final resource = TestNetworkBoundResource(isLocalValid: isLocalValid, isLocalValidOnError: isLocalValidOnError);

    await shouldEmitLoading(resource);
  });

  test('should emit the remote result when the remote fetch was successful', () async {
    final resource = TestNetworkBoundResource(isLocalValid: isLocalValid, isLocalValidOnError: isLocalValidOnError);

    await shouldEmitRemote(resource);
  });

  test('should emit an error when the remote fetch was not successful', () async {
    final resource = TestNetworkBoundResource(
      fetchRemote: defaultFetchRemoteFailure,
      isLocalValid: isLocalValid,
      isLocalValidOnError: isLocalValidOnError,
    );

    await shouldEmitFailure(resource);
  });

  test('should emit an error when the remote conversion was not successful', () async {
    final resource = TestNetworkBoundResource(
      fromRemoteFunc: defaultConversionFailure,
      isLocalValid: isLocalValid,
      isLocalValidOnError: isLocalValidOnError,
    );

    await shouldEmitFailure(resource);
  });

  test('should invoke save local when the remote fetch was successful', () async {
    final test = SaveLocalTest();
    final resource = TestNetworkBoundResource(
      saveLocal: test.invoke,
      isLocalValid: isLocalValid,
      isLocalValidOnError: isLocalValidOnError,
    );

    await resource.future;

    await shouldInvokeSaveLocal(test, resource);
  });

  test('should not invoke save local when the remote fetch was not successful', () async {
    final test = SaveLocalTest();
    final resource = TestNetworkBoundResource(
      fetchRemote: defaultFetchRemoteFailure,
      saveLocal: test.invoke,
      isLocalValid: isLocalValid,
      isLocalValidOnError: isLocalValidOnError,
    );

    await resource.future;

    await shouldNotInvokeSaveLocal(test, resource);
  });
}

void main() {
  group('localValid: false, localValidOnError: false,', () {
    group('local fetch not successful,', defaultRemoteFetchTest);

    group('local fetch successful,', () {
      test('should return the remote result when the remote fetch was successful', () async {
        final resource = TestNetworkBoundResource(fetchLocal: defaultFetchLocalSuccess);

        await shouldReturnRemote(resource);
      });

      test('should return an error when the remote fetch was not successful', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          fetchRemote: defaultFetchRemoteFailure,
        );

        await shouldReturnRemoteFailure(resource);
      });

      test('should emit loading first', () async {
        final resource = TestNetworkBoundResource(fetchLocal: defaultFetchLocalSuccess);

        await shouldEmitLoading(resource);
      });

      test('should emit loading first with local value', () async {
        final resource = TestNetworkBoundResource(fetchLocal: defaultFetchLocalSuccess);

        await shouldEmitLoadingWithLocal(resource);
      });

      test('should emit the remote result when the remote fetch was successful', () async {
        final resource = TestNetworkBoundResource(fetchLocal: defaultFetchLocalSuccess);

        await shouldEmitRemote(resource);
      });

      test('should emit an error when the remote fetch was not successful', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          fetchRemote: defaultFetchRemoteFailure,
        );

        await shouldEmitFailure(resource);
      });

      test('should invoke save local when the remote fetch was successful', () async {
        final test = SaveLocalTest();
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          saveLocal: test.invoke,
        );

        await resource.future;

        await shouldInvokeSaveLocal(test, resource);
      });
    });
  });

  group('localValid: false, localValidOnError: true,', () {
    group('local fetch not successful,', () => defaultRemoteFetchTest(isLocalValidOnError: true));

    group('local fetch successful,', () {
      test('should return the remote result when the remote fetch was successful', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          isLocalValidOnError: true,
        );

        await shouldReturnRemote(resource);
      });

      test('should return the local result when the remote fetch was not successful', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          fetchRemote: defaultFetchRemoteFailure,
          isLocalValidOnError: true,
        );

        await shouldReturnLocal(resource);
      });

      test('should emit loading first', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          isLocalValidOnError: true,
        );

        await shouldEmitLoading(resource);
      });

      test('should emit loading first with local value', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          isLocalValidOnError: true,
        );

        await shouldEmitLoadingWithLocal(resource);
      });

      test('should emit the remote result when the remote fetch was successful', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          isLocalValidOnError: true,
        );

        await shouldEmitRemote(resource);
      });

      test('should emit the local result when the remote fetch was not successful', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          fetchRemote: defaultFetchRemoteFailure,
          isLocalValidOnError: true,
        );

        await shouldEmitLocal(resource);
      });

      test('should invoke save local when the remote fetch was successful', () async {
        final test = SaveLocalTest();
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          saveLocal: test.invoke,
          isLocalValidOnError: true,
        );

        await resource.future;

        await shouldInvokeSaveLocal(test, resource);
      });

      test('should not invoke save local when the remote fetch was not successful', () async {
        final test = SaveLocalTest();
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          fetchRemote: defaultFetchRemoteFailure,
          saveLocal: test.invoke,
          isLocalValidOnError: true,
        );

        await resource.future;

        await shouldNotInvokeSaveLocal(test, resource);
      });
    });
  });

  group('localValid: true, localValidOnError: true,', () {
    group('local fetch not successful,', () => defaultRemoteFetchTest(isLocalValid: true, isLocalValidOnError: true));

    group('local fetch successful,', () {
      test('should return the local result when the remote fetch was successful', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          isLocalValid: true,
          isLocalValidOnError: true,
        );

        await shouldReturnLocal(resource);
      });

      test('should return the local result when the remote fetch was not successful', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          fetchRemote: defaultFetchRemoteFailure,
          isLocalValid: true,
          isLocalValidOnError: true,
        );

        await shouldReturnLocal(resource);
      });

      test('should emit loading first', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          isLocalValid: true,
          isLocalValidOnError: true,
        );

        await shouldEmitLoading(resource);
      });

      test('should emit the local result when the remote fetch was successful', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          isLocalValid: true,
          isLocalValidOnError: true,
        );

        await shouldEmitLocal(resource);
      });

      test('should emit the local result when the remote fetch was not successful', () async {
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          fetchRemote: defaultFetchRemoteFailure,
          isLocalValid: true,
          isLocalValidOnError: true,
        );

        await shouldEmitLocal(resource);
      });

      test('should not invoke save local when the remote fetch was successful', () async {
        final test = SaveLocalTest();
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          saveLocal: test.invoke,
          isLocalValid: true,
          isLocalValidOnError: true,
        );

        await resource.future;

        await shouldNotInvokeSaveLocal(test, resource);
      });

      test('should not invoke save local when the remote fetch was not successful', () async {
        final test = SaveLocalTest();
        final resource = TestNetworkBoundResource(
          fetchLocal: defaultFetchLocalSuccess,
          saveLocal: test.invoke,
          isLocalValid: true,
          isLocalValidOnError: true,
        );

        await resource.future;

        await shouldNotInvokeSaveLocal(test, resource);
      });
    });
  });
}
