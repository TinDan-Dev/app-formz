import 'dart:math';

import '../../utils/next_iterator.dart';
import 'avl_tree.dart';

/// Creates an avl tree from an iterator in O(n log n).
///
/// The iterator must have exactly [size] elements, be sorted and not contain
/// any duplicates. This is method is more efficient then inserting all elements
/// one after the other, because this method only creates one tree.
AVLNode<K, V> fromIterator<K, V extends Comparable>(Iterator<V> sortedIterator, int size) =>
    _fromIterator(sortedIterator, LeafAVLNode<K, V>(), size);

AVLNode<K, V> _fromIterator<K, V extends Comparable>(Iterator<V> sortedIterator, LeafAVLNode<K, V> leaf, int size) {
  if (size <= 0) return leaf;

  final leftSize = size ~/ 2;
  final rightSize = max(0, size - leftSize - 1);

  final left = _fromIterator(sortedIterator, leaf, leftSize);

  sortedIterator.moveNext();
  final value = sortedIterator.current;

  final right = _fromIterator(sortedIterator, leaf, rightSize);

  return InnerAVLNode<K, V>(
    value,
    height: max(left.height, right.height) + 1,
    left: left,
    right: right,
  );
}

AVLNode<K, V> intersect<K, V extends Comparable>(AVLNode<K, V> a, AVLNode<K, V> b) {
  final it = AVLIntersectIterator<V>(a.entries.iterator, b.entries.iterator);

  final list = <V>[];
  while (it.moveNext()) {
    list.add(it.current);
  }

  return fromIterator(list.iterator, list.length);
}

class AVLIntersectIterator<V extends Comparable> extends Iterator<V> {
  final Iterator<V> a;
  final Iterator<V> b;

  @override
  V get current => a.current;

  AVLIntersectIterator(this.a, this.b);

  @override
  bool moveNext() {
    if (!a.moveNext()) return false;
    if (!b.moveNext()) return false;

    while (true) {
      final result = a.current.compareTo(b.current);

      if (result < 0) {
        if (!a.moveNext()) break;
      } else if (result > 0) {
        if (!b.moveNext()) break;
      } else {
        return true;
      }
    }

    return false;
  }
}

AVLNode<K, V> union<K, V extends Comparable>(AVLNode<K, V> a, AVLNode<K, V> b) {
  final it = AVLUnionIterator<V>(a.entries.iterator, b.entries.iterator);

  final list = <V>[];
  while (it.hasNext) {
    list.add(it.next());
  }

  return fromIterator(list.iterator, list.length);
}

class AVLUnionIterator<V extends Comparable> extends NextIterator<V> {
  final PeekIterator<V> a;
  final PeekIterator<V> b;

  @override
  bool get hasNext => a.hasNext || b.hasNext;

  AVLUnionIterator(Iterator<V> a, Iterator<V> b)
      : a = PeekIterator.from(a),
        b = PeekIterator.from(b);

  @override
  V next() {
    if (!a.hasNext) {
      return b.next();
    }
    if (!b.hasNext) {
      return a.next();
    }

    final result = a.peek.compareTo(b.peek);
    if (result < 0) {
      return a.next();
    } else if (result > 0) {
      return b.next();
    } else {
      a.next();
      return b.next();
    }
  }
}

AVLNode<K, V> minus<K, V extends Comparable>(AVLNode<K, V> a, AVLNode<K, V> b) {
  final it = AVLMinusIterator<V>(a.entries.iterator, b.entries.iterator);

  final list = <V>[];
  while (it.moveNext()) {
    list.add(it.current);
  }

  return fromIterator(list.iterator, list.length);
}

class AVLMinusIterator<V extends Comparable> extends Iterator<V> {
  final Iterator<V> a;
  final PeekIterator<V> b;

  @override
  V get current => a.current;

  AVLMinusIterator(this.a, b) : b = PeekIterator.from(b);

  @override
  bool moveNext() {
    while (true) {
      if (!a.moveNext()) return false;

      while (true) {
        if (!b.hasNext) return true;

        final result = a.current.compareTo(b.peek);
        if (result < 0) {
          return true;
        } else if (result > 0) {
          b.next();
          continue;
        } else {
          b.next();
          break;
        }
      }
    }
  }
}
