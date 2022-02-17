import 'dart:math';

import 'package:meta/meta.dart';

/// Performers a right rotation on a node (Y):
///
///       Y             X
///     /   \         /   \
///    X     O  ==>  O     Y
///  /   \               /   \
/// O     Z             Z     O
///
/// Assumes that this node has a left child (X) the right child of X (Z) can
/// be null. The heights of the nodes are also updated.
InnerAVLNode rotateRight(InnerAVLNode node) {
  final x = node.left as InnerAVLNode;
  final z = x.right;

  final y = InnerAVLNode(
    node.value,
    right: node.right,
    left: z,
    height: max(node.right.height, z.height) + 1,
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
/// Assumes that this node has a right child (X) the left child of X (Z) can
/// be null. The heights of the nodes are also updated.
InnerAVLNode rotateLeft(InnerAVLNode node) {
  final x = node.right as InnerAVLNode;
  final z = x.left;

  final y = InnerAVLNode(
    node.value,
    left: node.left,
    right: z,
    height: max(node.left.height, z.height) + 1,
  );

  return InnerAVLNode(
    x.value,
    right: x.right,
    left: y,
    height: max(x.right.height, y.height) + 1,
  );
}

/// Rebalances the tree if necessary depending on the hight of the children.
InnerAVLNode rebalance(InnerAVLNode node) {
  final balance = node.balance;

  if (balance > 1) {
    if (node.right.right.height > node.right.left.height) {
      return rotateLeft(node);
    } else {
      final temp = InnerAVLNode(
        node.value,
        right: rotateRight(node.right as InnerAVLNode),
        left: node.left,
        height: node.height,
      );
      return rotateLeft(temp);
    }
  } else if (balance < -1) {
    if (node.left.left.height > node.left.right.height) {
      return rotateRight(node);
    } else {
      final temp = InnerAVLNode(
        node.value,
        right: node.right,
        left: rotateLeft(node.left as InnerAVLNode),
        height: node.height,
      );
      return rotateRight(temp);
    }
  }

  return node;
}

void _graphviz(StringBuffer buffer, InnerAVLNode node) {
  final value = node.value;
  final right = node.right;
  final left = node.left;

  buffer.writeln('"$value"[label="$value (${node.height} @ ${node.balance})"]');

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

  AVLNode get left;
  AVLNode get right;

  int get balance => right.height - left.height;

  AVLNode insert(int value);
}

class LeafAVLNode extends AVLNode {
  const LeafAVLNode();

  @override
  int get height => -1;

  @override
  AVLNode get left => this;
  @override
  AVLNode get right => this;

  @override
  AVLNode insert(int value) => InnerAVLNode(value);
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

  /// Inserts a new value into the tree.
  ///
  /// Walks the tree recursively and inserts the node at the right position.
  /// Also updates the height of the current node if necessary and returns its
  /// height.
  @override
  AVLNode insert(int value) {
    var node = this;

    if (value < this.value) {
      final result = left.insert(value);

      node = InnerAVLNode(
        this.value,
        height: max(result.height, right.height) + 1,
        left: result,
        right: right,
      );
    } else if (value > this.value) {
      final result = right.insert(value);

      node = InnerAVLNode(
        this.value,
        height: max(result.height, left.height) + 1,
        left: left,
        right: result,
      );
    }

    return rebalance(node);
  }
}

class AVLTree {
  @visibleForTesting
  final AVLNode root;

  const AVLTree._(this.root);

  const AVLTree() : this._(const LeafAVLNode());

  AVLTree insert(int value) => AVLTree._(root.insert(value));

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
