/// Helper class to pass objects by reference.
class RefBox<T> {
  bool _accessed;
  T? _value;

  RefBox() : _accessed = false;

  /// Sets the value.
  ///
  /// Should be called by the receiving method.
  set value(T v) {
    _accessed = true;
    _value = v;
  }

  /// Sets the value, like [value].
  void operator <<(T value) => this.value = value;

  /// Returns the value.
  ///
  /// Assumes that the value has been set. Whether the value has been set can
  /// be check with [accessed]. It is not possible to "unset" a value.
  T get value => _value as T;

  /// Whether the a value has be set to this reference.
  ///
  /// Different values could been assigned to this reference, thus this only
  /// checks if any value was set.
  bool get accessed => _accessed;
}
