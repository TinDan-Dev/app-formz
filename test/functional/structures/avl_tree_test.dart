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
  late AVLTree populatedTree;

  setUp(() {
    tree = const AVLTree();
    populatedTree = const AVLTree();

    for (int i = -99; i < 100; i++) {
      populatedTree = populatedTree.insert(i);
    }
  });

  group('balancing', () {
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
  });

  group('contains', () {
    test('false on empty tree', () {
      expect(tree.contains(0), isFalse);
    });

    test('true if the value was inserted before', () {
      tree = tree.insert(0);

      expect(tree.contains(0), isTrue);
    });

    test('true on copy after insert and false on original', () {
      final copy = tree.insert(0);

      expect(tree.contains(0), isFalse);
      expect(copy.contains(0), isTrue);
    });

    test('true after many inserts', () {
      for (int i = 0; i < 100; i++) {
        tree = tree.insert(i);
      }

      expect(tree.contains(42), isTrue);
    });
  });

  group('insert', () {
    test('should not change the tree when value was already inserted', () {
      final result = populatedTree.insert(0);

      expect(result, same(populatedTree));
    });
  });

  group('delete', () {
    test('should not change the tree when value was not found', () {
      final result = populatedTree.delete(300);

      expect(result, same(populatedTree));
    });

    test('should remove value from tree', () {
      final result = populatedTree.delete(0);

      expectInvariant(result.root);
      expect(result.contains(0), isFalse);
      expect(populatedTree.contains(0), isTrue);
    });
  });
}
