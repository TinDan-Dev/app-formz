import 'dart:math';

import 'package:meta/meta.dart';

import 'reference_box.dart';

/// If the operation can be reset and no copy of the tree needs to be created.
///
/// For example when inserting a duplicate or removing a not existing value.
class AVLResetOperationException implements Exception {
  const AVLResetOperationException();
}

/// Performers a right rotation on a node (Y):
///
///       Y             X
///     /   \         /   \
///    X     O  ==>  O     Y
///  /   \               /   \
/// O     Z             Z     O
///
/// Assumes that the node has a left child (X) the right child of X (Z) can
/// be a leaf.
InnerAVLNode<K, V> rotateRight<K extends Comparable, V>({
  required K key,
  required V value,
  required int height,
  required AVLNode<K, V> right,
  required InnerAVLNode<K, V> left,
}) {
  final x = left;
  final z = x.right;

  final y = InnerAVLNode<K, V>(
    key,
    value,
    right: right,
    left: z,
    height: max(right.height, z.height) + 1,
  );

  return InnerAVLNode<K, V>(
    x.key,
    x.value,
    right: y,
    left: x.left,
    height: max(x.left.height, y.height) + 1,
  );
}

/// Performers a left rotation on a node (Y):
///
///    Y                   X
///  /   \               /   \
/// O     X     ==>     Y     O
///     /   \         /   \
///    Z     O       O     Z
///
/// Assumes that the node has a right child (X) the left child of X (Z) can
/// be a leaf.
InnerAVLNode<K, V> rotateLeft<K extends Comparable, V>({
  required K key,
  required V value,
  required int height,
  required InnerAVLNode<K, V> right,
  required AVLNode<K, V> left,
}) {
  final x = right;
  final z = x.left;

  final y = InnerAVLNode<K, V>(
    key,
    value,
    right: z,
    left: left,
    height: max(left.height, z.height) + 1,
  );

  return InnerAVLNode<K, V>(
    x.key,
    x.value,
    right: x.right,
    left: y,
    height: max(x.right.height, y.height) + 1,
  );
}

/// Performers a right rotation on Y nad a left on Z:
///
///    Z                Z                      X
///  /   \            /   \                  /   \
/// 1     Y     ==>  1     X        ==>    Z       Y
///     /   \            /   \            / \     / \
///    X     4          2     Y          1   2   3   4
///  /   \                  /   \
/// 2     3                3     4
///
/// Assumes that the node has a right child (Y) and that Y has a left child (X).
InnerAVLNode<K, V> rotateRightLeft<K extends Comparable, V>({
  required K key,
  required V value,
  required InnerAVLNode<K, V> right,
  required AVLNode<K, V> left,
}) {
  final x = right.left as InnerAVLNode<K, V>;

  final y = InnerAVLNode<K, V>(
    right.key,
    right.value,
    right: right.right,
    left: x.right,
    height: max(x.right.height, right.right.height) + 1,
  );

  final z = InnerAVLNode<K, V>(
    key,
    value,
    right: x.left,
    left: left,
    height: max(x.left.height, left.height) + 1,
  );

  return InnerAVLNode<K, V>(
    x.key,
    x.value,
    right: y,
    left: z,
    height: max(z.height, y.height) + 1,
  );
}

/// Performers a left rotation on Y nad a right on Z:
///
///       Z                   Z                X
///     /   \               /   \            /   \
///    Y     1  ==>        X     1  ==>    Y       Z
///  /   \               /   \            / \     / \
/// 4     X             Y     2          4   3   2   1
///     /   \         /   \
///    3     2       4     3
///
/// Assumes that the node has a left child (Y) and that Y has a right child (X).
InnerAVLNode<K, V> rotateLeftRight<K extends Comparable, V>({
  required K key,
  required V value,
  required AVLNode<K, V> right,
  required InnerAVLNode<K, V> left,
}) {
  final x = left.right as InnerAVLNode<K, V>;

  final y = InnerAVLNode<K, V>(
    left.key,
    left.value,
    right: x.left,
    left: left.left,
    height: max(x.left.height, left.left.height) + 1,
  );

  final z = InnerAVLNode<K, V>(
    key,
    value,
    right: right,
    left: x.right,
    height: max(x.right.height, right.height) + 1,
  );

  return InnerAVLNode<K, V>(
    x.key,
    x.value,
    right: z,
    left: y,
    height: max(z.height, y.height) + 1,
  );
}

/// Rebalances the tree if necessary depending on the hight of the children.
InnerAVLNode<K, V> rebalance<K extends Comparable, V>({
  required K key,
  required V value,
  required int height,
  required AVLNode<K, V> right,
  required AVLNode<K, V> left,
}) {
  final balance = right.height - left.height;

  if (balance > 1) {
    assert(right is InnerAVLNode<K, V>);

    if (right.right.height > right.left.height) {
      return rotateLeft(
        key: key,
        value: value,
        height: height,
        right: right as InnerAVLNode<K, V>,
        left: left,
      );
    } else {
      return rotateRightLeft(
        key: key,
        value: value,
        right: right as InnerAVLNode<K, V>,
        left: left,
      );
    }
  } else if (balance < -1) {
    assert(left is InnerAVLNode<K, V>);

    if (left.left.height > left.right.height) {
      return rotateRight(
        key: key,
        value: value,
        height: height,
        right: right,
        left: left as InnerAVLNode<K, V>,
      );
    } else {
      return rotateLeftRight(
        key: key,
        value: value,
        right: right,
        left: left as InnerAVLNode<K, V>,
      );
    }
  }

  return InnerAVLNode(key, value, height: height, right: right, left: left);
}

void _graphviz(StringBuffer buffer, InnerAVLNode node) {
  final key = node.key;
  final right = node.right;
  final left = node.left;

  buffer.writeln('"$key"[label="$key: ${node.value} (${node.height}@${node.right.height - node.left.height})"]');

  if (right is InnerAVLNode) {
    buffer.writeln('"$key"->"${right.key}"[label="R"]');
    _graphviz(buffer, right);
  }
  if (left is InnerAVLNode) {
    buffer.writeln('"$key"->"${left.key}"[label="L"]');
    _graphviz(buffer, left);
  }
}

abstract class AVLNode<K extends Comparable, V> {
  const AVLNode();

  int get height;

  bool get isLeaf;

  AVLNode<K, V> get left;
  AVLNode<K, V> get right;

  /// Inserts a new value into the tree.
  ///
  /// Walks the tree recursively and inserts the node at the right position.
  /// The actual insert is handled be the leaf and the search by the inner
  /// nodes.
  AVLNode<K, V> insert(K key, V value);

  /// Removes a node from the tree.
  ///
  /// If the node was not found nothing will happen.
  AVLNode<K, V> delete(K key);

  /// Gets the value of the right most inner node and deletes it.
  ///
  /// This is a helper method for the delete function to find the replacement
  /// for the deleted node when it has two children.
  AVLNode<K, V> deleteRightMostChild(InnerAVLNode<K, V> parent, ReferenceBox<InnerAVLNode<K, V>> result);

  /// Checks if the tree contains a value.
  bool contains(K key);
}

class LeafAVLNode<K extends Comparable, V> extends AVLNode<K, V> {
  const LeafAVLNode();

  @override
  int get height => -1;

  @override
  bool get isLeaf => true;

  @override
  AVLNode<K, V> get left => this;
  @override
  AVLNode<K, V> get right => this;

  @override
  AVLNode<K, V> insert(K key, V value) => InnerAVLNode<K, V>(key, value);

  @override
  bool contains(K key) => false;

  @override
  AVLNode<K, V> delete(K key) => throw const AVLResetOperationException();

  @override
  AVLNode<K, V> deleteRightMostChild(InnerAVLNode<K, V> parent, ReferenceBox<InnerAVLNode<K, V>> result) {
    result.value = parent;

    return parent.left;
  }
}

class InnerAVLNode<K extends Comparable, V> extends AVLNode<K, V> {
  final K key;
  final V value;

  @override
  final int height;

  @override
  final AVLNode<K, V> left;
  @override
  final AVLNode<K, V> right;

  InnerAVLNode(
    this.key,
    this.value, {
    this.height = 0,
    AVLNode<K, V>? left,
    AVLNode<K, V>? right,
  })  : left = left ?? LeafAVLNode<K, V>(),
        right = right ?? LeafAVLNode<K, V>();

  @override
  bool get isLeaf => false;

  @override
  AVLNode<K, V> insert(K key, V value) {
    final comp = this.key.compareTo(key);

    if (comp > 0) {
      final result = left.insert(key, value);

      return rebalance(
        key: this.key,
        value: this.value,
        height: max(result.height, right.height) + 1,
        left: result,
        right: right,
      );
    } else if (comp < 0) {
      final result = right.insert(key, value);

      return rebalance(
        key: this.key,
        value: this.value,
        height: max(result.height, left.height) + 1,
        left: left,
        right: result,
      );
    }

    throw const AVLResetOperationException();
  }

  @override
  AVLNode<K, V> delete(K key) {
    final comp = this.key.compareTo(key);

    if (comp > 0) {
      final result = left.delete(key);

      return rebalance(
        key: this.key,
        value: value,
        height: max(result.height, right.height) + 1,
        left: result,
        right: right,
      );
    } else if (comp < 0) {
      final result = right.delete(key);

      return rebalance(
        key: this.key,
        value: value,
        height: max(result.height, left.height) + 1,
        left: left,
        right: result,
      );
    }

    if (left.isLeaf) {
      return right;
    }
    if (right.isLeaf) {
      return left;
    }

    final rightMostRef = ReferenceBox<InnerAVLNode<K, V>>();
    final leftUpdated = left.deleteRightMostChild(this, rightMostRef);
    assert(rightMostRef.accessed);

    return rebalance(
      key: rightMostRef.value.key,
      value: rightMostRef.value.value,
      height: max(leftUpdated.height, right.height) + 1,
      right: right,
      left: leftUpdated,
    );
  }

  @override
  AVLNode<K, V> deleteRightMostChild(InnerAVLNode<K, V> parent, ReferenceBox<InnerAVLNode<K, V>> result) {
    final node = right.deleteRightMostChild(this, result);

    return InnerAVLNode(
      parent.key,
      parent.value,
      height: max(parent.left.height, node.height) + 1,
      right: node,
      left: parent.left,
    );
  }

  @override
  bool contains(K key) {
    final comp = this.key.compareTo(key);

    if (comp > 0) {
      return left.contains(key);
    } else if (comp < 0) {
      return right.contains(key);
    }

    return true;
  }
}

class AVLTree<K extends Comparable, V> {
  @visibleForTesting
  final AVLNode<K, V> root;

  AVLTree._(this.root);

  AVLTree() : this._(LeafAVLNode<K, V>());

  AVLTree<K, V> insert(K key, V value) {
    try {
      return AVLTree<K, V>._(root.insert(key, value));
    } on AVLResetOperationException {
      return this;
    }
  }

  AVLTree<K, V> delete(K key) {
    try {
      return AVLTree<K, V>._(root.delete(key));
    } on AVLResetOperationException {
      return this;
    }
  }

  bool contains(K key) => root.contains(key);

  String graphviz() {
    final buffer = StringBuffer();
    buffer.writeln('digraph G {');

    if (root is InnerAVLNode) {
      _graphviz(buffer, root as InnerAVLNode);
    }

    buffer.writeln('}');
    return buffer.toString();
  }
}
