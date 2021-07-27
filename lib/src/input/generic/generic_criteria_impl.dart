part of 'generic_input.dart';

typedef SelectFunc<T, S> = S? Function(T value);

ValidationFunc<T> notNull<T>() => (value) => value != null;

ValidationFunc<T> equals<T>(T test) => (value) => value == test;

CastFunc<T, S> select<T, S>(SelectFunc<T, S> select) => (value) {
      if (value == null) return null;
      return select(value);
    };

ValidationFunc<String> notEmptyOrNull() => (value) => value != null && value.isNotEmpty;

ValidationFunc<String> regexMatches({required RegExp regex}) => (value) {
      if (value == null)
        return false;
      else
        return regex.hasMatch(value);
    };

ValidationFunc<String> getStringLength(ValidationFunc<int> func) => (value) {
      if (value == null) return false;
      return func(value.length);
    };

ValidationFunc<bool> isTrue() => (value) => value == true;

ValidationFunc<bool> isFalse() => (value) => value == false;

CastFunc<String, int> isInt() => (value) {
      if (value == null) return null;

      try {
        return int.parse(value);
      } catch (_) {
        return null;
      }
    };

ValidationFunc<T> isBetween<T extends num>({required T min, required T max}) => (value) {
      if (value == null) return false;
      return value >= min && value <= max;
    };

ValidationFunc<T> isGreater<T extends num>({required T min}) => (value) {
      if (value == null) return false;
      return value > min;
    };

ValidationFunc<T> isSmaller<T extends num>({required T max}) => (value) {
      if (value == null) return false;
      return value < max;
    };

ValidationFunc<T> getLength<T extends Iterable>(ValidationFunc<int> func) => (value) {
      if (value == null) return false;
      return func(value.length);
    };

BinaryCombinerFunc or() => ({
      required Object? key,
      required LocalFunc? combiner,
      required CriteriaResult first,
      required CriteriaResult second,
    }) {
      final result = first.success || second.success;
      if (result) return const CriteriaResult.success();

      LocalFunc? local;
      List<Object> keys = [];

      key.let(keys.add);
      keys.addAll(first.keys);
      keys.addAll(second.keys);

      if (!first.success) {
        local = combiner ?? first.localize;
        if (!second.success) local ??= second.localize;
      } else {
        local = combiner ?? second.localize;
        if (!second.success) local ??= first.localize;
      }

      return CriteriaResult.failure(keys: keys, localize: local);
    };

BinaryCombinerFunc and() => ({
      required Object? key,
      required LocalFunc? combiner,
      required CriteriaResult first,
      required CriteriaResult second,
    }) {
      List<Object> keys = [];

      key.let(keys.add);
      keys.addAll(first.keys);
      keys.addAll(second.keys);

      if (!first.success) {
        var local = combiner ?? first.localize;
        if (!second.success) local ??= second.localize;

        return CriteriaResult.failure(keys: keys, localize: local);
      }
      if (!second.success) {
        var local = combiner ?? second.localize;
        if (!second.success) local ??= first.localize;

        return CriteriaResult.failure(keys: keys, localize: local);
      }

      return const CriteriaResult.success();
    };
