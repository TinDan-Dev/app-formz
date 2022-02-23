import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../either/either.dart';
import 'avl_operations.dart' as avl;
import 'avl_tree.dart';

@sealed
class TreeSet<V extends Comparable> with IterableMixin<V> {
  final AVLNode<V, V> _root;

  TreeSet._(this._root);

  TreeSet() : this._(LeafAVLNode<V, V>());

  factory TreeSet.from(Set<V> set) {
    final sorted = set.sorted((a, b) => a.compareTo(b));
    final root = avl.fromIterator<V, V>(sorted.iterator, set.length);

    return TreeSet<V>._(root);
  }

  /// Whether the map is empty or not in O(1);
  @override
  bool get isEmpty => _root.isLeaf;

  /// Whether the map is empty or not in O(1);
  @override
  bool get isNotEmpty => !_root.isLeaf;

  @override
  Iterator<V> get iterator => _root.entries.iterator;

  TreeSet<V> insert(V value) {
    try {
      return TreeSet<V>._(_root.insert(value, value));
    } on AVLResetOperationException {
      return this;
    }
  }

  TreeSet<V> delete(V value) {
    try {
      return TreeSet<V>._(_root.delete(value));
    } on AVLResetOperationException {
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

  TreeSet<V> intersect(TreeSet<V> other) => TreeSet._(avl.intersect(_root, other._root));

  TreeSet<V> union(TreeSet<V> other) => TreeSet._(avl.union(_root, other._root));

  TreeSet<V> minus(TreeSet<V> other) => TreeSet._(avl.minus(_root, other._root));
}
