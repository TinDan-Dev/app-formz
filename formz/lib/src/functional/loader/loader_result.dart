import 'package:collection/collection.dart';

import '../structures/hash_map.dart';
import '../structures/tree_map.dart';

class LoaderResult {
  final TreeMap<String, Object?> _configs;
  final HashMap<Type, Object?> _results;

  LoaderResult._(this._results, this._configs);

  LoaderResult()
      : _results = HashMap(),
        _configs = TreeMap();

  bool containsResults(Iterable<Type> types) {
    return types.every((type) => _results.contains(type));
  }

  T call<T>() => getResult<T>();

  T getResult<T>() {
    assert(_results.contains(T), 'No result of type $T found');
    assert(_results[T] is T, 'Result of type ${_results[T].runtimeType} found, but expected type $T');

    return _results[T] as T;
  }

  T? getResultOpt<T>() {
    final result = _results[T];

    if (result != null) {
      assert(result is T, 'Result of type ${_results[T].runtimeType} found, but expected type $T');
      return result as T;
    } else {
      return null;
    }
  }

  LoaderResult addResults(Map<Type, Object?> results) {
    assert(
      results.keys.none((key) => _results.contains(key)),
      'Do not override old results, already contains: ${results.keys.firstWhere((key) => _results.contains(key))}',
    );

    return LoaderResult._(_results.insertAll(results), _configs);
  }

  T getConfig<T>(String name, {T fallback()?}) {
    if (_configs.contains(name)) {
      assert(_configs[name] is T, 'Config of type ${_configs[name].runtimeType} found, but expected type $T');

      return _configs[name] as T;
    } else {
      assert(fallback != null, 'No result config $name found and no fallback provided');
      return fallback!.call();
    }
  }

  LoaderResult addConfigs(Map<String, Object?> configs) {
    return LoaderResult._(_results, _configs.insertAll(configs));
  }
}
