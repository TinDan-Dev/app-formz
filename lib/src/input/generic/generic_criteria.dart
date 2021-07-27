part of 'generic_input.dart';

typedef ValidationFunc<T> = bool Function(T? value);
typedef LocalFunc = String Function(BuildContext context);
typedef CastFunc<T, S> = S? Function(T? value);

typedef BinaryCombinerFunc = CriteriaResult Function({
  required Object? key,
  required LocalFunc? combiner,
  required CriteriaResult first,
  required CriteriaResult second,
});

class CriteriaResult extends Equatable {
  final bool success;
  final List<Object> keys;
  final LocalFunc? localize;

  const CriteriaResult({
    required this.success,
    required this.keys,
    this.localize,
  });

  const CriteriaResult.success() : this(success: true, keys: const []);

  const CriteriaResult.failure({required List<Object> keys, LocalFunc? localize})
      : this(keys: keys, success: false, localize: localize);

  CriteriaResult._failureFrom({required GenericCriteria criteria})
      : this(keys: criteria.key.fold(() => [], (some) => [some]), success: false, localize: criteria.localize);

  @override
  List<Object?> get props => [success, ...keys, localize];
}

class GenericCriteria<T> extends Equatable {
  final List<GenericCriteria<T>> ifValid;
  final ValidationFunc<T> validate;
  final Object? key;

  final LocalFunc? localize;

  const GenericCriteria({
    required this.ifValid,
    required this.validate,
    this.key,
    this.localize,
  });

  CriteriaResult _validateCriteria(T? value) {
    if (!validate(value)) return CriteriaResult._failureFrom(criteria: this);

    return ifValid
        .map((e) => e._validateCriteria(value))
        .firstWhere((e) => !e.success, orElse: () => const CriteriaResult.success());
  }

  @override
  List<Object?> get props => [ifValid, validate, key, localize];
}

class GenericCastCriteria<T, S> extends GenericCriteria<T> {
  final List<GenericCriteria<S>> afterCast;
  final CastFunc<T, S> cast;

  GenericCastCriteria({
    required List<GenericCriteria<T>> ifValid,
    required this.afterCast,
    required this.cast,
    Object? key,
    LocalFunc? localize,
  }) : super(
          ifValid: ifValid,
          validate: (_) => false,
          key: key,
          localize: localize,
        );

  @override
  ValidationFunc<T> get validate => (value) => cast(value) != null;

  @override
  CriteriaResult _validateCriteria(T? value) {
    final result = super._validateCriteria(value);

    if (result.success) {
      final castedValue = cast(value);
      assert(castedValue != null);

      return afterCast
          .map((e) => e._validateCriteria(castedValue))
          .firstWhere((e) => !e.success, orElse: () => const CriteriaResult.success());
    }

    return result;
  }

  @override
  List<Object?> get props => super.props + [afterCast, cast];
}

class GenericBinaryCriteria<T> extends GenericCriteria<T> {
  final GenericCriteria<T> first;
  final GenericCriteria<T> second;
  final BinaryCombinerFunc combiner;

  GenericBinaryCriteria({
    required List<GenericCriteria<T>> ifValid,
    required this.first,
    required this.second,
    required this.combiner,
    LocalFunc? localize,
    Object? key,
  }) : super(
          ifValid: ifValid,
          validate: (_) => false,
          key: key,
          localize: localize,
        );

  @override
  ValidationFunc<T> get validate => (value) => _validateCriteria(value).success;

  @override
  CriteriaResult _validateCriteria(T? value) {
    final firstResult = first._validateCriteria(value);
    final secondResult = second._validateCriteria(value);

    return combiner(key: key, combiner: localize, first: firstResult, second: secondResult);
  }

  @override
  List<Object?> get props => super.props + [first, second, combiner];
}

abstract class GenericBuilder<T> {
  GenericCriteria<T> _build();
}

class GenericCriteriaBuilder<T> extends GenericBuilder<T> {
  final List<GenericCriteria<T>> _ifValid = [];

  ValidationFunc<T>? _validate;
  LocalFunc? _localize;
  Object? _key;

  GenericCriteriaBuilder._();

  void localize(LocalFunc func) => _localize = func;

  void validate(ValidationFunc<T> func) => _validate = func;

  void ifValid(GenericBuilder<T> builder) => _ifValid.add(builder._build());

  void key(Object key) => _key = key;

  @override
  GenericCriteria<T> _build() {
    if (_validate == null) throw StateError('A validation function is required');

    return GenericCriteria(
      ifValid: _ifValid,
      validate: _validate!,
      key: _key,
      localize: _localize,
    );
  }
}

class GenericCastCriteriaBuilder<T, S> extends GenericBuilder<T> {
  final List<GenericCriteria<T>> _ifValid = [];
  final List<GenericCriteria<S>> _afterCast = [];

  CastFunc<T, S>? _cast;
  LocalFunc? _localize;
  Object? _key;

  GenericCastCriteriaBuilder._();

  void localize(LocalFunc func) => _localize = func;

  void cast(CastFunc<T, S> func) => _cast = func;

  void ifValid(GenericBuilder<T> builder) => _ifValid.add(builder._build());

  void afterCast(GenericBuilder<S> builder) => _afterCast.add(builder._build());

  void key(Object key) => _key = key;

  @override
  GenericCriteria<T> _build() {
    if (_cast == null) throw StateError('A cast function is required');

    return GenericCastCriteria(
      ifValid: _ifValid,
      afterCast: _afterCast,
      cast: _cast!,
      key: _key,
      localize: _localize,
    );
  }
}

class GenericBinaryCriteriaBuilder<T> extends GenericBuilder<T> {
  final List<GenericCriteria<T>> _ifValid = [];

  GenericCriteria<T>? _first;
  GenericCriteria<T>? _second;

  BinaryCombinerFunc? _combine;
  LocalFunc? _localize;
  Object? _key;

  GenericBinaryCriteriaBuilder._();

  void localize(LocalFunc func) => _localize = func;

  void validate(BinaryCombinerFunc func) => _combine = func;

  void ifValid(GenericBuilder<T> builder) => _ifValid.add(builder._build());

  void key(Object key) => _key = key;

  void first(GenericBuilder<T> builder) => _first = builder._build();

  void second(GenericBuilder<T> builder) => _second = builder._build();

  @override
  GenericCriteria<T> _build() {
    if (_combine == null) throw StateError('A validation function is required');

    return GenericBinaryCriteria<T>(
      first: _first!,
      second: _second!,
      combiner: _combine!,
      ifValid: _ifValid,
      key: _key,
      localize: _localize,
    );
  }
}
