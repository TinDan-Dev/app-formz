part of 'content_loader.dart';

/// Represents one content element.
class Content<T> extends Equatable {
  /// The index of the content.
  final int index;

  /// The value associated with the index
  final T value;

  const Content({
    required this.index,
    required this.value,
  });

  @override
  List<Object?> get props => [index, value];
}
