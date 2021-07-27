import 'input.dart';

enum DateInputError { empty }

class DateInput extends Input<DateTime, DateInputError> {
  DateInput.pure(
    DateTime? value, {
    required String name,
  }) : super.pure(value, name);

  DateInput.dirty(
    DateTime? value, {
    required String name,
  }) : super.dirty(value, name);

  @override
  DateInputError? validate(DateTime? input) {
    if (input == null) return DateInputError.empty;
    return null;
  }

  @override
  Input<DateTime, DateInputError> copyWith({
    required DateTime? value,
    bool pure = false,
  }) {
    if (pure)
      return DateInput.pure(value, name: name);
    else
      return DateInput.dirty(value, name: name);
  }
}
