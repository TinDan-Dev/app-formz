import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../either/either.dart';
import '../result/result.dart';
import 'avl_operations.dart';
import 'avl_tree.dart';

class HashMapEntry<K, V> implements Comparable {
  final K key;
  final V value;

  HashMapEntry(this.key, this.value);

  @override
  int compareTo(Object? other) {
    if (other is K) {
      return key.hashCode.compareTo(other.hashCode);
    }
    if (other is HashMapEntry<K, V>) {
      return key.hashCode.compareTo(other.key.hashCode);
    }

    throw UnimplementedError('Only comparisons with a key or an entry are supported');
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is HashMapEntry && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

@sealed
class HashMap<K, V> {
  final AVLNode<K, HashMapEntry<K, V>> _root;

  HashMap._(this._root);

  HashMap() : this._(LeafAVLNode<K, HashMapEntry<K, V>>());

  factory HashMap.from(Map<K, V> map) {
    final sorted = map.entries.sorted((a, b) => a.key.hashCode.compareTo(b.key.hashCode));
    final it = sorted.map((e) => HashMapEntry<K, V>(e.key, e.value)).iterator;

    final root = fromIterator<K, HashMapEntry<K, V>>(it, map.length);

    return HashMap<K, V>._(root);
  }

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
  Iterable<HashMapEntry<K, V>> get entries => _root.entries;

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
  HashMap<K, V> insert(K key, V value) {
    try {
      return HashMap<K, V>._(_root.insert(key, HashMapEntry<K, V>(key, value)));
    } on AVLResetOperationException {
      return this;
    }
  }

  HashMap<K, V> insertAll(Map<K, V> map) {
    var m = this;
    for (final entry in map.entries) {
      m = m.insert(entry.key, entry.value);
    }

    return m;
  }

  /// Deletes a key from the map in O(log n).
  ///
  /// If the key was not present in the map the delete will be ignored.
  HashMap<K, V> delete(K key) {
    try {
      return HashMap<K, V>._(_root.delete(key));
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
