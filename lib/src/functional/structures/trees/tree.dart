import '../../result/result.dart';

export 'avl_tree.dart';

/// If the operation can be reset and no copy of the tree needs to be created.
///
/// For example when inserting a duplicate or removing a not existing value.
class TreeResetOperationException implements Exception {
  const TreeResetOperationException();
}

/// An entry in the tree map.
///
/// Should be implemented by all tree nodes that could be used for a tree map.
abstract class TreeEntry<K, V> {
  K get key;
  V get value;
}

/// Super class for all tree nodes.
///
/// Every tree that derives from this class can be used to implement the tree
/// map. The tree itself is immutable, thus all update methods create copies
/// of the tree.
abstract class TreeNode<K extends Comparable, V> {
  /// Inserts a new element into the tree.
  ///
  /// Should overwrite the value when the key already exits and if the old value
  /// is equal to the new value a [TreeResetOperationException] should be thrown.
  TreeNode<K, V> insert(K key, V value);

  /// Deletes an element from the tree.
  ///
  /// Should throw a [TreeResetOperationException] if the key was not found,
  /// to avoid recreating the tree.
  TreeNode<K, V> delete(K key);

  /// Tries to retrieve an element from the tree.
  ///
  /// Should return the value when successful and a failure if the key could
  /// not be found.
  Result<V> find(K key);

  /// All elements of the tree in order.
  Iterable<TreeEntry<K, V>> get entries;
}
