part of 'dynamic_content_loader.dart';

class LoadContext<T> {
  final T? precedingValue;
  final LoadDirection? direction;

  const LoadContext({
    required this.precedingValue,
    required this.direction,
  });

  const LoadContext.empty()
      : direction = null,
        precedingValue = null;
}
