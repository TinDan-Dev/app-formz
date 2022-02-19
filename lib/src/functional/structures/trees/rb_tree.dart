import '../../result/result.dart';
import '../reference_box.dart';
import 'tree.dart';

// Constants for the node colors.

const doubleBlack = 2;
const black = 1;
const red = 0;
const negativeBlack = -1;

/// Performers the balancing rotation on a black or double black node (Z):
///
///          Z                Y
///        /   \            /   \
///       Y     4  ==>    X       Z
///     /   \            / \     / \
///    X     3          1   2   3   4
///  /   \
/// 1     2
///
/// Assumes that the node has a left red child (Y) and that Y also has a left
/// red child (X).
InnerRBNode<K, V> rotateLeftLeft<K, V extends Comparable>({
  required V value,
  required int color,
  required RBNode<K, V> right,
  required InnerRBNode<K, V> left,
}) {
  assert(color == black || color == doubleBlack);

  final x = left.left as InnerRBNode<K, V>;

  assert(left.color == red, 'Y should be red');
  assert(x.color == red, 'X should be red');

  final z = InnerRBNode(
    value,
    color: black,
    left: left.right,
    right: right,
  );

  return InnerRBNode(
    left.value,
    color: color - 1,
    left: x.recolor(black),
    right: z,
  );
}

/// Performers the balancing rotation on a black or double black node (Z):
///
///       Z                Y
///     /   \            /   \
///    X     4  ==>    X       Z
///  /   \            / \     / \
/// 1     Y          1   2   3   4
///     /   \
///    2     3
///
/// Assumes that the node has a left red child (X) and that X also has a right
/// red child (Y).
InnerRBNode<K, V> rotateLeftRight<K, V extends Comparable>({
  required V value,
  required int color,
  required RBNode<K, V> right,
  required InnerRBNode<K, V> left,
}) {
  assert(color == black || color == doubleBlack);

  final y = left.right as InnerRBNode<K, V>;

  assert(left.color == red, 'X should be red');
  assert(y.color == red, 'Y should be red');

  final z = InnerRBNode(
    value,
    color: black,
    left: y.right,
    right: right,
  );

  final x = InnerRBNode(
    left.value,
    color: black,
    left: left.left,
    right: y.left,
  );

  return InnerRBNode(
    y.value,
    color: color - 1,
    left: x,
    right: z,
  );
}

/// Performers the balancing rotation on a black or double black node (X):
///
///    X                      Y
///  /   \                  /   \
/// 1     Y        ==>    X       Z
///     /   \            / \     / \
///    2     Z          1   2   3   4
///        /   \
///       3     4
///
/// Assumes that the node has a right red child (Y) and that Y also has a right
/// red child (Z).
InnerRBNode<K, V> rotateRightRight<K, V extends Comparable>({
  required V value,
  required int color,
  required InnerRBNode<K, V> right,
  required RBNode<K, V> left,
}) {
  assert(color == black || color == doubleBlack);

  final z = right.right as InnerRBNode<K, V>;

  assert(right.color == red, 'Y should be red');
  assert(z.color == red, 'Z should be red');

  final x = InnerRBNode(
    value,
    color: black,
    left: left,
    right: right.left,
  );

  return InnerRBNode(
    right.value,
    color: color - 1,
    left: x,
    right: z.recolor(black),
  );
}

/// Performers the balancing rotation on a black or double black node (X):
///
///    X                   Y
///  /   \               /   \
/// 1     Z     ==>    X       Z
///     /   \         / \     / \
///    Y     4       1   2   3   4
///  /   \
/// 2     3
///
/// Assumes that the node has a right red child (Z) and that Z also has a left
/// red child (Y).
InnerRBNode<K, V> rotateRightLeft<K, V extends Comparable>({
  required V value,
  required int color,
  required InnerRBNode<K, V> right,
  required RBNode<K, V> left,
}) {
  assert(color == black || color == doubleBlack);

  final y = right.left as InnerRBNode<K, V>;

  assert(right.color == red, 'Z should be red');
  assert(y.color == red, 'Y should be red');

  final x = InnerRBNode(
    value,
    color: black,
    left: left,
    right: y.left,
  );

  final z = InnerRBNode(
    right.value,
    color: black,
    left: y.right,
    right: right.right,
  );

  return InnerRBNode(
    y.value,
    color: color - 1,
    left: x,
    right: z,
  );
}

/// Performers the balancing rotation on a double black node (Z):
///
///          Z                  Y
///        /   \              /   \
///       X     5  ==>      X       Z
///     /   \              / \     / \
///   W       Y           W   3   4   5
///  / \     / \         / \
/// 1   2   3   4       1   2
///
/// Assumes that the node has a right negative black child (X) and that X also
/// has a left black child (W) and a right black child (Y).
InnerRBNode<K, V> rotateLeftNegative<K, V extends Comparable>({
  required V value,
  required int color,
  required RBNode<K, V> right,
  required InnerRBNode<K, V> left,
}) {
  assert(color == doubleBlack);
  assert(left.color == negativeBlack);

  final w = left.left;
  final y = left.right as InnerRBNode<K, V>;

  assert(w.color == black);
  assert(y.color == black);

  final z = InnerRBNode(
    value,
    color: black,
    left: y.right,
    right: right,
  );

  final x = rebalance(
    value: left.value,
    color: black,
    left: w.recolor(red),
    right: y.left,
  );

  return InnerRBNode(y.value, color: black, left: x, right: z);
}

/// Performers the balancing rotation on a double black node (Z):
///
///    Z                     Y
///  /   \                 /   \
/// 5     X       ==>    Z       X
///     /   \           / \     / \
///   Y       W        5   4   3   W
///  / \     / \                  / \
/// 4   3   2   1                2   1
///
/// Assumes that the node has a right negative black child (X) and that X also
/// has a left black child (Y) and a right black child (W).
InnerRBNode<K, V> rotateRightNegative<K, V extends Comparable>({
  required V value,
  required int color,
  required InnerRBNode<K, V> right,
  required RBNode<K, V> left,
}) {
  assert(color == doubleBlack);
  assert(right.color == negativeBlack);

  final w = right.right;
  final y = right.left as InnerRBNode<K, V>;

  assert(w.color == black);
  assert(y.color == black);

  final z = InnerRBNode(
    value,
    color: black,
    left: left,
    right: y.left,
  );

  final x = rebalance(
    value: right.value,
    color: black,
    left: y.right,
    right: w.recolor(red),
  );

  return InnerRBNode(y.value, color: black, left: z, right: x);
}

/// Rebalances the tree if necessary depending on the color of the children.
InnerRBNode<K, V> rebalance<K, V extends Comparable>({
  required V value,
  required int color,
  required RBNode<K, V> right,
  required RBNode<K, V> left,
}) {
  if (color > red) {
    if (left.color == red) {
      if (left.left.color == red) {
        return rotateLeftLeft(
          value: value,
          color: color,
          right: right,
          left: left as InnerRBNode<K, V>,
        );
      } else if (left.right.color == red) {
        return rotateLeftRight(
          value: value,
          color: color,
          right: right,
          left: left as InnerRBNode<K, V>,
        );
      }
    } else if (right.color == red) {
      if (right.left.color == red) {
        return rotateRightLeft(
          value: value,
          color: color,
          right: right as InnerRBNode<K, V>,
          left: left,
        );
      } else if (right.right.color == red) {
        return rotateRightRight(
          value: value,
          color: color,
          right: right as InnerRBNode<K, V>,
          left: left,
        );
      }
    }

    if (color == doubleBlack) {
      if (left.color == negativeBlack) {
        return rotateLeftNegative(
          value: value,
          color: color,
          right: right,
          left: left as InnerRBNode<K, V>,
        );
      } else if (right.color == negativeBlack) {
        return rotateRightNegative(
          value: value,
          color: color,
          right: right as InnerRBNode<K, V>,
          left: left,
        );
      }
    }
  }

  return InnerRBNode(value, color: color, left: left, right: right);
}

/// Moves double-blacks from children to parents, or eliminates them entirely if possible.
InnerRBNode<K, V> bubbleUp<K, V extends Comparable>({
  required V value,
  required int color,
  required RBNode<K, V> right,
  required RBNode<K, V> left,
}) {
  if (left.color == doubleBlack || right.color == doubleBlack) {
    return rebalance(
      value: value,
      color: color + 1,
      right: right.recolor(right.color - 1),
      left: left.recolor(left.color - 1),
    );
  }

  return InnerRBNode(value, color: color, right: right, left: left);
}

abstract class RBNode<K, V extends Comparable> implements TreeNode<K, V> {
  const RBNode();

  bool get isLeaf;

  /// The color of this node.
  ///
  ///  2: Double black
  ///  1: Black
  ///  0: Red
  /// -1: Negative black
  int get color;

  RBNode<K, V> get left;
  RBNode<K, V> get right;

  /// Helper to recolor a node, can also recolor a leaf.
  RBNode<K, V> recolor(int color);

  /// Only called once on the root node.
  ///
  /// Handles recoloring the root if necessary and delegates the actual
  /// insertion to rbInsert.
  @override
  RBNode<K, V> insert(K key, V value);

  /// Helper method for insert.
  RBNode<K, V> rbInsert(K key, V value);

  @override
  RBNode<K, V> delete(K key);

  /// Helper method for delete.
  RBNode<K, V> rbDelete(K key);

  /// Gets the value of the right most inner node and deletes it.
  ///
  /// This is a helper method for the delete function to find the replacement
  /// for the deleted node when it has two children.
  RBNode<K, V> deleteRightMostChild(InnerRBNode<K, V> parent, ReferenceBox<V> result);

  @override
  Result<V> find(K key) => throw UnimplementedError();
}

class LeafRBNode<K, V extends Comparable> extends RBNode<K, V> {
  @override
  final int color;

  const LeafRBNode([this.color = black]);

  @override
  bool get isEmpty => true;

  @override
  bool get isLeaf => true;

  @override
  RBNode<K, V> get left => recolor(black);
  @override
  RBNode<K, V> get right => recolor(black);

  RBNode<K, V> recolor(int color) {
    assert(color == black || color == doubleBlack);

    if (this.color == color) {
      return this;
    }

    return LeafRBNode(color);
  }

  @override
  RBNode<K, V> insert(K key, V value) => InnerRBNode(value, color: black, left: this, right: this);

  @override
  RBNode<K, V> rbInsert(K key, V value) => InnerRBNode(value, color: red, left: this, right: this);

  @override
  RBNode<K, V> delete(K key) => throw const TreeResetOperationException();

  @override
  RBNode<K, V> rbDelete(K key) => throw const TreeResetOperationException();

  @override
  RBNode<K, V> deleteRightMostChild(InnerRBNode<K, V> parent, ReferenceBox<V> result) {
    result.value = parent.value;

    return parent.left;
  }

  @override
  Iterable<TreeEntry<K, V>> get entries => Iterable<TreeEntry<K, V>>.empty();
}

class InnerRBNode<K, V extends Comparable> extends RBNode<K, V> implements TreeEntry<K, V> {
  @override
  final V value;

  @override
  final int color;

  @override
  final RBNode<K, V> left;
  @override
  final RBNode<K, V> right;

  const InnerRBNode(
    this.value, {
    required this.color,
    required this.left,
    required this.right,
  }) : assert(color >= negativeBlack && color <= doubleBlack);

  @override
  bool get isEmpty => false;

  @override
  bool get isLeaf => false;

  @override
  RBNode<K, V> recolor(int color) {
    if (this.color == color) {
      return this;
    }

    return InnerRBNode(
      value,
      color: color,
      left: left,
      right: right,
    );
  }

  @override
  RBNode<K, V> insert(K key, V value) => rbInsert(key, value).recolor(black);

  @override
  RBNode<K, V> rbInsert(K key, V value) {
    final comp = this.value.compareTo(key);

    if (comp > 0) {
      final result = left.rbInsert(key, value);

      return rebalance(
        value: this.value,
        color: color,
        left: result,
        right: right,
      );
    } else if (comp < 0) {
      final result = right.rbInsert(key, value);

      return rebalance(
        value: this.value,
        color: color,
        left: left,
        right: result,
      );
    }

    if (value != this.value) {
      return InnerRBNode(
        value,
        color: color,
        left: left,
        right: right,
      );
    }

    throw const TreeResetOperationException();
  }

  @override
  RBNode<K, V> delete(K key) => rbDelete(key).recolor(black);

  @override
  RBNode<K, V> rbDelete(K key) {
    final comp = value.compareTo(key);

    if (comp > 0) {
      final result = left.rbDelete(key);

      return bubbleUp(
        value: value,
        color: color,
        left: result,
        right: right,
      );
    } else if (comp < 0) {
      final result = right.rbDelete(key);

      return bubbleUp(
        value: value,
        color: color,
        left: left,
        right: result,
      );
    }

    // if both children are leafs
    if (left.isLeaf && right.isLeaf) {
      if (color == red) {
        return left;
      } else {
        assert(color == black);

        return left.recolor(doubleBlack);
      }
    }

    // if at least one child is a leaf
    if (left.isLeaf) {
      return right.recolor(black);
    }
    if (right.isLeaf) {
      return left.recolor(black);
    }

    // if there are no leafs at all
    final rightMostRef = ReferenceBox<V>();
    final leftUpdated = left.right.deleteRightMostChild(left as InnerRBNode<K, V>, rightMostRef);
    assert(rightMostRef.accessed);

    return InnerRBNode(
      rightMostRef.value,
      color: color,
      left: leftUpdated,
      right: right,
    );
  }

  @override
  RBNode<K, V> deleteRightMostChild(InnerRBNode<K, V> parent, ReferenceBox<V> result) {
    final node = right.deleteRightMostChild(this, result);

    return InnerRBNode(
      parent.value,
      color: parent.color,
      right: node,
      left: parent.left,
    );
  }

  @override
  Iterable<TreeEntry<K, V>> get entries sync* {
    yield* left.entries;
    yield this;
    yield* right.entries;
  }
}

/// For testing only, creates a string representation of the tree that can be
/// viewed with: https://dreampuf.github.io/GraphvizOnline/
String graphviz(RBNode root) {
  final buffer = StringBuffer();
  buffer.writeln('digraph G {');

  if (root is InnerRBNode) {
    _graphviz(buffer, root);
  }

  buffer.writeln('}');
  return buffer.toString();
}

void _graphviz(StringBuffer buffer, InnerRBNode node) {
  final value = node.value;
  final right = node.right;
  final left = node.left;

  switch (node.color) {
    case doubleBlack:
      buffer.writeln('"$value"[label="$value (BB)", fillcolor="yellow", style="filled"]');
      break;
    case black:
      buffer.writeln('"$value"[fillcolor="black", style="filled", fontcolor="white"]');
      break;
    case red:
      buffer.writeln('"$value"[fillcolor="red", style="filled", fontcolor="black"]');
      break;
    case negativeBlack:
      buffer.writeln('"$value"[label="$value (NB)", fillcolor="yellow", style="filled"]');
      break;
    default:
      throw UnsupportedError('${node.color} is not a valid color');
  }

  if (right is InnerRBNode) {
    buffer.writeln('"$value"->"${right.value}"[label="R"]');
    _graphviz(buffer, right);
  }
  if (left is InnerRBNode) {
    buffer.writeln('"$value"->"${left.value}"[label="L"]');
    _graphviz(buffer, left);
  }
}
