part of 'content_loader.dart';

/// Keeps track of on content block.
class _Container<T> {
  /// The start index of the content block represented by this container. (inclusive)
  final int startIndex;

  /// The end index of the content block represented by this container. (inclusive)
  final int endIndex;

  /// This completer will be completed with true when the first stream event is full
  /// and false when not.
  final Completer<bool> _initCompleter;

  /// The change notifier function. Invoked when the content of this container
  /// changes. The [startIndex] and [endIndex] of this container will be used.
  final void Function(int startIndex, int endIndex) onChange;

  /// Whether elements from an previous updated should be kept if the don't appear
  /// in an update.
  final bool allowDeletion;

  /// The current content of this container.
  final Map<int, Content<T>> _currentContent;

  /// The subscription to the stream that sources this container.
  StreamSubscription<Iterable<Content<T>>>? _subscription;

  /// If this container was disposed.
  bool _disposed;

  _Container(
    FutureOr<Stream<Iterable<Content<T>>>> stream, {
    required this.onChange,
    required this.startIndex,
    required this.endIndex,
    required this.allowDeletion,
  })  : _disposed = false,
        _currentContent = {},
        _initCompleter = Completer() {
    _init(stream);
  }

  Future<void> _init(FutureOr<Stream<Iterable<Content<T>>>> stream) async {
    _subscription = (await stream).listen(_streamListener);
  }

  Future<bool> get initFuture => _initCompleter.future;

  int get length => _currentContent.length;

  bool get isFull => length > endIndex - startIndex;

  bool get isEmpty => _currentContent.isEmpty;

  bool get isLoading => !_initCompleter.isCompleted;

  int? get actualStartIndex => _currentContent.keys.fold(null, (previousValue, element) {
        if (previousValue == null) {
          return element;
        }

        return min(previousValue, element);
      });

  int? get actualEndIndex => _currentContent.keys.fold(null, (previousValue, element) {
        if (previousValue == null) {
          return element;
        }

        return max(previousValue, element);
      });

  bool isFullInDirection(LoadDirection direction) {
    switch (direction) {
      case LoadDirection.plus:
        return endIndex == actualEndIndex;
      case LoadDirection.minus:
        return startIndex == actualStartIndex;
    }
  }

  Future<void> _streamListener(Iterable<Content<T>> update) async {
    var dirty = false;

    // iterate over all updates and check if the current value is different, if
    // true mark as dirty and keep the new value, if not keep the old one
    final updatedEntries = <int, Content<T>>{};

    for (final entry in update) {
      final previousEntry = _currentContent.remove(entry.index);

      if (previousEntry == null || previousEntry.value != entry.value) {
        updatedEntries[entry.index] = entry;
        dirty = true;
      } else {
        updatedEntries[entry.index] = previousEntry;
      }
    }

    // if not updated entries should be deleted, clear the old map to get rid of
    // not updated entries
    if (allowDeletion) {
      dirty |= _currentContent.isNotEmpty;
      _currentContent.clear();
    }

    _currentContent.addAll(updatedEntries);

    if (!_initCompleter.isCompleted) {
      _initCompleter.complete(isFull);
    }

    // only emit on changed when the content actually changed
    if (dirty) {
      onChange(startIndex, endIndex);
    }
  }

  Content<T>? operator [](int index) {
    assert(index >= startIndex && index <= endIndex, 'Index not part of this container');
    assert(
      _currentContent[index] == null || _currentContent[index]?.index == index,
      'Content with index ${_currentContent[index]?.index} found at index $index',
    );

    return _currentContent[index];
  }

  /// Cancels the subscription for this container.
  void dispose() {
    assert(!_disposed, 'Cannot dispose a container twice');
    _disposed = true;

    if (!_initCompleter.isCompleted) {
      _initCompleter.complete(false);
    }

    _subscription?.cancel();
    _subscription = null;

    _currentContent.clear();
  }
}
