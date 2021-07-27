import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../utils/extensions.dart';
import '../input.dart';

part 'generic_criteria.dart';
part 'generic_criteria_collection.dart';
part 'generic_criteria_impl.dart';
part 'generic_error.dart';

abstract class GenericInput<T> extends Input<T, GenericInputError> {
  @override
  T? get value => getCollection().transform(super.value);

  GenericInput.pure(
    T? value, {
    required String name,
  }) : super.pure(value, name);

  GenericInput.dirty(
    T? value, {
    required String name,
  }) : super.dirty(value, name);

  @protected
  GenericCriteriaCollection<T> getCollection();

  @override
  GenericInputError? validate(T? input) {
    final collection = getCollection();
    final result = collection._criteria._validateCriteria(input);

    if (result.success)
      return null;
    else
      return GenericInputError(keys: result.keys, localize: result.localize);
  }
}
