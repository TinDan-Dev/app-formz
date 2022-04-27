// ignore_for_file: avoid_catching_errors, avoid_print

import 'package:flutter_test/flutter_test.dart';

part 'field_mapping.dart';

typedef GenericFieldMapping<S> = FieldMapping<S, Object?, Object?>;

void fieldMappingTest<Source, Result>(
  String name, {
  required List<FieldMapping<Source, dynamic, Result>> fields,
  required Result Function(Source source) convert,
  required Source initialSource,
  bool withReason = false,
  List<void Function(Source source, Result result)> expects = const [],
  List<bool Function(Source source)> invalidations = const [],
  List<Matcher> exceptionTypes = const [],
}) {
  String? createReason(
    String expected, {
    String? actual,
    required FieldMapping<Source, dynamic, Result>? causingField,
    required Source source,
    required bool valid,
  }) {
    if (!withReason) {
      return null;
    }

    final buffer = StringBuffer();

    buffer.writeln();
    buffer.writeln('Expected $expected, for input:');

    for (int i = 0; i < fields.length; i++) {
      final field = fields[i];
      final value = field.getSourceField(source);

      buffer.writeln('$i: "$value"');
    }

    if (causingField != null) {
      final causeIndex = fields.indexOf(causingField);

      buffer.writeln();
      buffer.writeln('Caused by: $causeIndex');
    }

    if (actual != null) {
      buffer.writeln();
      buffer.writeln('But got: $actual');
    }

    return buffer.toString();
  }

  void onInvalid(Source source) {
    expect(
      () => convert(source),
      throwsA(exceptionTypes.isEmpty ? anyOf(isA<Exception>(), isA<AssertionError>()) : anyOf(exceptionTypes)),
      reason: createReason(
        'exception thrown by conversion',
        causingField: null,
        source: source,
        valid: false,
      ),
    );
  }

  void onValid(Source source) {
    final Result result;
    try {
      result = convert(source);
    } catch (e) {
      fail(createReason(
            'a valid conversion',
            actual: 'Exception: $e',
            causingField: null,
            source: source,
            valid: true,
          ) ??
          e.toString());
    }

    for (final field in fields) {
      if (field.shouldMatch(source)) {
        expect(
          result,
          field.checkResultType(result),
          reason: createReason(
            'result of type ${field.resultTypeStr()}',
            actual: 'Type ${result.runtimeType}',
            causingField: field,
            source: source,
            valid: true,
          ),
        );

        expect(
          field.getResultField(result),
          field.validate(source, field.getSourceField(source)),
          reason: createReason(
            'expected valid result',
            causingField: field,
            source: source,
            valid: true,
          ),
        );
      }
    }

    for (final expect in expects) {
      expect(source, result);
    }
  }

  void _iterateSources({
    required Source sourceProvider(),
    required List<GenericFieldMapping<Source>> invalidFields,
    required int index,
  }) {
    if (index >= fields.length) {
      final bool invalid;
      final Source source;

      try {
        source = sourceProvider();

        invalid = invalidFields.any((e) => e.shouldMatch(source)) || invalidations.any((e) => e(source));
      } on AssertionError catch (e) {
        if (withReason) {
          print('Skipping input due to: $e');
        }

        return;
      }

      if (invalid) {
        onInvalid(source);
      } else {
        onValid(source);
      }

      return;
    }

    final field = fields[index];

    for (final value in field.values) {
      _iterateSources(
        sourceProvider: () => field.setSourceField(sourceProvider(), value),
        invalidFields: invalidFields,
        index: index + 1,
      );
    }

    for (final value in field.invalidValues) {
      _iterateSources(
        sourceProvider: () => field.setSourceField(sourceProvider(), value),
        invalidFields: invalidFields + [field],
        index: index + 1,
      );
    }
  }

  final combinations = fields.fold<int>(1, (acc, v) => acc * (v.values.length + v.invalidValues.length));

  test('Test "$name" with $combinations input combinations', () {
    expect(combinations < 1000000, isTrue, reason: 'The combinations should not exceed 1000000');

    _iterateSources(
      sourceProvider: () => initialSource,
      invalidFields: [],
      index: 0,
    );

    expect(withReason, isFalse, reason: 'With reason should be disabled to improve performance');
  });
}
