import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../utils/extensions.dart';

part 'dynamic_content_loader_container.dart';
part 'dynamic_content_loader_content.dart';
part 'dynamic_content_loader_context.dart';

const _defaultContainerSize = 200;
const _defaultPivotIndex = 0;
const _defaultAllowDeletion = false;

typedef LoadFunction<T> = FutureOr<Stream<Iterable<Content<T>>>> Function(
  LoadContext<T> context,
  int startIndex,
  int endIndex,
);

/// The direction in which the [DynamicContentLoader] should load elements.
enum LoadDirection {
  /// Increases the index to load more elements.
  plus,

  /// Decreases the index to load more elements.
  minus,
}

/// Loads content dynamically from a source.
///
/// The content is loaded when explicitly request to be loaded with [loadContent]
/// or automatically when [watchDirection] or [prefetchDirection] is set. Content
/// is loaded with the [load] function. To use a list as a source use the
/// [DynamicContentLoader.overSource] constructor.
class DynamicContentLoader<T> with ChangeNotifier {
  /// When a request is issued for new content, this many elements will be
  /// requested at once.
  final int containerSize;

  /// This index will be used as a pivot. The initial fetch will include
  /// this index.
  ///
  /// Must be aligned with the container size.
  final int pivotIndex;

  /// If this is set to a direction, new content in this direction will be loaded
  /// automatically.
  ///
  /// Cannot be set to the same direction as [prefetchDirection].
  final LoadDirection? watchDirection;

  /// If an element in the last elements of the las container in that direction was
  /// request. A [loadContent] request will be issued automatically.
  ///
  /// Cannot be set to the same direction as [watchDirection].
  final LoadDirection? prefetchDirection;

  /// This function is invoked to load a block of content.
  ///
  /// The stream should emit a new value when the underlying content changed.
  /// Bot [startIndex] and [endIndex] are inclusive.
  final LoadFunction<T> load;

  /// If the loader was created over a source this subscriptions is set to the
  /// source subscription.
  final StreamSubscription? _sourceSubscription;

  /// If true, elements that are not included on an update are removed from the
  /// container. If false, elements cannot be removed any more and will be kept
  /// regardless if they appear again in an update or not.
  final bool allowDeletion;

  final Map<int, Container<T>> _containers;

  late Future<bool> _initFuture;

  bool _disposed;

  DynamicContentLoader._({
    required this.load,
    this.allowDeletion = _defaultAllowDeletion,
    this.containerSize = _defaultContainerSize,
    this.pivotIndex = _defaultPivotIndex,
    this.watchDirection,
    this.prefetchDirection,
    StreamSubscription? sourceSubscription,
  })  : _containers = {},
        _sourceSubscription = sourceSubscription,
        _disposed = false,
        assert(pivotIndex % containerSize == 0, 'The pivot index must be aligned with the container size'),
        assert(watchDirection == null || watchDirection != prefetchDirection),
        assert(prefetchDirection == null || prefetchDirection != watchDirection) {
    _initFuture = _loadContainer(null, pivotIndex);
  }

  /// Creates a new loader instance and loads the container at the pivot index.
  DynamicContentLoader({
    required LoadFunction<T> load,
    int containerSize = _defaultContainerSize,
    int pivotIndex = _defaultPivotIndex,
    bool allowDeletion = true,
    LoadDirection? watchDirection,
    LoadDirection? prefetchDirection,
  }) : this._(
          load: load,
          containerSize: containerSize,
          pivotIndex: pivotIndex,
          allowDeletion: allowDeletion,
          watchDirection: watchDirection,
          prefetchDirection: prefetchDirection,
        );

  /// Creates a new loader instance over a specified source.
  ///
  /// If the source stream is update all containers will be informed about the
  /// change. But a static source (e.g. Stream.value([...])) is also valid.
  factory DynamicContentLoader.overSource(
    Stream<Iterable<Content<T>>> source, {
    int containerSize = _defaultContainerSize,
    int pivotIndex = _defaultPivotIndex,
    bool allowDeletion = false,
    LoadDirection? watchDirection,
    LoadDirection? prefetchDirection,
  }) {
    final replay = source.publishReplay(maxSize: 1);
    final subscription = replay.connect();

    Stream<Iterable<Content<T>>> loadFunction(LoadContext<T> _, int startIndex, int endIndex) {
      return replay.map((event) => event.where((element) => element.index >= startIndex && element.index <= endIndex));
    }

    return DynamicContentLoader<T>._(
      load: loadFunction,
      containerSize: containerSize,
      pivotIndex: pivotIndex,
      prefetchDirection: prefetchDirection,
      watchDirection: watchDirection,
      sourceSubscription: subscription,
      allowDeletion: allowDeletion,
    );
  }

  Container<T>? _containerMin(Container<T>? a, Container<T> b) {
    if (a == null) return b;

    return a.startIndex < b.startIndex ? a : b;
  }

  Container<T>? get _startContainer => _containers.values.fold(null, _containerMin);

  Container<T>? get _notEmptyStartContainer => _containers.values.where((e) => !e.isEmpty).fold(null, _containerMin);

  Container<T> _containerMax(Container<T>? a, Container<T> b) {
    if (a == null) return b;

    return a.startIndex > b.startIndex ? a : b;
  }

  Container<T>? get _endContainer => _containers.values.fold(null, _containerMax);

  Container<T>? get _notEmptyEndContainer => _containers.values.where((e) => !e.isEmpty).fold(null, _containerMax);

  int get length {
    final start = _startContainer;
    final end = _endContainer;

    if (start == null || end == null) {
      return 0;
    }

    if (start == end) {
      return start.length;
    } else {
      return start.length + (end.startIndex - start.endIndex - 1) + end.length;
    }
  }

  /// The amount of containers currently used by this loader.
  int get containerCount => _containers.length;

  /// The actual start index (inclusive).
  ///
  /// If no element was loaded before this will be equal to the [pivotIndex].
  int get startIndex => _notEmptyStartContainer?.actualStartIndex ?? pivotIndex;

  /// The actual start endIndex (inclusive).
  ///
  /// If no element was loaded before this will be equal to the [pivotIndex].
  int get endIndex => _notEmptyEndContainer?.actualEndIndex ?? pivotIndex;

  /// This future is set to the initFuture of the last loaded container.
  ///
  /// After the loader was created this future will return when the first
  /// container received its first update.
  /// The value will be true if the first update for the container fills it
  /// complete and false if it was not full.
  Future<bool> get initFuture => _initFuture;

  bool get isDisposed => _disposed;

  /// Retrieves an element from the loader.
  ///
  /// If [prefetchDirection] is set this could trigger a content load.
  T? operator [](int index) {
    assert(!_disposed, 'This cannot be used after disposed was called');

    _prefetch(index);

    final containerIndex = _containerIndex(index);
    final container = _containers[containerIndex];

    return container?[index]?.value;
  }

  void _prefetch(int index) {
    switch (prefetchDirection) {
      case LoadDirection.plus:
        final end = _endContainer!;

        if (end.isFullInDirection(LoadDirection.plus) && index > end.endIndex - 3) {
          _loadContainer(end, end.endIndex + 1);
        }
        break;
      case LoadDirection.minus:
        final start = _startContainer!;

        if (start.isFullInDirection(LoadDirection.minus) && index < start.startIndex + 3) {
          _loadContainer(start, start.startIndex - containerSize);
        }
        break;
      default:
    }
  }

  int _containerIndex(int index) {
    return (index / containerSize).floor();
  }

  Future<bool> _loadContainer(Container<T>? precedingContainer, int startIndex) {
    assert(startIndex % containerSize == 0, 'The start index must be aligned with the container size');

    final endIndex = startIndex + containerSize - 1;
    final containerIndex = _containerIndex(startIndex);

    final LoadContext<T> context;
    if (precedingContainer == null) {
      context = LoadContext<T>.empty();
    } else {
      final LoadDirection direction;
      if (precedingContainer.startIndex < startIndex) {
        direction = LoadDirection.plus;
      } else {
        direction = LoadDirection.minus;
      }

      final T? precedingValue;
      switch (direction) {
        case LoadDirection.plus:
          precedingValue = precedingContainer.actualEndIndex.let((i) => precedingContainer[i]?.value);
          break;
        case LoadDirection.minus:
          precedingValue = precedingContainer.actualStartIndex.let((i) => precedingContainer[i]?.value);
          break;
      }

      context = LoadContext(precedingValue: precedingValue, direction: direction);
    }

    final container = Container<T>(
      load(context, startIndex, endIndex),
      startIndex: startIndex,
      endIndex: endIndex,
      allowDeletion: allowDeletion,
      onChange: _onContainerUpdate,
    );

    assert(
      _containers[containerIndex] == null,
      'There should be no container present when trying to load a new with the same range, index: $startIndex',
    );
    _containers[containerIndex] = container;

    return container.initFuture;
  }

  void _watchPlus(int startIndex, int endIndex) {
    final end = _endContainer!;
    if (end.startIndex != startIndex) {
      return;
    }

    if (end.isFullInDirection(LoadDirection.plus)) {
      _loadContainer(end, end.endIndex + 1);
    }
  }

  void _watchMinus(int startIndex, int endIndex) {
    final start = _startContainer!;
    if (start.startIndex != startIndex) {
      return;
    }

    if (start.isFullInDirection(LoadDirection.minus)) {
      _loadContainer(start, start.startIndex - containerSize);
    }
  }

  void _onContainerUpdate(int startIndex, int endIndex) {
    notifyListeners();

    switch (watchDirection) {
      case LoadDirection.plus:
        _watchPlus(startIndex, endIndex);
        break;
      case LoadDirection.minus:
        _watchMinus(startIndex, endIndex);
        break;
      default:
    }
  }

  /// Loads new content in a specified direction.
  ///
  /// If the container in this direction is not full no more content will be
  /// false is returned. If the container is full the next container will be
  /// created and if the container is full on initial load true will be returned.
  Future<bool> loadContent(LoadDirection direction, {Duration timeout = const Duration(seconds: 5)}) async {
    assert(!_disposed, 'This cannot be used after disposed was called');

    await _initFuture;

    if (containerCount == 0) {
      _initFuture = _loadContainer(null, pivotIndex);
      return _initFuture;
    }

    final int containerStartIndex;
    final Container<T> precedingContainer;

    switch (direction) {
      case LoadDirection.plus:
        final end = _endContainer!;
        await end.initFuture.timeout(timeout);

        if (!end.isFullInDirection(LoadDirection.plus)) {
          return false;
        }

        containerStartIndex = end.endIndex + 1;
        precedingContainer = end;
        break;
      case LoadDirection.minus:
        final start = _startContainer!;
        await start.initFuture.timeout(timeout);

        if (!start.isFullInDirection(LoadDirection.minus)) {
          return false;
        }

        containerStartIndex = start.startIndex - containerSize;
        precedingContainer = start;
        break;
    }

    return _loadContainer(precedingContainer, containerStartIndex).timeout(timeout, onTimeout: () => false);
  }

  /// Resets the loader.
  ///
  /// All currently stored content will be disposed and removed. The container
  /// at the [pivotIndex] will be loaded again automatically and the initFuture
  /// of this container will be returned.
  Future<bool> reset() {
    assert(!_disposed, 'This cannot be used after disposed was called');

    for (final container in _containers.values) {
      container.dispose();
    }
    _containers.clear();

    _initFuture = _loadContainer(null, pivotIndex);
    return _initFuture;
  }

  bool isFullInDirection(LoadDirection direction) {
    switch (direction) {
      case LoadDirection.plus:
        return _endContainer?.isFullInDirection(LoadDirection.plus) == true;
      case LoadDirection.minus:
        return _startContainer?.isFullInDirection(LoadDirection.minus) == true;
    }
  }

  /// Disposes all currently stored content.
  @override
  void dispose() {
    assert(!_disposed, 'This cannot be used after disposed was called');
    _disposed = true;

    super.dispose();

    for (final container in _containers.values) {
      container.dispose();
    }
    _containers.clear();

    _sourceSubscription?.cancel();
  }
}
