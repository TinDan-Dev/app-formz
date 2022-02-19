import 'package:flutter_test/flutter_test.dart';
import 'package:formz/src/functional/structures/tree_set.dart';
import 'package:formz_test/formz_test.dart';

void runSetTest(TreeSet<int> create()) {
  var tmpSet = create();

  for (int i = -99; i < 100; i++) {
    tmpSet = tmpSet.insert(i);
  }

  final set = create();
  final populatedSet = tmpSet;

  test('isEmpty should be true if the set is empty', () {
    expect(set.isEmpty, isTrue);
    expect(set.isNotEmpty, isFalse);
  });

  test('isEmpty should be false if the set is not empty', () {
    expect(populatedSet.isEmpty, isFalse);
    expect(populatedSet.isNotEmpty, isTrue);
  });

  group('insert', () {
    test('in empty set', () {
      final result = set.insert(42);

      expect(result.length, equals(1));
      expect(result.contains(42), isTrue);
    });

    test('in populated set', () {
      final result = populatedSet.insert(
        300,
      );

      expect(result.length, equals(populatedSet.length + 1));
      expect(result.contains(300), isTrue);
    });

    test('should not create a new set if the key has the same value', () {
      final result = populatedSet.insert(42);

      expect(result, same(populatedSet));
    });
  });

  group('delete', () {
    test('in empty set', () {
      final result = set.delete(42);

      expect(result.length, equals(0));
      expect(result, same(set));
    });

    test('in populated set', () {
      final result = populatedSet.delete(42);

      expect(result.length, equals(populatedSet.length - 1));
      expect(result.contains(42), isFalse);
    });

    test('should not create a new set if the key was not found', () {
      final result = populatedSet.delete(300);

      expect(result, same(populatedSet));
    });
  });

  group('contains', () {
    test('in empty set', () {
      final result = set.contains(42);

      expect(result, isFalse);
    });

    test('in populated set', () {
      final result = populatedSet.contains(42);

      expect(result, isRight);
    });

    test('true on copy after insert and false on original', () {
      final result = set.insert(0);

      expect(set.contains(0), isFalse);
      expect(result.contains(0), isTrue);
    });
  });

  group('iterable', () {
    test('in empty set', () {
      expect(set, isEmpty);
    });

    test('in populated set', () {
      expect(populatedSet, isNotEmpty);
      expect(populatedSet, hasLength(199));
    });

    test('in order', () {
      int? prevElement;

      for (final element in populatedSet) {
        if (prevElement != null) {
          expect(element, greaterThan(prevElement));
        }

        prevElement = element;
      }
    });
  });
}
