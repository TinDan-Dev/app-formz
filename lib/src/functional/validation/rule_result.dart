part of 'validator.dart';

@freezed
class RuleResult<T> with _$RuleResult<T> {
  const factory RuleResult.ignore() = RuleResultIgnore;

  const factory RuleResult.success(T value) = RuleResultSuccess;

  const factory RuleResult.error(Failure failure) = RuleResultError;
}
