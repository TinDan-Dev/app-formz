import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:formz/src/functional/structures/avl_operations.dart';
import 'package:formz/src/functional/structures/avl_tree.dart';

void expectInvariant(AVLNode node) {
  if (node is LeafAVLNode) return;
  expect(node.right.height - node.left.height, inInclusiveRange(-1, 1));

  expect(node.left, isNot(same(node)));
  expect(node.right, isNot(same(node)));

  expectInvariant(node.left);
  expectInvariant(node.right);
}

void main() {
  const AVLNode<num, num> tree = LeafAVLNode<num, num>();

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

  group('from iterable', () {
    test('empty', () {
      final result = fromIterator<int, int>(<int>[].iterator, 0);

      expect(result, isA<LeafAVLNode<int, int>>());
    });

    test('not empty', () {
      final it = Iterable<int>.generate(100);
      final result = fromIterator<int, int>(it.iterator, 100);

      expect(result, isA<InnerAVLNode<int, int>>());
      expectInvariant(result);

      expect(it.every((e) => result.find(e).right), isTrue);
    });
  });

  group('intersect', () {
    final a = fromIterator<int, int>(<int>[1, 2, 3].iterator, 3);
    final b = fromIterator<int, int>(<int>[0, 1, 2, 4].iterator, 4);

    test('empty', () {
      final result = intersect(a, const LeafAVLNode());

      expect(result, isA<LeafAVLNode>());
    });

    test('not empty', () {
      final result = intersect(a, b);

      expect(result.entries, equals([1, 2]));
    });
  });

  group('union', () {
    final a = fromIterator<int, int>(<int>[1, 2, 3].iterator, 3);
    final b = fromIterator<int, int>(<int>[0, 1, 2, 4].iterator, 4);

    test('empty', () {
      final result = union(a, const LeafAVLNode());

      expect(result.entries, equals([1, 2, 3]));
    });

    test('not empty', () {
      final result = union(a, b);

      expect(result.entries, equals([0, 1, 2, 3, 4]));
    });
  });

  group('minus', () {
    final a = fromIterator<int, int>(<int>[1, 2, 3].iterator, 3);
    final b = fromIterator<int, int>(<int>[0, 1, 2, 4].iterator, 4);

    test('empty', () {
      final result = minus(a, const LeafAVLNode());

      expect(result.entries, equals([1, 2, 3]));
    });

    test('not empty', () {
      final result = minus(b, a);

      expect(result.entries, equals([0, 4]));
    });
  });
}
