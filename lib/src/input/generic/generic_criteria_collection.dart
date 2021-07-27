part of 'generic_input.dart';

typedef BuildGenericCriteriaFunc<T> = void Function(GenericCriteriaBuilder<T> builder);
typedef BuildGenericCastCriteriaFunc<T, S> = void Function(GenericCastCriteriaBuilder<T, S> builder);
typedef BuildGenericBinaryCriteriaFunc<T> = void Function(GenericBinaryCriteriaBuilder<T> builder);

abstract class GenericCriteriaCollection<T> {
  late final GenericCriteria<T> _criteria;

  GenericCriteriaCollection() {
    _criteria = createCriteria()._build();
  }

  GenericBuilder<T> createCriteria();

  T? transform(T? value) => value;

  bool isPure(T? value) => false;

  bool validate(T value) => _criteria._validateCriteria(value).success;

  @protected
  GenericBuilder<S> add<S>(BuildGenericCriteriaFunc<S> func) {
    final builder = GenericCriteriaBuilder<S>._();
    func(builder);

    return builder;
  }

  @protected
  GenericBuilder<S> addCast<S, K>(BuildGenericCastCriteriaFunc<S, K> func) {
    final builder = GenericCastCriteriaBuilder<S, K>._();
    func(builder);

    return builder;
  }

  @protected
  GenericBuilder<S> addBinary<S>(BuildGenericBinaryCriteriaFunc<S> func) {
    final builder = GenericBinaryCriteriaBuilder<S>._();
    func(builder);

    return builder;
  }
}
