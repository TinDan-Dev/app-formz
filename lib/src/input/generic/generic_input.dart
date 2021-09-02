import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../input_container.dart';
import '../../utils/extensions.dart';
import '../input.dart';

part 'generic_criteria.dart';
part 'generic_criteria_collection.dart';
part 'generic_criteria_impl.dart';
part 'generic_error.dart';

abstract class GenericInput<T> extends Input<T, GenericInputError> {
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
    final result = collection._criteria._validateCriteria(collection.transform(input));

    if (result.success)
      return null;
    else
      return GenericInputError(keys: result.keys, localize: result.localize);
  }
}

extension GenericInputExtension<T> on Input<T, dynamic> {
  T? get transformedValue {
    if (this is GenericInput) {
      final collection = (this as GenericInput<T>).getCollection();
      return collection.transform(value);
    } else {
      return value;
    }
  }
}

extension GenericInputContainerExtension on InputContainer {
  T getTransformedValue<T>(String name) {
    final input = getInput(name);
    assert(
      input.transformedValue is T,
      'Input has transformed value of type ${input.value.runtimeType} but $T was requested',
    );

    return input.transformedValue as T;
  }
}
