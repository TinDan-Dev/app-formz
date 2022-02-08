part of 'validator.dart';

mixin NestedRules<Source, T> on Rule<Source, T, Map<String, dynamic>> {
  @override
  Map<String, dynamic> validate(void value) => const {};
}

abstract class Rule<Source, T, R> {
  final Rule<Source, dynamic, T>? child;

  const Rule(this.child);

  String? get name => child?.name;

  R execute(Source source) {
    final value = child!.execute(source);
    return validate(value);
  }

  R validate(T value);
}

class _SourceRule<Source> extends Rule<Source, Source, Source> {
  @override
  final String? name;

  const _SourceRule(this.name) : super(null);

  @override
  Source execute(Source source) => source;

  @override
  Source validate(Source value) => value;
}

class _AccessRule<Source, T> extends Rule<Source, T, T> {
  final T Function(Source source) accessDelegate;

  @override
  final String? name;

  const _AccessRule(this.name, this.accessDelegate) : super(null);

  @override
  T execute(Source source) => accessDelegate(source);

  @override
  T validate(T value) => value;
}

class _SetRule<Source, T> extends Rule<Source, void, T> {
  final T value;

  @override
  final String name;

  const _SetRule(this.name, this.value) : super(null);

  @override
  T execute(Source source) => value;

  @override
  T validate(void value) => this.value;
}

class _NotNullRule<Source, T> extends Rule<Source, T?, T> {
  const _NotNullRule({Rule<Source, dynamic, T?>? child}) : super(child);

  @override
  T validate(T? value) {
    if (value == null) {
      throw ViolationFailure('Value is null', field: name);
    }

    return value;
  }
}

class _NullOrRule<Source, T, R> extends Rule<Source, T?, R?> {
  final Rule<T, dynamic, R> rule;

  const _NullOrRule(this.rule, {Rule<Source, dynamic, T?>? child}) : super(child);

  @override
  R? validate(T? value) {
    if (value == null) {
      return null;
    } else {
      return rule.execute(value);
    }
  }
}

class _MapRule<Source, T, R> extends Rule<Source, T, R> {
  final R Function(T value) mapDelegate;

  const _MapRule(this.mapDelegate, {Rule<Source, dynamic, T>? child}) : super(child);

  @override
  R validate(T value) => mapDelegate(value);
}

class _MatchRule<Source, T> extends Rule<Source, T, T> {
  final Matcher matcher;

  const _MatchRule(this.matcher, {Rule<Source, dynamic, T>? child}) : super(child);

  @override
  T validate(T value) {
    final matchState = {};
    if (!matcher.matches(value, matchState)) {
      final description = StringDescription();
      matcher.describeMismatch(value, description, matchState, false);

      throw ViolationFailure(description.toString(), field: name, cause: value);
    }

    return value;
  }
}

class _CheckRule<Source, T> extends Rule<Source, T, T> {
  final bool Function(T value) predicate;

  const _CheckRule(this.predicate, {Rule<Source, dynamic, T>? child}) : super(child);

  @override
  T validate(T value) {
    if (!predicate(value)) {
      throw ViolationFailure('Check failed', field: name, cause: value);
    }

    return value;
  }
}

class _ValidatorRule<Source, T> extends Rule<Source, T, T> {
  final Validator<T> validator;

  const _ValidatorRule(this.validator, {Rule<Source, dynamic, T>? child}) : super(child);

  @override
  T validate(T value) {
    return validator.validate(value).consume(
          onRight: (_) => value,
          onLeft: (failure) => throw failure,
        );
  }
}

class _ParserRule<Source, T, R> extends Rule<Source, T, R> {
  final Parser<T, R> parser;

  const _ParserRule(this.parser, {Rule<Source, dynamic, T>? child}) : super(child);

  @override
  R validate(T value) {
    return parser.parse(value).consume(
          onRight: (result) => result,
          onLeft: (failure) => throw failure,
        );
  }
}

class IfRule<Source> extends Rule<Source, Map<String, dynamic>, Map<String, dynamic>>
    with NestedRules<Source, Map<String, dynamic>> {
  final bool Function(Source s) predicate;

  final List<Rule<Source, dynamic, dynamic>> ifTrue;
  final List<Rule<Source, dynamic, dynamic>>? ifFalse;

  const IfRule(this.predicate, this.ifTrue, this.ifFalse, {IfRule<Source>? child}) : super(child);

  @override
  Map<String, dynamic> execute(Source source) {
    if (child != null) {
      try {
        return child!.execute(source);
      } on ViolationFailure {
        return _executeThis(source);
      }
    } else {
      return _executeThis(source);
    }
  }

  Map<String, dynamic> _executeThis(Source source) {
    if (predicate(source)) {
      return _executeRules(source, ifTrue).consume(
        onRight: (result) => result,
        onLeft: (failure) => throw failure,
      );
    } else {
      if (ifFalse != null) {
        return _executeRules(source, ifFalse!).consume(
          onRight: (result) => result,
          onLeft: (failure) => throw failure,
        );
      } else {
        return const {};
      }
    }
  }

  Rule<Source, void, void> orElse(List<Rule<Source, dynamic, dynamic>> ifFalse) =>
      IfRule<Source>(predicate, ifTrue, ifFalse);

  IfRule<Source> orWhen(bool predicate(Source s), List<Rule<Source, dynamic, dynamic>> ifTrue) =>
      IfRule<Source>(predicate, ifTrue, null, child: this);
}

class IfAllRule<Source> extends Rule<Source, Map<String, dynamic>, Map<String, dynamic>>
    with NestedRules<Source, Map<String, dynamic>> {
  final List<Rule<Source, dynamic, dynamic>> rules;

  final List<Rule<Source, dynamic, dynamic>> ifTrue;
  final List<Rule<Source, dynamic, dynamic>>? ifFalse;

  const IfAllRule(this.rules, this.ifTrue, this.ifFalse, {IfAllRule<Source>? child}) : super(child);

  @override
  Map<String, dynamic> execute(Source source) {
    if (child != null) {
      try {
        return child!.execute(source);
      } on ViolationFailure {
        return _executeThis(source);
      }
    } else {
      return _executeThis(source);
    }
  }

  Map<String, dynamic> _executeThis(Source source) {
    return _executeRules(source, rules).consume(onRight: (_) {
      return _executeRules(source, ifTrue).consume(
        onRight: (result) => result,
        onLeft: (failure) => throw failure,
      );
    }, onLeft: (_) {
      if (ifFalse != null) {
        return _executeRules(source, ifFalse!).consume(
          onRight: (result) => result,
          onLeft: (failure) => throw failure,
        );
      } else {
        return const {};
      }
    });
  }

  Rule<Source, void, void> orElse(List<Rule<Source, dynamic, dynamic>> ifFalse) =>
      IfAllRule<Source>(rules, ifTrue, ifFalse);

  IfAllRule<Source> orWhen(List<Rule<Source, dynamic, dynamic>> rules, List<Rule<Source, dynamic, dynamic>> ifTrue) =>
      IfAllRule<Source>(rules, ifTrue, null, child: this);
}

class _AnyIterableRule<Source, T> extends Rule<Source, Iterable<T>, Iterable<T>> {
  final Rule<T, dynamic, dynamic> rule;

  const _AnyIterableRule(this.rule, {Rule<Source, dynamic, Iterable<T>>? child}) : super(child);

  @override
  Iterable<T> validate(Iterable<T> value) {
    final result = value.any((e) {
      try {
        rule.execute(e);
        return true;
      } on ViolationFailure {
        return false;
      }
    });

    if (!result) {
      throw ViolationFailure('Some element from the iterable matched the rule', field: name, cause: value);
    }

    return value;
  }
}

class _NoneIterableRule<Source, T> extends Rule<Source, Iterable<T>, Iterable<T>> {
  final Rule<T, dynamic, dynamic> rule;

  const _NoneIterableRule(this.rule, {Rule<Source, dynamic, Iterable<T>>? child}) : super(child);

  @override
  Iterable<T> validate(Iterable<T> value) {
    final result = value.none((e) {
      try {
        rule.execute(e);
        return true;
      } on ViolationFailure {
        return false;
      }
    });

    if (!result) {
      throw ViolationFailure('Some element from the iterable matched the rule', field: name, cause: value);
    }

    return value;
  }
}

class _EveryIterableRule<Source, T, R> extends Rule<Source, Iterable<T>, Iterable<R>> {
  final Rule<T, dynamic, R> rule;

  const _EveryIterableRule(this.rule, {Rule<Source, dynamic, Iterable<T>>? child}) : super(child);

  @override
  Iterable<R> validate(Iterable<T> value) => value.map(rule.execute).toList();
}

class _FallbackRule<Source, T> extends Rule<Source, T, T> {
  final T Function(Source s) fallback;

  const _FallbackRule(this.fallback, {Rule<Source, dynamic, T>? child}) : super(child);

  @override
  T execute(Source source) {
    try {
      return super.execute(source);
    } on ViolationFailure {
      return fallback(source);
    }
  }

  @override
  T validate(T value) => value;
}

class _DefaultRule<Source, T> extends Rule<Source, T, T> {
  final T value;

  const _DefaultRule(this.value, {Rule<Source, dynamic, T>? child}) : super(child);

  @override
  T execute(Source source) {
    try {
      return super.execute(source);
    } on ViolationFailure {
      return value;
    }
  }

  @override
  T validate(T value) => value;
}

class _ApplyRule<Source, T, R> extends Rule<Source, T, R> {
  final Rule<T, dynamic, R> rule;

  const _ApplyRule(this.rule, {Rule<Source, dynamic, T>? child}) : super(child);

  @override
  R validate(T value) => rule.execute(value);
}
