import 'package:flutter_test/flutter_test.dart';
import 'package:formz/src/functional/structures/tree_set.dart';
import 'package:formz/src/functional/structures/trees/tree.dart';
import 'package:formz_test/formz_test.dart';

import 'tree_map_test.dart';
import 'tree_set_test.dart';

void expectInvariant(AVLNode node) {
  if (node is LeafAVLNode) return;
  expect(node.right.height - node.left.height, inInclusiveRange(-1, 1));

  expectInvariant(node.left);
  expectInvariant(node.right);
}

void main() {
  final AVLNode<num, num> tree = LeafAVLNode<num, num>();

  group('balancing', () {
    test('in order asc insert', () {
      var t = tree;

      for (int i = 0; i < 100; i++) {
        t = t.insert(i, 0);
      }

      expect(t.height, equals(6));
      expectInvariant(t);
    });

    test('in order dsc insert', () {
      var t = tree;

      for (int i = 100; i > 0; i--) {
        t = t.insert(i, i);
      }

      expect(t.height, equals(6));
      expectInvariant(t);
    });

    test('right left rotation', () {
      final result = tree.insert(0, 0).insert(2, 2).insert(1, 1);

      expect(result.height, equals(1));
      expectInvariant(result);
    });

    test('left right rotation', () {
      final result = tree.insert(0, 0).insert(-2, -2).insert(-1, -1);

      expect(result.height, equals(1));
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

  group('map', () => runMapTest(() => TreeMap<int, String>.avl()));

  group('set', () => runSetTest(() => TreeSet<int>.avl()));
}
