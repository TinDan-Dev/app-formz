part of 'generic_input.dart';

typedef SelectFunc<T, S> = S? Function(T value);

CastFunc<T, S> select<T, S>(SelectFunc<T, S> select) => (value) {
      if (value == null) return null;
      return select(value);
    };

CastFunc<String, int> isInt() => (value) {
      if (value == null) return null;

      try {
        return int.parse(value);
      } catch (_) {
        return null;
      }
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
