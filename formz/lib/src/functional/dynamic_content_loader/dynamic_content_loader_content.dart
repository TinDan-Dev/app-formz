part of 'dynamic_content_loader.dart';

/// Represents one content element.
///
/// Has an [index] to uniquely identify this content element and a [hash] to
/// determine if the content needs to be converted again.
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
