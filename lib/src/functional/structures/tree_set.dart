import 'dart:collection';

import 'package:meta/meta.dart';

import '../either/either.dart';
import 'trees/tree.dart';

@sealed
class TreeSet<V extends Comparable> with IterableMixin<V> {
  @override
  final int length;

  final TreeNode<V, V> _root;

  TreeSet._(this._root, this.length);

  TreeSet() : this.avl();

  TreeSet.avl() : this._(LeafAVLNode<V, V>(), 0);

  /// Whether the map is empty or not in O(1);
  @override
  bool get isEmpty => _root.isEmpty;

  /// Whether the map is empty or not in O(1);
  @override
  bool get isNotEmpty => !_root.isEmpty;

  @override
  Iterator<V> get iterator => _root.entries.map((e) => e.value).iterator;

  TreeSet<V> insert(V value) {
    try {
      return TreeSet<V>._(_root.insert(value, value), length + 1);
    } on TreeResetOperationException {
      return this;
    }
  }

  TreeSet<V> delete(V value) {
    try {
      return TreeSet<V>._(_root.delete(value), length - 1);
    } on TreeResetOperationException {
      return this;
    }
  }

  @override
  bool contains(Object? element) {
    if (element is! V) {
      return false;
    }

    return _root.find(element).right;
  }
}
