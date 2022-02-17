import 'package:flutter_test/flutter_test.dart';
import 'package:formz/src/functional/structures/avl_tree.dart';

void expectInvariant(AVLNode node) {
  if (node is LeafAVLNode) return;
  expect(node.right.height - node.left.height, inInclusiveRange(-1, 1));

  expectInvariant(node.left);
  expectInvariant(node.right);
}

void main() {
  late AVLTree tree;

  setUp(() => tree = AVLTree());

  test('in order asc insert', () {
    for (int i = 0; i < 100; i++) {
      tree = tree.insert(i);
    }

    expect(tree.root.height, equals(6));
    expectInvariant(tree.root);
  });

  test('in order dsc insert', () {
    for (int i = 100; i > 0; i--) {
      tree = tree.insert(i);
    }

    expect(tree.root.height, equals(6));
    expectInvariant(tree.root);
  });

  test('right left rotation', () {
    tree = tree.insert(0).insert(2).insert(1);

    expect(tree.root.height, equals(1));
    expectInvariant(tree.root);
  });

  test('left right rotation', () {
    tree = tree.insert(0).insert(-2).insert(-1);

    expect(tree.root.height, equals(1));
    expectInvariant(tree.root);
  });

  test('insert duplicate', () {
    final tree1 = tree.insert(1);
    final tree2 = tree1.insert(1);

    expect(tree1.root, same(tree2.root));
  });
}
