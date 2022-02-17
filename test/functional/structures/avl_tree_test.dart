import 'package:flutter_test/flutter_test.dart';
import 'package:formz/src/functional/structures/avl_tree.dart';

void expectInvariant(AVLNode? node) {
  if (node == null) return;
  expect(getBalance(node), inInclusiveRange(-1, 1));

  expectInvariant(node.left);
  expectInvariant(node.right);
}

void main() {
  late AVLTree tree;

  setUp(() => tree = AVLTree());

  test('in order insert', () {
    for (int i = 0; i < 10; i++) {
      tree.insert(i);
      print(tree.graphviz());
    }

    expect(tree.root, isNotNull);
    expectInvariant(tree.root);

    print(tree.graphviz());
  });
}
