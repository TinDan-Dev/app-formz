/// Helper class to pass objects by reference.
class ReferenceBox<T> {
  T? _value;

  /// Sets the value.
  ///
  /// Should be called by the receiving method.
  set value(T v) => _value = v;

  /// Returns the value.
  ///
  /// Assumes that the value has been set. Whether the value has been set can
  /// be check with [accessed]. It is not possible to "unset" a value.
  T get value => _value!;

  /// Whether the a value has be set to this reference.
  ///
  /// Different values could been assigned to this reference, thus this only
  /// checks if any value was set.
  bool get accessed => _value != null;
}
