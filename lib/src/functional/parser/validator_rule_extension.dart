part of 'validator.dart';

typedef SourceRule<T> = Rule<T, T, T>;

extension NullRuleExtension<Source, T> on Rule<Source, dynamic, T?> {
  Rule<Source, T?, T> notNull() => _NotNullRule<Source, T>(child: this);

  Rule<Source, T?, R?> nullOr<R>(Rule<T, dynamic, R> createRule(SourceRule<T> rule)) =>
      _NullOrRule<Source, T, R>(createRule(_SourceRule<T>(name)), child: this);
}

extension RuleExtension<Source, T> on Rule<Source, dynamic, T> {
  Rule<Source, T, R> map<R>(R map(T value)) => _MapRule<Source, T, R>(map, child: this);

  Rule<Source, T, R> parser<R>(Parser<T, R> parser) => _ParserRule<Source, T, R>(parser, child: this);

  Rule<Source, T, R> apply<R>(Rule<T, dynamic, R> createRule(SourceRule<T> rule)) =>
      _ApplyRule<Source, T, R>(createRule(_SourceRule<T>(name)), child: this);

  Rule<Source, T, T> match(Object? matcher) => _MatchRule<Source, T>(wrapMatcher(matcher), child: this);

  Rule<Source, T, T> check(bool predicate(T value)) => _CheckRule<Source, T>(predicate, child: this);

  Rule<Source, T, T> validator(Validator<T> validator) => _ValidatorRule<Source, T>(validator, child: this);

  Rule<Source, void, void> fallback(T fallback(Source s)) => _FallbackRule<Source, T>(fallback, child: this);

  Rule<Source, void, void> defaultValue(T value) => _DefaultRule<Source, T>(value, child: this);
}

extension TRIterableRuleExtension<Source, T> on Rule<Source, dynamic, Iterable<T>> {
  Rule<Source, Iterable<T>, Iterable<R>> every<R>(Rule<T, dynamic, R> createRule(SourceRule<T> rule)) =>
      _EveryIterableRule<Source, T, R>(createRule(_SourceRule<T>(name)), child: this);

  Rule<Source, Iterable<T>, Iterable<T>> any(Rule<T, dynamic, dynamic> createRule(SourceRule<T> rule)) =>
      _AnyIterableRule<Source, T>(createRule(_SourceRule<T>(name)), child: this);

  Rule<Source, Iterable<T>, Iterable<T>> none(Rule<T, dynamic, dynamic> createRule(SourceRule<T> rule)) =>
      _NoneIterableRule<Source, T>(createRule(_SourceRule<T>(name)), child: this);
}
