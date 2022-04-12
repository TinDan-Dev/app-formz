import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../functional/either/either.dart';
import '../functional/result/result.dart';
import '../functional/structures/hash_map.dart';
import 'router_delegate.dart';

class ArgumentIdentifier<T> extends Equatable {
  final Object _identifier;

  const ArgumentIdentifier(this._identifier);

  const ArgumentIdentifier.named(String name) : this(name);

  @override
  List<Object?> get props => [_identifier];

  @override
  String toString() => 'Argument[$T]: $_identifier';

  bool _isAssignableFrom(Object? value) => value is T;
}

class Arguments {
  static final empty = Arguments._(HashMap());

  final HashMap<ArgumentIdentifier, Object?> _args;

  Arguments._(this._args)
      : assert(
          _args.entries.every((e) => e.key._isAssignableFrom(e.value)),
          'An argument has the wrong type',
        );

  Arguments(Map<ArgumentIdentifier, Object?> args) : this._(HashMap.from(args));

  Arguments add(ArgumentIdentifier key, {required Object? value}) => Arguments._(_args.insert(key, value));

  Arguments delete(ArgumentIdentifier key) => Arguments._(_args.delete(key));

  T get<T>(ArgumentIdentifier<T> key) {
    assert(_args.contains(key), 'Arguments do not contain key: $key');
    assert(
      _args.find(key).rightOrNull() is T,
      'Expected value of type $T, but fount: ${_args.find(key).rightOrNull()}',
    );

    return _args.find(key).castRight<T>().rightOrThrow();
  }

  Result<T> getOpt<T>(ArgumentIdentifier<T> key) {
    assert(
      _args.find(key).left || _args.find(key).rightOrNull() is T,
      'Expected value of type $T, but fount: ${_args.find(key).rightOrNull()}',
    );

    return _args.find(key).castRight<T>();
  }

  @override
  String toString() => _args.entries.map((e) => '${e.key._identifier}: ${e.value}').join(', ');
}

extension ArgumentsExtension on BuildContext {
  Arguments get args {
    final route = ModalRoute.of(this)?.settings;
    assert(route is FormzRouterPage, 'Only use the args property in routes pushed by the formz navigator');

    return route?.arguments as Arguments;
  }
}
