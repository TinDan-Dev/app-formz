import 'package:flutter_test/flutter_test.dart';
import 'package:formz/src/functional/structures/trees/rb_tree.dart';
import 'package:formz/src/functional/structures/trees/tree.dart';

void expectInvariant(RBNode node) {
  expectRBInvariant(node, true);
  expectPathInvariant(node);
}

void expectRBInvariant(RBNode node, bool isRoot) {
  if (node is LeafRBNode) return;

  if (node.color && !isRoot) {
    expect(node.left.color, isFalse);
    expect(node.right.color, isFalse);
  }

  expectRBInvariant(node.left, false);
  expectRBInvariant(node.right, false);
}

int expectPathInvariant(RBNode node) {
  if (node is LeafRBNode) return 0;

  expect(node.left, isNot(same(node)));
  expect(node.right, isNot(same(node)));

  final left = expectPathInvariant(node.left);
  final right = expectPathInvariant(node.right);

  expect(left, equals(right));

  if (node.color) {
    return left;
  } else {
    return left + 1;
  }
}

void main() {
  final RBNode<num, num> tree = LeafRBNode<num, num>();

  group('balancing', () {
    test('in order asc insert', () {
      var t = tree;

      for (int i = 0; i < 100; i++) {
        t = t.insert(i, i);
      }
      expectInvariant(t);
    });

    test('in order dsc insert', () {
      var t = tree;

      for (int i = -99; i >= 0; i--) {
        t = t.insert(i, i);
      }
      expectInvariant(t);
    });

    test('right left rotation', () {
      final result = tree.insert(0, 0).insert(2, 2).insert(1, 1);

      expectInvariant(result);
    });

    test('left right rotation', () {
      final result = tree.insert(0, 0).insert(-2, -2).insert(-1, -1);

      expectInvariant(result);
    });

    test('deletion', () {
      var t = tree;

      for (int i = 0; i < 100; i++) {
        t = t.insert(i, i);
      }

      for (int i = 20; i < 80; i += 3) {
        t = t.delete(i);
        expectInvariant(t);
      }
    });
  });
}
