import 'dart:math';

import '../result/result.dart';
import 'reference_box.dart';

/// If the operation can be reset and no copy of the tree needs to be created.
///
/// For example when inserting a duplicate or removing a not existing value.
class AVLResetOperationException implements Exception {
  const AVLResetOperationException();
}

/// If a key could not be found in the tree.
///
/// Can be returned by the find operation.
class AVLNotFoundFailure<R> extends Failure<R> {
  AVLNotFoundFailure({
    required Object? key,
    StackTrace? trace,
  }) : super(message: 'Key could not be found: $key', cause: key, trace: trace);
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
InnerAVLNode<K, V> rotateRight<K, V extends Comparable>({
  required V value,
  required int height,
  required AVLNode<K, V> right,
  required InnerAVLNode<K, V> left,
}) {
  final x = left;
  final z = x.right;

  final y = InnerAVLNode<K, V>(
    value,
    right: right,
    left: z,
    height: max(right.height, z.height) + 1,
  );

  return InnerAVLNode<K, V>(
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
InnerAVLNode<K, V> rotateLeft<K, V extends Comparable>({
  required V value,
  required int height,
  required InnerAVLNode<K, V> right,
  required AVLNode<K, V> left,
}) {
  final x = right;
  final z = x.left;

  final y = InnerAVLNode<K, V>(
    value,
    right: z,
    left: left,
    height: max(left.height, z.height) + 1,
  );

  return InnerAVLNode<K, V>(
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
InnerAVLNode<K, V> rotateRightLeft<K, V extends Comparable>({
  required V value,
  required InnerAVLNode<K, V> right,
  required AVLNode<K, V> left,
}) {
  final x = right.left as InnerAVLNode<K, V>;

  final y = InnerAVLNode<K, V>(
    right.value,
    right: right.right,
    left: x.right,
    height: max(x.right.height, right.right.height) + 1,
  );

  final z = InnerAVLNode<K, V>(
    value,
    right: x.left,
    left: left,
    height: max(x.left.height, left.height) + 1,
  );

  return InnerAVLNode<K, V>(
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
InnerAVLNode<K, V> rotateLeftRight<K, V extends Comparable>({
  required V value,
  required AVLNode<K, V> right,
  required InnerAVLNode<K, V> left,
}) {
  final x = left.right as InnerAVLNode<K, V>;

  final y = InnerAVLNode<K, V>(
    left.value,
    right: x.left,
    left: left.left,
    height: max(x.left.height, left.left.height) + 1,
  );

  final z = InnerAVLNode<K, V>(
    value,
    right: right,
    left: x.right,
    height: max(x.right.height, right.height) + 1,
  );

  return InnerAVLNode<K, V>(
    x.value,
    right: z,
    left: y,
    height: max(z.height, y.height) + 1,
  );
}

/// Rebalances the tree if necessary depending on the hight of the children.
InnerAVLNode<K, V> rebalance<K, V extends Comparable>({
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
        value: value,
        height: height,
        right: right as InnerAVLNode<K, V>,
        left: left,
      );
    } else {
      return rotateRightLeft(
        value: value,
        right: right as InnerAVLNode<K, V>,
        left: left,
      );
    }
  } else if (balance < -1) {
    assert(left is InnerAVLNode<K, V>);

    if (left.left.height > left.right.height) {
      return rotateRight(
        value: value,
        height: height,
        right: right,
        left: left as InnerAVLNode<K, V>,
      );
    } else {
      return rotateLeftRight(
        value: value,
        right: right,
        left: left as InnerAVLNode<K, V>,
      );
    }
  }

  return InnerAVLNode(value, height: height, right: right, left: left);
}

abstract class AVLNode<K, V extends Comparable> {
  const AVLNode();

  int get height;

  bool get isLeaf;

  AVLNode<K, V> get left;
  AVLNode<K, V> get right;

  AVLNode<K, V> insert(K key, V value);

  AVLNode<K, V> delete(K key);

  /// Gets the value of the right most inner node and deletes it.
  ///
  /// This is a helper method for the delete function to find the replacement
  /// for the deleted node when it has two children.
  AVLNode<K, V> deleteRightMostChild(InnerAVLNode<K, V> parent, ReferenceBox<V> result);

  Result<V> find(K key);

  Iterable<V> get entries;
}

class LeafAVLNode<K, V extends Comparable> extends AVLNode<K, V> {
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
  AVLNode<K, V> insert(K key, V value) => InnerAVLNode<K, V>(value, left: this, right: this);

  @override
  AVLNode<K, V> delete(K key) => throw const AVLResetOperationException();

  @override
  AVLNode<K, V> deleteRightMostChild(InnerAVLNode<K, V> parent, ReferenceBox<V> result) {
    result.value = parent.value;

    return parent.left;
  }

  @override
  Result<V> find(K key) => AVLNotFoundFailure(key: key);

  @override
  Iterable<V> get entries => Iterable<V>.empty();
}

class InnerAVLNode<K, V extends Comparable> extends AVLNode<K, V> {
  @override
  final V value;

  @override
  final int height;

  @override
  final AVLNode<K, V> left;
  @override
  final AVLNode<K, V> right;

  InnerAVLNode(
    this.value, {
    this.height = 0,
    required this.left,
    required this.right,
  });

  @override
  bool get isLeaf => false;

  @override
  AVLNode<K, V> insert(K key, V value) {
    final comp = this.value.compareTo(key);

    if (comp > 0) {
      final result = left.insert(key, value);

      return rebalance(
        value: this.value,
        height: max(result.height, right.height) + 1,
        left: result,
        right: right,
      );
    } else if (comp < 0) {
      final result = right.insert(key, value);

      return rebalance(
        value: this.value,
        height: max(result.height, left.height) + 1,
        left: left,
        right: result,
      );
    }

    if (value != this.value) {
      return InnerAVLNode(
        value,
        height: height,
        left: left,
        right: right,
      );
    }

    throw const AVLResetOperationException();
  }

  @override
  AVLNode<K, V> delete(K key) {
    final comp = value.compareTo(key);

    if (comp > 0) {
      final result = left.delete(key);

      return rebalance(
        value: value,
        height: max(result.height, right.height) + 1,
        left: result,
        right: right,
      );
    } else if (comp < 0) {
      final result = right.delete(key);

      return rebalance(
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

    final rightMostRef = ReferenceBox<V>();
    final leftUpdated = left.right.deleteRightMostChild(left as InnerAVLNode<K, V>, rightMostRef);
    assert(rightMostRef.accessed);

    return rebalance(
      value: rightMostRef.value,
      height: max(leftUpdated.height, right.height) + 1,
      right: right,
      left: leftUpdated,
    );
  }

  @override
  AVLNode<K, V> deleteRightMostChild(InnerAVLNode<K, V> parent, ReferenceBox<V> result) {
    final node = right.deleteRightMostChild(this, result);

    return InnerAVLNode(
      parent.value,
      height: max(parent.left.height, node.height) + 1,
      right: node,
      left: parent.left,
    );
  }

  @override
  Result<V> find(K key) {
    final comp = value.compareTo(key);

    if (comp > 0) {
      return left.find(key);
    } else if (comp < 0) {
      return right.find(key);
    }

    return Result.right(value);
  }

  @override
  Iterable<V> get entries sync* {
    yield* left.entries;
    yield value;
    yield* right.entries;
  }
}

/// For testing only, creates a string representation of the tree that can be
/// viewed with: https://dreampuf.github.io/GraphvizOnline/
String graphviz(AVLNode root) {
  final buffer = StringBuffer();
  buffer.writeln('digraph G {');

  if (root is InnerAVLNode) {
    _graphviz(buffer, root);
  }

  buffer.writeln('}');
  return buffer.toString();
}

void _graphviz(StringBuffer buffer, InnerAVLNode node) {
  final value = node.value;
  final right = node.right;
  final left = node.left;

  buffer.writeln('"$value"[label="$value (${node.height}@${node.right.height - node.left.height})"]');

  if (right is InnerAVLNode) {
    buffer.writeln('"$value"->"${right.value}"[label="R"]');
    _graphviz(buffer, right);
  }
  if (left is InnerAVLNode) {
    buffer.writeln('"$value"->"${left.value}"[label="L"]');
    _graphviz(buffer, left);
  }
}
