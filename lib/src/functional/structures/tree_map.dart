import 'package:meta/meta.dart';

import '../either/either.dart';
import '../result/result.dart';
import 'avl_tree.dart';

class TreeMapEntry<K extends Comparable, V> implements Comparable<K> {
  final K key;
  final V value;

  TreeMapEntry(this.key, this.value);

  @override
  int compareTo(K other) => key.compareTo(other);

  @override
  bool operator ==(Object other) => identical(this, other) || other is TreeMapEntry && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

@sealed
class TreeMap<K extends Comparable, V> {
  final AVLNode<K, TreeMapEntry<K, V>> _root;

  TreeMap._(this._root);

  TreeMap() : this._(LeafAVLNode<K, TreeMapEntry<K, V>>());

  /// Whether the map is empty or not in O(1);
  bool get isEmpty => _root.isLeaf;

  /// Whether the map is empty or not in O(1);
  bool get isNotEmpty => !_root.isLeaf;

  /// The length of the map in O(n).
  ///
  /// It is not possible to keep track of the length due to possible overrides
  /// of already added keys. Thus the length needs to be retrieved from the
  /// tree.
  int get length => _root.entries.length;

  /// All entries of the map in order.
  Iterable<TreeMapEntry<K, V>> get entries => _root.entries;

  /// All keys of the map in order.
  Iterable<K> get keys => _root.entries.map((e) => e.key);

  /// All values of the map in order of the keys.
  Iterable<V> get values => _root.entries.map((e) => e.value);

  /// Finds a value in the map in O(log n).
  ///
  /// If the key has not the right type or is null this returns null also if
  /// the key was not present in the map.
  V? operator [](Object? key) {
    if (key is! K) {
      return null;
    }

    return _root
        .find(key)
        .mapRight((v) => v.value)
        .mapLeft((v) => v.copyWith(trace: () => StackTrace.current))
        .rightOrNull();
  }

  /// Inserts a new key value pair to the map in O(log n).
  ///
  /// If a value was already inserted for a specific key the value will be
  /// overwritten by the new value. If the old value is equal to the new value
  /// the insert will be ignored.
  TreeMap<K, V> insert(K key, V value) {
    try {
      return TreeMap<K, V>._(_root.insert(key, TreeMapEntry<K, V>(key, value)));
    } on AVLResetOperationException {
      return this;
    }
  }

  /// Deletes a key from the map in O(log n).
  ///
  /// If the key was not present in the map the delete will be ignored.
  TreeMap<K, V> delete(K key) {
    try {
      return TreeMap<K, V>._(_root.delete(key));
    } on AVLResetOperationException {
      return this;
    }
  }

  Result<V> find(Object? key) {
    if (key is! K) {
      return AVLNotFoundFailure(key: key, trace: StackTrace.current);
    }

    return _root.find(key).mapRight((v) => v.value).mapLeft((v) => v.copyWith(trace: () => StackTrace.current));
  }

  bool contains(Object? key) {
    if (key is! K) {
      return false;
    }

    return _root.find(key).right;
  }
}
