part of 'field_mapping_test.dart';

bool _shouldMatchDefault(dynamic _) => true;
bool _shouldMatchNotRelated(dynamic _) => false;

dynamic _getResultFieldNotRelated(dynamic _) => null;

Matcher _validateEquals(dynamic _, dynamic field) => equals(field);
Matcher _validateNotRelated(dynamic _, dynamic __) => isNull;

typedef GetSourceField<Source, SourceType> = SourceType Function(Source source);
typedef SetSourceField<Source, SourceType> = Source Function(Source source, SourceType value);
typedef GetResultField<Result> = dynamic Function(Result result);
typedef ShouldMatch<Source> = bool Function(Source source);
typedef Validate<Source, SourceType> = Matcher Function(Source source, SourceType field);

class FieldMapping<Source, SourceType, Result> {
  final GetSourceField<Source, SourceType> _getSourceField;
  final SetSourceField<Source, SourceType> _setSourceField;
  final GetResultField<Result> _getResultField;

  final ShouldMatch<Source> _shouldMatch;
  final Validate<Source, SourceType> _validate;

  final List<SourceType> values;
  final List<SourceType> invalidValues;

  const FieldMapping({
    required GetSourceField<Source, SourceType> getSourceField,
    required SetSourceField<Source, SourceType> setSourceField,
    required GetResultField<Result> getResultField,
    required Validate<Source, SourceType> validate,
    required this.values,
    ShouldMatch<Source> shouldMatch = _shouldMatchDefault,
    this.invalidValues = const [],
  })  : _getSourceField = getSourceField,
        _setSourceField = setSourceField,
        _getResultField = getResultField,
        _validate = validate,
        _shouldMatch = shouldMatch;

  const FieldMapping.equals({
    required GetSourceField<Source, SourceType> getSourceField,
    required SetSourceField<Source, SourceType> setSourceField,
    required GetResultField<Result> getResultField,
    required this.values,
    ShouldMatch<Source> shouldMatch = _shouldMatchDefault,
    this.invalidValues = const [],
  })  : _getSourceField = getSourceField,
        _setSourceField = setSourceField,
        _getResultField = getResultField,
        _shouldMatch = shouldMatch,
        _validate = _validateEquals;

  const FieldMapping.notRelated({
    required GetSourceField<Source, SourceType> getSourceField,
    required SetSourceField<Source, SourceType> setSourceField,
    required this.values,
    this.invalidValues = const [],
  })  : _getSourceField = getSourceField,
        _setSourceField = setSourceField,
        _getResultField = _getResultFieldNotRelated,
        _shouldMatch = _shouldMatchNotRelated,
        _validate = _validateNotRelated;

  SourceType getSourceField(Source source) => _getSourceField(source);

  Source setSourceField(Source source, covariant SourceType value) => _setSourceField(source, value);

  dynamic getResultField(covariant Result result) => _getResultField(result);

  Matcher validate(Source source, covariant SourceType field) => _validate(source, field);

  bool shouldMatch(Source source) => _shouldMatch(source);

  Matcher checkResultType(dynamic result) => isA<Result>();

  String resultTypeStr() => '$Result';
}
