import 'package:flutter_test/flutter_test.dart';
import 'package:formz_test/formz_test.dart';

void runMapTest(TreeMap<int, String> create()) {
  var tmpMap = create();

  for (int i = -99; i < 100; i++) {
    tmpMap = tmpMap.insert(i, 'String: $i');
  }

  final map = create();
  final populatedMap = tmpMap;

  test('isEmpty should be true if the map is empty', () {
    expect(map.isEmpty, isTrue);
    expect(map.isNotEmpty, isFalse);
  });

  test('isEmpty should be false if the map is not empty', () {
    expect(populatedMap.isEmpty, isFalse);
    expect(populatedMap.isNotEmpty, isTrue);
  });

  group('insert', () {
    test('in empty map', () {
      final result = map.insert(42, 'String: 42');

      expect(result.length, equals(1));
      expect(result[42], equals('String: 42'));
    });

    test('in populated map', () {
      final result = populatedMap.insert(300, 'String: 300');

      expect(result.length, equals(populatedMap.length + 1));
      expect(result[300], equals('String: 300'));
    });

    test('should not create a new map if the key has the same value', () {
      final result = populatedMap.insert(42, 'String: 42');

      expect(result, same(populatedMap));
    });

    test('should override the value if the key already has a value', () {
      final result = populatedMap.insert(42, 'String: 28');

      expect(result[42], equals('String: 28'));
      expect(result.length, populatedMap.length);
    });
  });

  group('delete', () {
    test('in empty map', () {
      final result = map.delete(42);

      expect(result.length, equals(0));
      expect(result, same(map));
    });

    test('in populated map', () {
      final result = populatedMap.delete(42);

      expect(result.length, equals(populatedMap.length - 1));
      expect(result[42], isNull);
    });

    test('should not create a new map if the key was not found', () {
      final result = populatedMap.delete(300);

      expect(result, same(populatedMap));
    });
  });

  group('find', () {
    test('in empty map', () {
      final result = map.find(42);

      expect(result, isLeft);
    });

    test('in populated map', () {
      final result = populatedMap.find(42);

      expect(result, isRightWith('String: 42'));
    });

    test('true on copy after insert and false on original', () {
      final result = map.insert(0, '');

      expect(map.find(0), isLeft);
      expect(result.find(0), isRight);
    });
  });

  group('entries', () {
    test('in empty map', () {
      final result = map.entries;

      expect(result, isEmpty);
    });

    test('in populated map', () {
      final result = populatedMap.entries;

      expect(result, isNotEmpty);
      expect(result, hasLength(199));
    });

    test('in order', () {
      int? prevElement;

      for (final element in populatedMap.entries) {
        if (prevElement != null) {
          expect(element.key, greaterThan(prevElement));
        }

        prevElement = element.key;
      }
    });
  });
}
