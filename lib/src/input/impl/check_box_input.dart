import 'package:collection/collection.dart';

import '../../functional/result/result.dart';
import '../input.dart';

enum CheckBoxValidationPattern { always, atLeastOne, exactlyOne }

class CheckBoxInputFailure extends Failure {
  CheckBoxInputFailure(
    CheckBoxValidationPattern pattern, {
    required Object? cause,
  }) : super(
          message: 'Input violated pattern: $pattern',
          cause: cause,
          trace: StackTrace.current,
        );
}

class CheckBoxState {
  final Iterable _values;

  const CheckBoxState(this._values);

  bool isSet(Object key) => _values.contains(key);

  bool get atLeastOne => _values.isNotEmpty;

  bool get exactlyOne => _values.length == 1;

  CheckBoxState update({
    List set = const [],
    List clear = const [],
    List toggle = const [],
  }) {
    final result = List.from(_values);

    result.addAll(set.whereNot(result.contains));
    result.removeWhere(clear.contains);

    for (final element in toggle) {
      if (result.contains(element)) {
        result.remove(element);
      } else {
        result.add(element);
      }
    }

    return CheckBoxState(result);
  }
}

Input<CheckBoxState> createCheckBoxInput(
  CheckBoxValidationPattern pattern, {
  required InputIdentifier<CheckBoxState> id,
  CheckBoxState value = const CheckBoxState([]),
  bool pure = false,
}) =>
    Input<CheckBoxState>(
      (input) {
        switch (pattern) {
          case CheckBoxValidationPattern.always:
            return const Result.right(null);
          case CheckBoxValidationPattern.atLeastOne:
            if (input.atLeastOne) {
              return const Result.right(null);
            } else {
              return CheckBoxInputFailure(pattern, cause: input);
            }
          case CheckBoxValidationPattern.exactlyOne:
            if (input.exactlyOne) {
              return const Result.right(null);
            } else {
              return CheckBoxInputFailure(pattern, cause: input);
            }
        }
      },
      id: id,
      pure: pure,
      value: value,
    );
