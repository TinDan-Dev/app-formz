import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:matcher/matcher.dart';

import '../../utils/extensions.dart';
import '../result/result.dart';

part 'failures.dart';
part 'rule.dart';
part 'rule_extension.dart';
part 'rule_result.dart';
part 'validator.freezed.dart';

abstract class Validator<S> {
  const Validator();

  List<Rule<S, dynamic>> get rules;

  Rule<S, S> rule({String? name}) => _StartRule<S>(name);

  Rule<S, T> ruleFor<T>(FieldAccess<S, T> getter, {String? name}) => _FieldStartRule<S, T>(getter, name);

  Result<void> validate(S source) {
    for (final rule in rules) {
      final result = rule._executeChain(source);

      if (result is RuleResultError) {
        return Result.left(result.failure);
      }
    }

    return Result.right(null);
  }
}
