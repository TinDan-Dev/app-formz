abstract class Enum {
  /// This value's integer value.
  final int value;

  /// This value's name.
  final String name;

  /// Returns a new constant Enum using [value] and [name].
  const Enum(this.value, this.name);

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => value;

  /// Returns this enum's [name].
  @override
  String toString() => name;
}
