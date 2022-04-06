import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/src/functional/dynamic_content_loader/dynamic_content_loader.dart';
import 'package:mockito/mockito.dart';

Content<int> content(int i) => Content(index: i, value: i);

Iterable<Content<int>> createContent(int startIndex, int endIndex) sync* {
  for (int i = startIndex; i <= endIndex; i++) {
    yield Content(index: i, value: i);
  }
}

class MockSource extends Mock {
  Stream<List<Content<int>>> load(int? startIndex, int? endIndex) {
    return super.noSuchMethod(
      Invocation.method(#load, [startIndex, endIndex]),
      returnValue: const Stream<List<Content<int>>>.empty(),
    );
  }

  void notify() {
    super.noSuchMethod(Invocation.method(#notify, []));
  }
}

void main() {
  late MockSource mockSource;

  void setLoadSuccessful() {
    when(mockSource.load(any, any)).thenAnswer((invocation) {
      final int startIndex = invocation.positionalArguments[0];
      final int endIndex = invocation.positionalArguments[1];

      return Stream<List<Content<int>>>.value(createContent(startIndex, endIndex).toList());
    });
  }

  void setLoadUnsuccessful() {
    when(mockSource.load(any, any)).thenAnswer((_) {
      return Stream<List<Content<int>>>.value([]);
    });
  }

  StreamController<List<Content<int>>> setLoadToController(int startIndex, int endIndex) {
    final controller = StreamController<List<Content<int>>>();

    when(mockSource.load(startIndex, endIndex)).thenAnswer((_) {
      return controller.stream;
    });

    return controller;
  }

  setUp(() {
    mockSource = MockSource();

    setLoadSuccessful();
  });

  DynamicContentLoader<int> createLoader({
    int containerSize = 200,
    int pivotIndex = 0,
    LoadDirection? watchDirection,
    LoadDirection? prefetchDirection,
  }) {
    final loader = DynamicContentLoader<int>(
      load: (_, startIndex, endIndex) => mockSource.load(startIndex, endIndex),
      containerSize: containerSize,
      pivotIndex: pivotIndex,
      watchDirection: watchDirection,
      prefetchDirection: prefetchDirection,
    );

    loader.addListener(() => mockSource.notify());
    return loader;
  }

  test('should load the first container when created', () {
    createLoader();

    verify(mockSource.load(0, 199));
  });

  test('should load the first container at pivot when created', () {
    createLoader(pivotIndex: 400);

    verify(mockSource.load(400, 599));
  });

  test('should error when the pivot is not aligned with the container size', () {
    expect(() => createLoader(pivotIndex: 3), throwsA(isAssertionError));
  });

  test('length should be 0 when created', () {
    final loader = createLoader();
    expect(loader.length, equals(0));
  });

  test('containerCount should be 1 created', () {
    final loader = createLoader();
    expect(loader.containerCount, equals(1));
  });

  test('startIndex should be equal to the pivot when created', () {
    final loader = createLoader(pivotIndex: 400);

    expect(loader.startIndex, equals(400));
  });

  test('endIndex should be equal to the pivot when created', () {
    final loader = createLoader(pivotIndex: 400);

    expect(loader.endIndex, equals(400));
  });

  test('initFuture should return true when initialized successfully', () async {
    final loader = createLoader();

    expect(await loader.initFuture, isTrue);
  });

  test('initFuture should return false when not initialized successfully', () async {
    setLoadUnsuccessful();
    final loader = createLoader();

    expect(await loader.initFuture, isFalse);
  });

  test('should error when prefetchDirection equals watchDirection', () {
    expect(
      () => createLoader(prefetchDirection: LoadDirection.plus, watchDirection: LoadDirection.plus),
      throwsA(isAssertionError),
    );
    expect(
      () => createLoader(prefetchDirection: LoadDirection.minus, watchDirection: LoadDirection.minus),
      throwsA(isAssertionError),
    );
  });

  group('first container contains 200/200', () {
    test('length should be equal to the length of the first container when added', () async {
      final loader = createLoader();
      expect(loader.length, equals(0));

      await loader.initFuture;
      expect(loader.length, equals(200));
    });

    test('startIndex should be equal to the pivot when the first container was added', () async {
      final loader = createLoader(pivotIndex: 400);
      expect(loader.startIndex, equals(400));

      await loader.initFuture;
      expect(loader.startIndex, equals(400));
    });

    test('endIndex should be equal to the actual endIndex of the first container when added', () async {
      final loader = createLoader(pivotIndex: 400);
      expect(loader.endIndex, equals(400));

      await loader.initFuture;
      expect(loader.endIndex, equals(599));
    });
  });

  group('first container contains 200/200 + 1', () {
    setUp(() {
      when(mockSource.load(any, any)).thenAnswer((invocation) {
        final int startIndex = invocation.positionalArguments[0];
        final int endIndex = invocation.positionalArguments[1];

        if (startIndex < 200) {
          return Stream.value(createContent(startIndex, endIndex).toList());
        } else {
          return Stream.value(createContent(startIndex, startIndex).toList());
        }
      });
    });

    test('length should be equal to the length of the first container + 1 when added', () async {
      final loader = createLoader();
      expect(loader.length, equals(0));

      await loader.initFuture;
      expect(loader.length, equals(200));

      await loader.loadContent(LoadDirection.plus);
      expect(loader.length, equals(201));
    });

    test('endIndex should be equal to the actual endIndex of the first container when added', () async {
      final loader = createLoader();
      expect(loader.endIndex, equals(0));

      await loader.initFuture;
      expect(loader.endIndex, equals(199));

      await loader.loadContent(LoadDirection.plus);
      expect(loader.endIndex, equals(200));
    });
  });

  group('first container contains 200/200 + 0', () {
    setUp(() {
      when(mockSource.load(any, any)).thenAnswer((invocation) {
        final int startIndex = invocation.positionalArguments[0];
        final int endIndex = invocation.positionalArguments[1];

        if (startIndex < 200) {
          return Stream.value(createContent(startIndex, endIndex).toList());
        } else {
          return const Stream.empty();
        }
      });
    });

    test('length should be equal to the length of the first container when added', () async {
      final loader = createLoader();
      expect(loader.length, equals(0));

      await loader.initFuture;
      expect(loader.length, equals(200));

      await loader.loadContent(LoadDirection.plus);
      expect(loader.length, equals(200));
    });

    test('endIndex should be equal to the actual endIndex of the first container when added', () async {
      final loader = createLoader();
      expect(loader.endIndex, equals(0));

      await loader.initFuture;
      expect(loader.endIndex, equals(199));

      await loader.loadContent(LoadDirection.plus);
      expect(loader.endIndex, equals(199));
    });
  });

  group('first container contains  50/200', () {
    setUp(() {
      when(mockSource.load(any, any)).thenAnswer((invocation) {
        final int startIndex = invocation.positionalArguments[0];
        final int endIndex = invocation.positionalArguments[1];

        return Stream.value(createContent(startIndex, startIndex + ((endIndex - startIndex) ~/ 4)).toList());
      });
    });

    test('length should be equal to the length of the first container when added', () async {
      final loader = createLoader();
      expect(loader.length, equals(0));

      await loader.initFuture;
      expect(loader.length, equals(50));
    });

    test('startIndex should be equal to the pivot when the first container was added', () async {
      final loader = createLoader(pivotIndex: 400);
      expect(loader.startIndex, equals(400));

      await loader.initFuture;
      expect(loader.startIndex, equals(400));
    });

    test('endIndex should be equal to the actual endIndex of the first container when added', () async {
      final loader = createLoader(pivotIndex: 400);
      expect(loader.endIndex, equals(400));

      await loader.initFuture;
      expect(loader.endIndex, equals(449));
    });
  });

  group('first container contains   0/200', () {
    setUp(() {
      when(mockSource.load(any, any)).thenAnswer((invocation) {
        return Stream.value(<Content<int>>[]);
      });
    });

    test('length should be equal to the length of the first container when added', () async {
      final loader = createLoader();
      expect(loader.length, equals(0));

      await loader.initFuture;
      expect(loader.length, equals(0));
    });

    test('startIndex should be equal to the pivot when the first container was added', () async {
      final loader = createLoader(pivotIndex: 400);
      expect(loader.startIndex, equals(400));

      await loader.initFuture;
      expect(loader.startIndex, equals(400));
    });

    test('endIndex should be equal to the actual endIndex of the first container when added', () async {
      final loader = createLoader(pivotIndex: 400);
      expect(loader.endIndex, equals(400));

      await loader.initFuture;
      expect(loader.endIndex, equals(400));
    });
  });

  group('loadContent', () {
    group('direction plus', () {
      test('should load content after the first container was added', () async {
        final loader = createLoader();
        verify(mockSource.load(0, 199));

        final result = await loader.loadContent(LoadDirection.plus);

        expect(result, isTrue);
        verify(mockSource.load(200, 399));

        verifyNever(mockSource.load(any, any));
      });

      test('should load container at pivot again when the first container failed', () async {
        setLoadUnsuccessful();

        final loader = createLoader();
        verify(mockSource.load(0, 199));

        final result = await loader.loadContent(LoadDirection.plus);

        expect(result, isFalse);
        verifyNever(mockSource.load(any, any));
      });

      test('should not load next container when previous max container is not fill in plus direction', () async {
        final loader = createLoader();
        verify(mockSource.load(0, 199));

        when(mockSource.load(200, 399)).thenAnswer((_) {
          return Stream.value(createContent(200, 398).toList());
        });

        final firstResult = await loader.loadContent(LoadDirection.plus);

        expect(firstResult, isFalse);
        verify(mockSource.load(200, 399));

        final secondResult = await loader.loadContent(LoadDirection.plus);

        expect(secondResult, isFalse);
        verifyNever(mockSource.load(any, any));
      });
    });

    group('direction minus', () {
      test('should load content after the first container was added', () async {
        final loader = createLoader();
        verify(mockSource.load(0, 199));

        final result = await loader.loadContent(LoadDirection.minus);

        expect(result, isTrue);
        verify(mockSource.load(-200, -1));

        verifyNever(mockSource.load(any, any));
      });

      test('should load container at pivot again when the first container failed', () async {
        setLoadUnsuccessful();

        final loader = createLoader();
        verify(mockSource.load(0, 199));

        final result = await loader.loadContent(LoadDirection.minus);

        expect(result, isFalse);
        verifyNever(mockSource.load(any, any));
      });

      test('should not load next container when previous max container is not fill in minus direction', () async {
        final loader = createLoader();
        verify(mockSource.load(0, 199));

        when(mockSource.load(-200, -1)).thenAnswer((_) {
          return Stream.value(createContent(-199, -1).toList());
        });

        final firstResult = await loader.loadContent(LoadDirection.minus);

        expect(firstResult, isFalse);
        verify(mockSource.load(-200, -1));

        final secondResult = await loader.loadContent(LoadDirection.minus);

        expect(secondResult, isFalse);
        verifyNever(mockSource.load(any, any));
      });
    });
  });

  group('notify listeners', () {
    test('should notify listeners when first container was added successfully', () async {
      createLoader();
      verifyNever(mockSource.notify());

      await Future.delayed(const Duration(milliseconds: 1));
      verify(mockSource.notify()).called(1);
    });

    test('should not notify listeners when first container was not added successfully', () async {
      setLoadUnsuccessful();
      createLoader();

      await Future.delayed(const Duration(milliseconds: 1));
      verifyNever(mockSource.notify());
    });

    test('should notify listeners when a new container was added successfully', () async {
      final loader = createLoader();

      await Future.delayed(const Duration(milliseconds: 1));
      verify(mockSource.notify()).called(1);

      await loader.loadContent(LoadDirection.plus);
      verify(mockSource.notify()).called(1);
    });

    test('should not notify listeners when a new container was added not successfully', () async {
      final loader = createLoader();

      await Future.delayed(const Duration(milliseconds: 1));
      verify(mockSource.notify()).called(1);

      setLoadUnsuccessful();

      await loader.loadContent(LoadDirection.plus);
      verifyNever(mockSource.notify());
    });

    test('should notify listeners when a container received an update with different content', () async {
      final controller = setLoadToController(0, 199);
      createLoader();

      controller.add(const [Content<int>(index: 0, value: 1)]);
      await Future.delayed(const Duration(milliseconds: 1));

      verify(mockSource.notify()).called(1);

      controller.add([content(0), content(1)]);
      await Future.delayed(const Duration(milliseconds: 1));

      verify(mockSource.notify()).called(1);
    });

    test('should not notify listeners when a container received an update with the same content', () async {
      final controller = setLoadToController(0, 199);
      createLoader();

      controller.add(const [Content<int>(index: 0, value: 1)]);
      await Future.delayed(const Duration(milliseconds: 1));

      verify(mockSource.notify()).called(1);

      controller.add(const [Content<int>(index: 0, value: 1)]);
      await Future.delayed(const Duration(milliseconds: 1));

      verifyNever(mockSource.notify());
    });
  });

  group('get', () {
    test('should get element when present', () async {
      final loader = createLoader();
      await loader.initFuture;

      expect(loader[0], equals(0));
      expect(loader[199], equals(199));
    });

    test('should return null when element is not present', () async {
      final loader = createLoader();
      await loader.initFuture;

      expect(loader[-1], isNull);
      expect(loader[200], isNull);
    });

    group('added container plus', () {
      late DynamicContentLoader<int> loader;

      setUp(() async {
        loader = createLoader();
        await loader.loadContent(LoadDirection.plus);
      });

      test('should get element when present', () async {
        expect(loader[0], equals(0));
        expect(loader[199], equals(199));

        expect(loader[200], equals(200));
        expect(loader[399], equals(399));
      });

      test('should return null when element is not present', () async {
        final loader = createLoader();
        await loader.initFuture;

        expect(loader[-1], isNull);
        expect(loader[400], isNull);
      });
    });

    group('added container minus', () {
      late DynamicContentLoader<int> loader;

      setUp(() async {
        loader = createLoader();
        await loader.loadContent(LoadDirection.minus);
      });

      test('should get element when present', () async {
        expect(loader[0], equals(0));
        expect(loader[199], equals(199));

        expect(loader[-1], equals(-1));
        expect(loader[-200], equals(-200));
      });

      test('should return null when element is not present', () async {
        final loader = createLoader();
        await loader.initFuture;

        expect(loader[-201], isNull);
        expect(loader[200], isNull);
      });
    });
  });

  group('watch', () {
    group('direction plus', () {
      late DynamicContentLoader<int> loader;
      late StreamController<List<Content>> controller;

      setUp(() async {
        controller = setLoadToController(0, 199);
        loader = createLoader(watchDirection: LoadDirection.plus);

        controller.add(createContent(1, 198).toList());
        await loader.initFuture;

        verify(mockSource.load(0, 199));
      });

      test('should add container when last container is full in plus direction', () async {
        controller.add(createContent(1, 199).toList());
        setLoadUnsuccessful();

        await Future.delayed(const Duration(milliseconds: 1));
        verify(mockSource.load(200, 399));
      });

      test('should not add container when last container is not full in plus direction', () async {
        controller.add(createContent(0, 198).toList());
        setLoadUnsuccessful();

        await Future.delayed(const Duration(milliseconds: 1));
        verifyNever(mockSource.load(any, any));
      });
    });

    group('direction minus', () {
      late DynamicContentLoader<int> loader;
      late StreamController<List<Content>> controller;

      setUp(() async {
        controller = setLoadToController(0, 199);
        loader = createLoader(watchDirection: LoadDirection.minus);

        controller.add(createContent(1, 198).toList());
        await loader.initFuture;

        verify(mockSource.load(0, 199));
      });
      test('should add container when last container is full in minus direction', () async {
        controller.add(createContent(0, 198).toList());
        setLoadUnsuccessful();

        await Future.delayed(const Duration(milliseconds: 1));
        verify(mockSource.load(-200, -1));
      });

      test('should not add container when last container is not full in minus direction', () async {
        controller.add(createContent(1, 199).toList());
        setLoadUnsuccessful();

        await Future.delayed(const Duration(milliseconds: 1));
        verifyNever(mockSource.load(any, any));
      });
    });
  });

  group('prefetch', () {
    group('direction plus', () {
      late DynamicContentLoader<int> loader;
      late StreamController<List<Content>> controller;

      setUp(() async {
        controller = setLoadToController(0, 199);
        loader = createLoader(prefetchDirection: LoadDirection.plus);

        verify(mockSource.load(0, 199));
      });

      test('should add container when last container is full in plus direction and request is in range', () async {
        controller.add(createContent(0, 199).toList());
        await loader.initFuture;

        loader[197];
        await Future.delayed(const Duration(milliseconds: 1));
        verify(mockSource.load(200, 399));
      });

      test('should not add container when last container is not full in plus direction and request is in range',
          () async {
        controller.add(createContent(0, 198).toList());
        await loader.initFuture;

        loader[199];
        await Future.delayed(const Duration(milliseconds: 1));
        verifyNever(mockSource.load(any, any));
      });

      test('should not add container when last container is full in plus direction and request is not in range',
          () async {
        controller.add(createContent(0, 199).toList());
        await loader.initFuture;

        loader[196];
        await Future.delayed(const Duration(milliseconds: 1));
        verifyNever(mockSource.load(any, any));
      });

      test('should not load in other direction', () async {
        controller.add(createContent(0, 199).toList());
        await loader.initFuture;

        loader[0];
        await Future.delayed(const Duration(milliseconds: 1));
        verifyNever(mockSource.load(any, any));
      });

      test('should only load once when two prefetch accesses where issued', () async {
        controller.add(createContent(0, 199).toList());
        await loader.initFuture;

        loader[198];
        loader[199];
        await Future.delayed(const Duration(milliseconds: 1));
        verify(mockSource.load(200, 399)).called(1);
      });
    });

    group('direction minus', () {
      late DynamicContentLoader<int> loader;
      late StreamController<List<Content>> controller;

      setUp(() async {
        controller = setLoadToController(0, 199);
        loader = createLoader(prefetchDirection: LoadDirection.minus);

        verify(mockSource.load(0, 199));
      });

      test('should add container when last container is full in plus direction and request is in range', () async {
        controller.add(createContent(0, 199).toList());
        await loader.initFuture;

        loader[2];
        await Future.delayed(const Duration(milliseconds: 1));
        verify(mockSource.load(-200, -1));
      });

      test('should not add container when last container is not full in plus direction and request is in range',
          () async {
        controller.add(createContent(1, 199).toList());
        await loader.initFuture;

        loader[0];
        await Future.delayed(const Duration(milliseconds: 1));
        verifyNever(mockSource.load(any, any));
      });

      test('should not add container when last container is full in plus direction and request is not in range',
          () async {
        controller.add(createContent(0, 199).toList());
        await loader.initFuture;

        loader[3];
        await Future.delayed(const Duration(milliseconds: 1));
        verifyNever(mockSource.load(any, any));
      });

      test('should not load in other direction', () async {
        controller.add(createContent(0, 199).toList());
        await loader.initFuture;

        loader[199];
        await Future.delayed(const Duration(milliseconds: 1));
        verifyNever(mockSource.load(any, any));
      });
    });
  });

  group('reset', () {
    late DynamicContentLoader<int> loader;

    setUp(() async {
      loader = createLoader(prefetchDirection: LoadDirection.plus);
      await loader.initFuture;

      await loader.loadContent(LoadDirection.plus);

      verify(mockSource.load(0, 199));
      verify(mockSource.load(200, 399));

      setLoadUnsuccessful();
    });

    test('should set containerCount back to 1', () async {
      expect(loader.containerCount, equals(2));

      await loader.reset();

      expect(loader.containerCount, equals(1));
    });

    test('should set length back to 0', () async {
      expect(loader.length, equals(400));

      await loader.reset();

      expect(loader.length, equals(0));
    });

    test('should set start and end index back to pivotIndex', () async {
      expect(loader.startIndex, equals(0));
      expect(loader.endIndex, equals(399));

      await loader.reset();

      expect(loader.startIndex, equals(0));
      expect(loader.endIndex, equals(0));
    });

    test('should load container at pivotIndex', () async {
      await loader.reset();

      verify(mockSource.load(0, 199)).called(1);
      verifyNever(mockSource.load(any, any));
    });

    test('should return true when container at pivotIndex is full', () async {
      setLoadSuccessful();

      final result = await loader.reset();
      expect(result, isTrue);
    });

    test('should return false when container at pivotIndex is not full', () async {
      final result = await loader.reset();
      expect(result, isFalse);
    });
  });

  group('over source', () {
    late DynamicContentLoader<int> loader;
    late StreamController<Iterable<Content<int>>> sourceController;

    setUp(() {
      sourceController = StreamController();
      loader = DynamicContentLoader.overSource(
        sourceController.stream.asBroadcastStream(),
      );

      loader.addListener(() => mockSource.notify());
    });

    test('should notify listeners when source changes', () async {
      sourceController.add(createContent(0, 10));
      await loader.initFuture;

      verify(mockSource.notify()).called(1);

      sourceController.add(createContent(0, 11));
      await Future.delayed(const Duration(milliseconds: 1));

      verify(mockSource.notify()).called(1);
    });

    test('should not notify listeners when source updates but no content changed', () async {
      sourceController.add(createContent(0, 10));
      await loader.initFuture;

      verify(mockSource.notify()).called(1);

      sourceController.add(createContent(0, 10));
      await Future.delayed(const Duration(milliseconds: 1));

      verifyNever(mockSource.notify());
    });

    test('should return content form the source', () async {
      sourceController.add(createContent(0, 10));
      await loader.initFuture;

      expect(loader[0], equals(0));
      expect(loader[4], equals(4));
      expect(loader[11], isNull);
    });
  });
}
