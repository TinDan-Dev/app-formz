import '../../result/result.dart';
import 'tree.dart';

/// Performers the balancing rotation on a node (Z):
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
  required RBNode<K, V> right,
  required InnerRBNode<K, V> left,
}) {
  final x = left.left as InnerRBNode<K, V>;

  assert(left.color, 'Y should be red');
  assert(x.color, 'X should be red');

  final z = InnerRBNode(
    value,
    color: false,
    left: left.right,
    right: right,
  );

  return InnerRBNode(
    left.value,
    left: x.colorBlack(),
    right: z,
  );
}

/// Performers the balancing rotation on a node (Z):
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
  required RBNode<K, V> right,
  required InnerRBNode<K, V> left,
}) {
  final y = left.right as InnerRBNode<K, V>;

  assert(left.color, 'X should be red');
  assert(y.color, 'Y should be red');

  final z = InnerRBNode(
    value,
    color: false,
    left: y.right,
    right: right,
  );

  final x = InnerRBNode(
    left.value,
    color: false,
    left: left.left,
    right: y.left,
  );

  return InnerRBNode(
    y.value,
    left: x,
    right: z,
  );
}

/// Performers the balancing rotation on a node (X):
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
  required InnerRBNode<K, V> right,
  required RBNode<K, V> left,
}) {
  final z = right.right as InnerRBNode<K, V>;

  assert(right.color, 'Y should be red');
  assert(z.color, 'Z should be red');

  final x = InnerRBNode(
    value,
    color: false,
    left: left,
    right: right.left,
  );

  return InnerRBNode(
    right.value,
    left: x,
    right: z.colorBlack(),
  );
}

/// Performers the balancing rotation on a node (X):
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
  required InnerRBNode<K, V> right,
  required RBNode<K, V> left,
}) {
  final y = right.left as InnerRBNode<K, V>;

  assert(right.color, 'Z should be red');
  assert(y.color, 'Y should be red');

  final x = InnerRBNode(
    value,
    color: false,
    left: left,
    right: y.left,
  );

  final z = InnerRBNode(
    right.value,
    color: false,
    left: y.right,
    right: right.right,
  );

  return InnerRBNode(
    y.value,
    left: x,
    right: z,
  );
}

/// Rebalances the tree if necessary depending on the color of the children.
InnerRBNode<K, V> rebalance<K, V extends Comparable>({
  required V value,
  required bool color,
  required RBNode<K, V> right,
  required RBNode<K, V> left,
}) {
  if (left.color) {
    if (left.left.color) {
      return rotateLeftLeft(value: value, right: right, left: left as InnerRBNode<K, V>);
    } else if (left.right.color) {
      return rotateLeftRight(value: value, right: right, left: left as InnerRBNode<K, V>);
    }
  } else if (right.color) {
    if (right.left.color) {
      return rotateRightLeft(value: value, right: right as InnerRBNode<K, V>, left: left);
    } else if (right.right.color) {
      return rotateRightRight(value: value, right: right as InnerRBNode<K, V>, left: left);
    }
  }

  return InnerRBNode(value, color: color, left: left, right: right);
}

abstract class RBNode<K, V extends Comparable> implements TreeNode<K, V> {
  const RBNode();

  bool get isLeaf;

  /// The color of this node.
  ///
  /// False is black and true is red.
  bool get color;

  RBNode<K, V> get left;
  RBNode<K, V> get right;

  @override
  RBNode<K, V> insert(K key, V value);

  @override
  RBNode<K, V> delete(K key);

  @override
  Result<V> find(K key) => throw UnimplementedError();
}

class LeafRBNode<K, V extends Comparable> extends RBNode<K, V> {
  const LeafRBNode();

  @override
  bool get isEmpty => true;

  @override
  bool get isLeaf => true;

  @override
  bool get color => false;

  @override
  RBNode<K, V> get left => this;
  @override
  RBNode<K, V> get right => this;

  @override
  RBNode<K, V> insert(K key, V value) => InnerRBNode(value, left: this, right: this);

  @override
  Iterable<TreeEntry<K, V>> get entries => Iterable<TreeEntry<K, V>>.empty();
}

class InnerRBNode<K, V extends Comparable> extends RBNode<K, V> implements TreeEntry<K, V> {
  @override
  final V value;

  @override
  final bool color;

  @override
  final RBNode<K, V> left;
  @override
  final RBNode<K, V> right;

  const InnerRBNode(
    this.value, {
    this.color = true,
    required this.left,
    required this.right,
  });

  @override
  bool get isEmpty => false;

  @override
  bool get isLeaf => false;

  InnerRBNode<K, V> colorBlack() => InnerRBNode(
        value,
        color: false,
        left: left,
        right: right,
      );

  @override
  RBNode<K, V> insert(K key, V value) {
    final comp = this.value.compareTo(key);

    if (comp > 0) {
      final result = left.insert(key, value);

      return rebalance(
        value: this.value,
        color: color,
        left: result,
        right: right,
      );
    } else if (comp < 0) {
      final result = right.insert(key, value);

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
        left: left,
        right: right,
      );
    }

    throw const TreeResetOperationException();
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

  if (node.color) {
    buffer.writeln('"$value"[color="red"]');
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
