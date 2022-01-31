part of 'validator.dart';

typedef FieldAccess<Source, T> = T Function(Source source);

typedef IffPredicate<Source, T> = bool Function(Source source, T value);

typedef RulePredicate<T> = bool Function(T value);

typedef RuleCombiner<T> = bool Function(Iterable<RuleResult<T>> results);

abstract class Rule<Source, T> {
  final Rule<Source, T>? child;

  const Rule(this.child);

  String? get name => child?.name;

  RuleResult<T> _executeChain(Source source) {
    return child!._executeChain(source).map(
          ignore: (result) => result,
          error: (result) => result,
          success: (result) => execute(source, result.value),
        );
  }

  RuleResult<T> execute(Source source, T value);
}

class _FieldStartRule<Source, T> extends Rule<Source, T> {
  final FieldAccess<Source, T> getter;

  @override
  final String? name;

  const _FieldStartRule(this.getter, this.name) : super(null);

  @override
  RuleResult<T> _executeChain(Source source) => RuleResult.success(getter(source));

  @override
  RuleResult<T> execute(Source source, T value) => RuleResult.ignore();
}

class _StartRule<Source> extends Rule<Source, Source> {
  @override
  final String? name;

  const _StartRule(this.name) : super(null);

  @override
  RuleResult<Source> _executeChain(Source source) => RuleResult.success(source);

  @override
  RuleResult<Source> execute(Source source, Source value) => RuleResult.ignore();
}

class _MatcherRule<Source, T> extends Rule<Source, T> {
  final Matcher matcher;

  const _MatcherRule(this.matcher, {required Rule<Source, T> child}) : super(child);

  @override
  RuleResult<T> execute(Source source, T value) {
    final matchState = {};
    if (!matcher.matches(value, matchState)) {
      final description = matcher.describeMismatch(value, StringDescription(), matchState, false);
      final failure = MatchFailure(description.toString(), name: name);

      return RuleResult.error(failure);
    } else {
      return RuleResult.success(value);
    }
  }
}

class _IffRule<Source, T> extends Rule<Source, T> {
  final IffPredicate<Source, T> predicate;

  const _IffRule(this.predicate, {required Rule<Source, T> child}) : super(child);

  @override
  RuleResult<T> execute(Source source, T value) {
    if (predicate(source, value)) {
      return RuleResult.success(value);
    } else {
      return RuleResult.ignore();
    }
  }
}

class _ValidatorRule<Source, T> extends Rule<Source, T> {
  final Validator<T> validator;

  _ValidatorRule(this.validator, {required Rule<Source, T> child}) : super(child);

  @override
  RuleResult<T> execute(Source source, T value) {
    return validator.validate(value).consume(
          onRight: (_) => RuleResult.success(value),
          onLeft: RuleResult.error,
        );
  }
}

class _PredicateRule<Source, T> extends Rule<Source, T> {
  final RulePredicate<T> predicate;

  _PredicateRule(this.predicate, {required Rule<Source, T> child}) : super(child);

  @override
  RuleResult<T> execute(Source source, T value) {
    if (predicate(value)) {
      return RuleResult.success(value);
    } else {
      return RuleResult.error(ValidationFailure('predicated returned false'));
    }
  }
}

class _IterableRule<Source, T> extends Rule<Source, Iterable<T>> {
  final RuleCombiner<T> combiner;

  final Rule<T, T> rule;

  _IterableRule(this.rule, this.combiner, {required Rule<Source, Iterable<T>> child}) : super(child);

  @override
  RuleResult<Iterable<T>> execute(Source source, Iterable<T> value) {
    if (combiner(value.map((e) => rule._executeChain(e)))) {
      return RuleResult.success(value);
    } else {
      return RuleResult.error(ValidationFailure('Iterable combiner returned false', name: name));
    }
  }
}
