// TODO: add tests

import 'dart:collection';

import 'package:equatable/equatable.dart';

import 'input.dart';

enum SelectInputError { empty }

class SelectInputSource<T> extends Equatable with IterableMixin<T> implements Iterable<T> {
  final List<T> _values;

  SelectInputSource({
    required Iterable<T> values,
  }) : _values = List.unmodifiable(values);

  @override
  List<Object?> get props => [_values];

  @override
  Iterator<T> get iterator => _values.iterator;
}

class SelectInput<T> extends Input<T, SelectInputError> {
  final SelectInputSource<T> source;

  SelectInput.dirty(
    T? value, {
    required String name,
    required this.source,
  }) : super.dirty(value, name);

  SelectInput.pure(
    T? value, {
    required String name,
    required this.source,
  }) : super.pure(value, name);

  @override
  SelectInputError? validate(T? input) => source._values.contains(input) ? null : SelectInputError.empty;

  List<Object?> get props => super.props + [source];

  @override
  Input<T, SelectInputError> copyWith({
    required T? value,
    bool pure = false,
  }) {
    if (pure)
      return SelectInput.pure(value, name: name, source: source);
    else
      return SelectInput.dirty(value, name: name, source: source);
  }

  Input<T, SelectInputError> copyWithInputSource({
    required SelectInputSource<T> source,
    bool pure = false,
  }) {
    if (pure)
      return SelectInput.pure(value, name: name, source: source);
    else
      return SelectInput.dirty(value, name: name, source: source);
  }
}
