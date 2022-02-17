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
InnerAVLNode rotateRight({
  required int value,
  required int height,
  required AVLNode right,
  required InnerAVLNode left,
}) {
  final x = left;
  final z = x.right;

  final y = InnerAVLNode(
    value,
    right: right,
    left: z,
    height: max(right.height, z.height) + 1,
  );

  return InnerAVLNode(
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
InnerAVLNode rotateLeft({
  required int value,
  required int height,
  required InnerAVLNode right,
  required AVLNode left,
}) {
  final x = right;
  final z = x.left;

  final y = InnerAVLNode(
    value,
    right: z,
    left: left,
    height: max(left.height, z.height) + 1,
  );

  return InnerAVLNode(
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
InnerAVLNode rotateRightLeft({
  required int value,
  required InnerAVLNode right,
  required AVLNode left,
}) {
  final x = right.left as InnerAVLNode;

  final y = InnerAVLNode(
    right.value,
    right: right.right,
    left: x.right,
    height: max(x.right.height, right.right.height) + 1,
  );

  final z = InnerAVLNode(
    value,
    right: x.left,
    left: left,
    height: max(x.left.height, left.height) + 1,
  );

  return InnerAVLNode(
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
InnerAVLNode rotateLeftRight({
  required int value,
  required AVLNode right,
  required InnerAVLNode left,
}) {
  final x = left.right as InnerAVLNode;

  final y = InnerAVLNode(
    left.value,
    right: x.left,
    left: left.left,
    height: max(x.left.height, left.left.height) + 1,
  );

  final z = InnerAVLNode(
    value,
    right: right,
    left: x.right,
    height: max(x.right.height, right.height) + 1,
  );

  return InnerAVLNode(
    x.value,
    right: z,
    left: y,
    height: max(z.height, y.height) + 1,
  );
}

/// Rebalances the tree if necessary depending on the hight of the children.
InnerAVLNode rebalance({
  required int value,
  required int height,
  required AVLNode right,
  required AVLNode left,
}) {
  final balance = right.height - left.height;

  if (balance > 1) {
    assert(right is InnerAVLNode);

    if (right.right.height > right.left.height) {
      return rotateLeft(
        value: value,
        height: height,
        right: right as InnerAVLNode,
        left: left,
      );
    } else {
      return rotateRightLeft(
        value: value,
        right: right as InnerAVLNode,
        left: left,
      );
    }
  } else if (balance < -1) {
    assert(left is InnerAVLNode);

    if (left.left.height > left.right.height) {
      return rotateRight(
        value: value,
        height: height,
        right: right,
        left: left as InnerAVLNode,
      );
    } else {
      return rotateLeftRight(
        value: value,
        right: right,
        left: left as InnerAVLNode,
      );
    }
  }

  return InnerAVLNode(value, height: height, right: right, left: left);
}

void _graphviz(StringBuffer buffer, InnerAVLNode node) {
  final value = node.value;
  final right = node.right;
  final left = node.left;

  buffer.writeln('"$value"[label="$value (${node.height} @ ${node.right.height - node.left.height})"]');

  if (right is InnerAVLNode) {
    buffer.writeln('"$value"->"${right.value}"[label="R"]');
    _graphviz(buffer, right);
  }
  if (left is InnerAVLNode) {
    buffer.writeln('"$value"->"${left.value}"[label="L"]');
    _graphviz(buffer, left);
  }
}

abstract class AVLNode {
  const AVLNode();

  int get height;

  bool get isLeaf;

  AVLNode get left;
  AVLNode get right;

  /// Inserts a new value into the tree.
  ///
  /// Walks the tree recursively and inserts the node at the right position.
  /// The actual insert is handled be the leaf and the search by the inner
  /// nodes.
  AVLNode insert(int value);

  /// Removes a node from the tree.
  ///
  /// If the node was not found nothing will happen.
  AVLNode delete(int value);

  /// Gets the value of the right most inner node and deletes it.
  ///
  /// This is a helper method for the delete function to find the replacement
  /// for the deleted node when it has two children.
  AVLNode deleteRightMostChild(InnerAVLNode parent, ReferenceBox<int> result);

  /// Checks if the tree contains a value.
  bool contains(int value);
}

class LeafAVLNode extends AVLNode {
  const LeafAVLNode();

  @override
  int get height => -1;

  @override
  bool get isLeaf => true;

  @override
  AVLNode get left => this;
  @override
  AVLNode get right => this;

  @override
  AVLNode insert(int value) => InnerAVLNode(value);

  @override
  bool contains(int value) => false;

  @override
  AVLNode delete(int value) => throw const AVLResetOperationException();

  @override
  AVLNode deleteRightMostChild(InnerAVLNode parent, ReferenceBox<int> result) {
    result.value = parent.value;

    return parent.left;
  }
}

class InnerAVLNode extends AVLNode {
  final int value;

  @override
  final int height;

  @override
  final AVLNode left;
  @override
  final AVLNode right;

  const InnerAVLNode(
    this.value, {
    this.height = 0,
    this.left = const LeafAVLNode(),
    this.right = const LeafAVLNode(),
  });

  @override
  bool get isLeaf => false;

  @override
  AVLNode insert(int value) {
    if (value < this.value) {
      final result = left.insert(value);

      return rebalance(
        value: this.value,
        height: max(result.height, right.height) + 1,
        left: result,
        right: right,
      );
    } else if (value > this.value) {
      final result = right.insert(value);

      return rebalance(
        value: this.value,
        height: max(result.height, left.height) + 1,
        left: left,
        right: result,
      );
    }

    throw const AVLResetOperationException();
  }

  @override
  AVLNode delete(int value) {
    if (value < this.value) {
      final result = left.delete(value);

      return rebalance(
        value: this.value,
        height: max(result.height, right.height) + 1,
        left: result,
        right: right,
      );
    } else if (value > this.value) {
      final result = right.delete(value);

      return rebalance(
        value: this.value,
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

    final rightMostRef = ReferenceBox<int>();
    final leftUpdated = left.deleteRightMostChild(this, rightMostRef);
    assert(rightMostRef.accessed);

    return rebalance(
      value: rightMostRef.value,
      height: max(leftUpdated.height, right.height) + 1,
      right: right,
      left: leftUpdated,
    );
  }

  @override
  AVLNode deleteRightMostChild(InnerAVLNode parent, ReferenceBox<int> result) {
    final node = right.deleteRightMostChild(this, result);

    return InnerAVLNode(
      parent.value,
      height: max(parent.left.height, node.height) + 1,
      right: node,
      left: parent.left,
    );
  }

  @override
  bool contains(int value) {
    if (value < this.value) {
      return left.contains(value);
    } else if (value > this.value) {
      return right.contains(value);
    }

    return true;
  }
}

class AVLTree {
  @visibleForTesting
  final AVLNode root;

  const AVLTree._(this.root);

  const AVLTree() : this._(const LeafAVLNode());

  AVLTree insert(int value) {
    try {
      return AVLTree._(root.insert(value));
    } on AVLResetOperationException {
      return this;
    }
  }

  AVLTree delete(int value) {
    try {
      return AVLTree._(root.delete(value));
    } on AVLResetOperationException {
      return this;
    }
  }

  bool contains(int value) => root.contains(value);

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
