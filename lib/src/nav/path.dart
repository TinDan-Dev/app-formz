import 'package:equatable/equatable.dart';

List<String> _routeFromString(String str, bool mustBeAbsolute) {
  assert(!mustBeAbsolute || str.startsWith('/'));

  return str.split('/').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
}

class Path extends Equatable {
  static const root = Path.fromParts([]);

  final List<String> parts;

  const Path.fromParts(this.parts);

  Path(String path, [bool mustBeAbsolute = false]) : parts = _routeFromString(path, mustBeAbsolute);

  @override
  List<Object?> get props => parts;

  int get length => parts.length;

  bool isChild(Path? child) {
    if (child == null || child.parts.length <= parts.length) return false;

    for (var i = 0; i < parts.length; i++) {
      if (parts[i] != child.parts[i]) return false;
    }

    return true;
  }

  bool isChildPath(String? childPath) {
    if (childPath == null) return false;

    return isChild(Path(childPath));
  }

  bool operator <(Path? other) => isChild(other);

  bool operator <=(Path? other) => this == other || this < other;

  bool isParent(Path? parent) {
    if (parent == null || parent.parts.length >= parts.length) return false;

    for (var i = 0; i < parent.parts.length; i++) {
      if (parts[i] != parent.parts[i]) return false;
    }

    return true;
  }

  bool isParentPath(String? parentPath) {
    if (parentPath == null) return false;

    return isParent(Path(parentPath));
  }

  bool operator >(Path? other) => isParent(other);

  bool operator >=(Path? other) => this == other || this > other;

  Path append(Path? other) {
    if (other == null) return this;

    return Path.fromParts(parts + other.parts);
  }

  Path operator /(Path? other) => append(other);

  @override
  String toString() => '/${parts.join('/')}';
}
