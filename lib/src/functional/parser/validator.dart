import 'package:collection/collection.dart';
import 'package:matcher/matcher.dart';

import '../../utils/extensions.dart';
import '../either/either_map.dart';
import '../result/result.dart';
import 'exception.dart';
import 'parser.dart';

part 'validator_rule.dart';
part 'validator_rule_extension.dart';

Result<Map<String, dynamic>> _executeRules<S>(S source, List<Rule<S, dynamic, dynamic>> rules) {
  final results = <String, dynamic>{};

  for (final entry in rules) {
    try {
      if (entry is NestedRules<S, dynamic>) {
        results.addAll(entry.execute(source));
      } else {
        final result = entry.execute(source);
        entry.name.let((some) => results[some] = result);
      }
    } on ViolationFailure catch (e) {
      return Result.left(e);
    }
  }

  return Result.right(results);
}

abstract class Validator<Source> {
  const Validator();

  List<Rule<Source, dynamic, dynamic>> get rules;

  Rule<Source, Source, Source> expect() => _SourceRule<Source>(null);

  Rule<Source, T, T> expectFor<T>(T delegate(Source s)) => _AccessRule<Source, T>(null, delegate);

  Rule<Source, T, T> access<T>(String name, T delegate(Source s)) => _AccessRule<Source, T>(name, delegate);

  IfRule<Source> when(
    bool predicate(Source s),
    List<Rule<Source, dynamic, dynamic>> fiTrue,
  ) =>
      IfRule(predicate, fiTrue, null);

  IfAllRule<Source> whenAll(
    List<Rule<Source, dynamic, dynamic>> rules,
    List<Rule<Source, dynamic, dynamic>> fiTrue,
  ) =>
      IfAllRule(rules, fiTrue, null);

  Rule<Source, void, void> assign<T>(String name, T value) => _SetRule<Source, T>(name, value);

  Result<Map<String, dynamic>> validate(Source source) => _executeRules(source, rules);
}

abstract class VParser<Source, Target> extends Validator<Source> implements Parser<Source, Target> {
  const VParser();

  @override
  Result<Target> parse(Source source) => validate(source).mapRight(createInstance);

  @override
  Result<Target> call(Source source) => parse(source);

  Target createInstance(Map<String, dynamic> r);
}
