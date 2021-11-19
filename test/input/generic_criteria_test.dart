import 'package:flutter_test/flutter_test.dart' hide equals;
import 'package:formz/formz.dart' hide isTrue, isFalse;
import 'package:formz_test/formz_test.dart';

void _criteriaTest<T>(
  String description, {
  required ValidationFunc<T> criteria,
  required List<T> valid,
  required List<T> invalid,
}) {
  group(description, () {
    for (final input in valid) test('$description: "$input" should be valid', () => expect(criteria(input), isTrue));

    for (final input in invalid)
      test('$description: "$input" should be invalid', () => expect(criteria(input), isFalse));
  });
}

void _castCriteriaTest<T, S>(
  String description, {
  required CastFunc<T, S> cast,
  required List<T> valid,
  required List<T> invalid,
}) {
  group(description, () {
    for (final input in valid) test('$description: "$input" should be valid', () => expect(cast(input), isNotNull));

    for (final input in invalid) test('$description: "$input" should be invalid', () => expect(cast(input), isNull));
  });
}

void main() {
  _criteriaTest<String?>(
    'notNull',
    criteria: notNull(),
    valid: ['', 'test'],
    invalid: [null],
  );

  _criteriaTest<String?>(
    'equals',
    criteria: equals('value'),
    valid: ['value'],
    invalid: ['v', '', null],
  );

  _criteriaTest<String?>(
    'stringNotEmpty',
    criteria: stringNotEmpty(),
    valid: ['test'],
    invalid: [null, ''],
  );

  _criteriaTest<String?>(
    'regexMatches',
    criteria: regexMatches(regex: RegExp('[a-d]')),
    valid: ['a', 'b', 'ea'],
    invalid: ['e', '44', null],
  );

  _castCriteriaTest<String?, int>(
    'isInt',
    cast: isInt(),
    valid: ['-2', '5'],
    invalid: ['', 'gg', null],
  );

  _criteriaTest<double?>(
    'isBetween',
    criteria: inRange(min: 0, max: 5),
    valid: [0, 0.2, 4, 5],
    invalid: [-0.2, 5.1, 6, null],
  );

  _criteriaTest<String?>(
    'lengthMatches',
    criteria: getStringLength(equals(3)),
    valid: ['aaa', '3_ ', 'ggg'],
    invalid: [null, '', 'aa', 'aaaa'],
  );
}
