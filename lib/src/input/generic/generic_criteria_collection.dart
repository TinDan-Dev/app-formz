part of 'generic_input.dart';

abstract class GenericCriteriaCollection<T> {
  late final GenericCriteria<T> _criteria;

  GenericCriteriaCollection() {
    _criteria = createCriteria()._build();
  }

  GenericBuilder<T> createCriteria();

  bool isPure(T? value) => false;

  bool validate(T value) => _criteria._validateCriteria(value).success;

  T? transform(T? input) => input;

  @protected
  GenericBuilder<S> add<S>(void func(GenericCriteriaBuilder<S> builder)) {
    final builder = GenericCriteriaBuilder<S>._();
    func(builder);

    return builder;
  }

  @protected
  GenericBuilder<S> addCast<S, K>(void func(GenericCastCriteriaBuilder<S, K> builder)) {
    final builder = GenericCastCriteriaBuilder<S, K>._();
    func(builder);

    return builder;
  }

  @protected
  GenericBuilder<S> addBinary<S>(void func(GenericBinaryCriteriaBuilder<S> builder)) {
    final builder = GenericBinaryCriteriaBuilder<S>._();
    func(builder);

    return builder;
  }
}
