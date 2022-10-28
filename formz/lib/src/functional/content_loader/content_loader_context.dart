part of 'content_loader.dart';

/// A context object that is passed to the load function.
///
/// Contains some additional data of the container that should be loaded. If the
/// container is the first container, most of the data cannot be provided.
class LoadContext<T> {
  /// The closest value to this container.
  ///
  /// Retrieved from the preceding container, keep in mind when the container is
  /// prefetch some values could still be added to the previous container.
  final T? precedingValue;

  /// The direction in which the new container will be loaded.
  final LoadDirection direction;

  const LoadContext({
    required this.precedingValue,
    required this.direction,
  });
}

/// A context object that is passed to the update function.
///
/// This context can define a scope which this updates refers to, thus container
/// out side of this scope can ignore the update. If min and max are not present
/// the update is applied to all containers.
class UpdateContext<T> {
  /// The values of this update.
  final Iterable<Content<T>> values;

  /// Tha min index that this update refers to (inclusive).
  final int? min;

  /// Tha max index that this update refers to (inclusive).
  final int? max;

  UpdateContext.scoped(this.values, {required this.min, required this.max})
      : assert(min == null || max == null || min < max, 'Min must be smaller then max'),
        assert(
          max == null || values.every((e) => e.index <= max),
          'Update values contains an entry that violates the upper bounds',
        ),
        assert(
          min == null || values.every((e) => e.index >= min),
          'Update values contains an entry that violates the lower bounds',
        );

  UpdateContext(Iterable<Content<T>> values) : this.scoped(values, min: null, max: null);

  UpdateContext<S> map<S>(Iterable<Content<S>> mapper(Iterable<Content<T>> values)) =>
      UpdateContext<S>.scoped(mapper(values), min: min, max: max);
}
