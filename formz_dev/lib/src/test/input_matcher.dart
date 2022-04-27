import 'package:formz/formz.dart';

const testInputId = InputIdentifier<String>.named('test');

Input<String> createTestInput(
  String value, {
  InputIdentifier<String> id = testInputId,
  bool valid = true,
  bool pure = false,
}) =>
    createInput((_) => valid, value: value, id: id, pure: pure);

final isPure = pureMatches(isTrue);

final isValid = validMatches(isTrue);

final isInvalid = validMatches(isFalse);

InputMatcher failureMatches(Object? input) => inputMatches(failure: input ?? isNull);

InputMatcher valueMatches(Object? input) => inputMatches(value: input ?? isNull);

InputMatcher pureMatches(Object? input) => inputMatches(pure: input ?? isNull);

InputMatcher validMatches(Object? input) => inputMatches(valid: input ?? isNull);

InputMatcher inputMatches({
  Object? failure,
  Object? value,
  Object? pure,
  Object? valid,
}) =>
    InputMatcher._(failure, value, pure, valid);

class _DummyMatcher extends Matcher {
  @override
  Description describe(Description description) {
    description.add('dummy matcher');
    return description;
  }

  @override
  bool matches(item, Map matchState) => true;
}

class InputMatcher extends Matcher {
  final Object? failure;
  final Object? value;
  final Object? pure;
  final Object? valid;

  InputMatcher._(this.failure, this.value, this.pure, this.valid)
      : assert(failure != null || value != null || pure != null || valid != null);

  void _addDescription(String name, Object? value, Description description) {
    if (value == null) return;

    if (value is Matcher) {
      description.add('$name should match: ');
      value.describe(description);
      description.add(', ');
    } else {
      description.add('$name should be equal to: $value');
    }
  }

  @override
  Description describe(Description description) {
    _addDescription('failure', failure, description);
    _addDescription('value', value, description);
    _addDescription('pure', pure, description);
    _addDescription('valid', valid, description);

    return description;
  }

  bool _matchProperty(Object? matcher, Object? property, Map matchState) {
    if (matcher == null) return true;
    if (matcher is Matcher) return matcher.matches(property, matchState);

    return equals(property).matches(matcher, matchState);
  }

  @override
  bool matches(item, Map matchState) {
    if (item is Input) {
      return _matchProperty(failure, item.failure, matchState) &&
          _matchProperty(value, item.value, matchState) &&
          _matchProperty(pure, item.pure, matchState) &&
          _matchProperty(value, item.value, matchState);
    }

    return false;
  }

  Matcher ignoreError() {
    if (value == null && pure == null && valid == null) return _DummyMatcher();

    return InputMatcher._(null, value, pure, valid);
  }

  @override
  String toString() {
    final builder = StringDescription();
    return describe(builder).toString();
  }
}
