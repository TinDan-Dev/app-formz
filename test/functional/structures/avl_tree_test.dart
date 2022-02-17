import 'package:flutter_test/flutter_test.dart';
import 'package:formz/src/functional/structures/avl_tree.dart';

void expectInvariant(AVLNode node) {
  if (node is LeafAVLNode) return;
  expect(node.right.height - node.left.height, inInclusiveRange(-1, 1));

  expectInvariant(node.left);
  expectInvariant(node.right);
}

void main() {
  var tmpTree = AVLTree<int, String>();

  for (int i = -99; i < 100; i++) {
    tmpTree = tmpTree.insert(i, 'String: $i');
  }

  final AVLTree<int, String> tree = AVLTree();
  final AVLTree<int, String> populatedTree = tmpTree;

  group('balancing', () {
    test('in order asc insert', () {
      var t = tree;

      for (int i = 0; i < 100; i++) {
        t = t.insert(i, '');
      }

      expect(t.root.height, equals(6));
      expectInvariant(t.root);
    });

    test('in order dsc insert', () {
      var t = tree;

      for (int i = 100; i > 0; i--) {
        t = t.insert(i, '');
      }

      expect(t.root.height, equals(6));
      expectInvariant(t.root);
    });

    test('right left rotation', () {
      final result = tree.insert(0, '').insert(2, '').insert(1, '');

      expect(result.root.height, equals(1));
      expectInvariant(result.root);
    });

    test('left right rotation', () {
      final result = tree.insert(0, '').insert(-2, '').insert(-1, '');

      expect(result.root.height, equals(1));
      expectInvariant(result.root);
    });
  });

  group('contains', () {
    test('false on empty tree', () {
      expect(tree.contains(0), isFalse);
    });

    test('true if the value was inserted before', () {
      final result = tree.insert(0, '');

      expect(result.contains(0), isTrue);
    });

    test('true on copy after insert and false on original', () {
      final result = tree.insert(0, '');

      expect(tree.contains(0), isFalse);
      expect(result.contains(0), isTrue);
    });

    test('true after many inserts', () {
      expect(populatedTree.contains(42), isTrue);
    });
  });

  group('insert', () {
    test('should not change the tree when value was already inserted', () {
      final result = populatedTree.insert(42, '');

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
