part of 'validator.dart';

extension RuleCreationExtension<Source, T> on Rule<Source, T> {
  Rule<Source, T> matches(Matcher matcher) => _MatcherRule(matcher, child: this);

  Rule<Source, T> notNull() => _MatcherRule(isNotNull, child: this);

  Rule<Source, T> iff(IffPredicate<Source, T> predicate) => _IffRule(predicate, child: this);

  Rule<Source, T> iffMatches(Matcher matcher) => _IffRule((_, field) => matcher.matches(field, {}), child: this);

  Rule<Source, T> validator(Validator<T> validator) => _ValidatorRule(validator, child: this);

  Rule<Source, T> check(RulePredicate<T> predicate) => _PredicateRule(predicate, child: this);
}

extension IterableRuleCreationExtension<Source, T> on Rule<Source, Iterable<T>> {
  Rule<Source, Iterable<T>> every(Rule<T, T> createRule(Rule<T, T> rule)) {
    final rule = createRule(_StartRule<T>(null));
    final combiner = (Iterable<RuleResult<T>> results) => results.every((e) => e is RuleResultSuccess);

    return _IterableRule(rule, combiner, child: this);
  }

  Rule<Source, Iterable<T>> any(Rule<T, T> createRule(Rule<T, T> rule)) {
    final rule = createRule(_StartRule<T>(null));
    final combiner = (Iterable<RuleResult<T>> results) => results.any((e) => e is RuleResultSuccess);

    return _IterableRule(rule, combiner, child: this);
  }

  Rule<Source, Iterable<T>> none(Rule<T, T> createRule(Rule<T, T> rule)) {
    final rule = createRule(_StartRule<T>(null));
    final combiner = (Iterable<RuleResult<T>> results) => results.none((e) => e is RuleResultSuccess);

    return _IterableRule(rule, combiner, child: this);
  }
}
