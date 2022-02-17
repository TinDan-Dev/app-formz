import 'dart:math';

/// Gets the hight from a node or -1 if null.
int getHeight(AVLNode? node) => node?.height ?? -1;

/// Gets the balance of a node.
int getBalance(AVLNode node) => getHeight(node.right) - getHeight(node.left);

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
AVLNode rotateRight(AVLNode node) {
  final x = node.left!;
  final z = x.right;

  x.right = node;
  node.left = z;

  node.height = max(getHeight(node.right), getHeight(z)) + 1;
  x.height = max(getHeight(x.right), node.height) + 1;

  return x;
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
AVLNode rotateLeft(AVLNode node) {
  final x = node.right!;
  final z = x.left;

  x.left = node;
  node.right = z;

  node.height = max(getHeight(node.left), getHeight(z)) + 1;
  x.height = max(getHeight(x.left), node.height) + 1;

  return x;
}

/// Rebalances the tree if necessary depending on the hight of the children.
AVLNode rebalance(AVLNode node) {
  final balance = getBalance(node);

  if (balance > 1) {
    if (getHeight(node.right?.right) > getHeight(node.right?.left)) {
      return rotateLeft(node);
    } else {
      node.right = rotateRight(node.right!);
      return rotateLeft(node);
    }
  } else if (balance < -1) {
    if (getHeight(node.left?.left) > getHeight(node.left?.right)) {
      return rotateRight(node);
    } else {
      node.left = rotateLeft(node.left!);
      return rotateRight(node);
    }
  }

  return node;
}

class AVLNode {
  int value;
  int height;

  AVLNode? left;
  AVLNode? right;

  AVLNode(this.value) : height = 0;

  /// Inserts a new value into the tree.
  ///
  /// Walks the tree recursively and inserts the node at the right position.
  /// Also updates the height of the current node if necessary and returns its
  /// height.
  AVLNode insert(int value) {
    if (value < this.value) {
      if (left == null) {
        left = AVLNode(value);
        height = max(height, 1);
      } else {
        left = left!.insert(value);
        height = max(left!.height, getHeight(right)) + 1;
      }
    } else if (value > this.value) {
      if (right == null) {
        right = AVLNode(value);
        height = max(height, 1);
      } else {
        right = right!.insert(value);
        height = max(right!.height, getHeight(left)) + 1;
      }
    }

    return rebalance(this);
  }

  void graphviz(StringBuffer buffer) {
    buffer.writeln('"$value"[label="$value ($height @ ${getBalance(this)})"]');

    if (right != null) {
      buffer.writeln('"$value"->"${right!.value}"[label="R"]');
      right!.graphviz(buffer);
    }
    if (left != null) {
      buffer.writeln('"$value"->"${left!.value}"[label="L"]');
      left!.graphviz(buffer);
    }
  }
}

class AVLTree {
  AVLNode? root;

  void insert(int value) {
    if (root == null) {
      root = AVLNode(value);
      return;
    }

    root = root!.insert(value);
  }

  String graphviz() {
    final buffer = StringBuffer();

    buffer.writeln('digraph G {');
    root?.graphviz(buffer);
    buffer.writeln('}');

    return buffer.toString();
  }
}
