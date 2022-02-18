import 'package:meta/meta.dart';

import '../either/either.dart';
import '../result/result.dart';
import 'trees/tree.dart';

@sealed
class TreeMap<K extends Comparable, V> {
  final int length;

  final TreeNode<K, V> _root;

  TreeMap._(this._root, this.length);

  TreeMap() : this.avl();

  TreeMap.avl() : this._(LeafAVLNode<K, V>(), 0);

  bool get isEmpty => length == 0;

  bool get isNotEmpty => length > 0;

  Iterable<TreeEntry<K, V>> get entries => _root.entries;

  Iterable<K> get keys => _root.entries.map((e) => e.key);

  Iterable<V> get values => _root.entries.map((e) => e.value);

  V? operator [](K? key) {
    if (key == null) {
      return null;
    }

    return _root.find(key).mapLeft((v) => v.copyWith(trace: () => StackTrace.current)).rightOrNull();
  }

  TreeMap<K, V> insert(K key, V value) {
    try {
      return TreeMap<K, V>._(_root.insert(key, value), length + 1);
    } on TreeResetOperationException {
      return this;
    }
  }

  TreeMap<K, V> delete(K key) {
    try {
      return TreeMap<K, V>._(_root.delete(key), length - 1);
    } on TreeResetOperationException {
      return this;
    }
  }

  Result<V> find(K key) => _root.find(key).mapLeft((v) => v.copyWith(trace: () => StackTrace.current));

  bool contains(K key) => _root.find(key).right;
}
