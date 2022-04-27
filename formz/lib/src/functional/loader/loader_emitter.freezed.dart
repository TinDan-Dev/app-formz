// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'loader_emitter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$EmitterUpdateTearOff {
  const _$EmitterUpdateTearOff();

  EmitterUpdateResult<T> result<T>(T value) {
    return EmitterUpdateResult<T>(
      value,
    );
  }

  EmitterUpdateError<T> error<T>(Failure<dynamic> failure) {
    return EmitterUpdateError<T>(
      failure,
    );
  }

  EmitterUpdateConfig<T> config<T>(Map<String, Object?> configs) {
    return EmitterUpdateConfig<T>(
      configs,
    );
  }
}

/// @nodoc
const $EmitterUpdate = _$EmitterUpdateTearOff();

/// @nodoc
mixin _$EmitterUpdate<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) result,
    required TResult Function(Failure<dynamic> failure) error,
    required TResult Function(Map<String, Object?> configs) config,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EmitterUpdateResult<T> value) result,
    required TResult Function(EmitterUpdateError<T> value) error,
    required TResult Function(EmitterUpdateConfig<T> value) config,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(EmitterUpdateResult<T> value)? result,
    TResult Function(EmitterUpdateError<T> value)? error,
    TResult Function(EmitterUpdateConfig<T> value)? config,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EmitterUpdateResult<T> value)? result,
    TResult Function(EmitterUpdateError<T> value)? error,
    TResult Function(EmitterUpdateConfig<T> value)? config,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmitterUpdateCopyWith<T, $Res> {
  factory $EmitterUpdateCopyWith(EmitterUpdate<T> value, $Res Function(EmitterUpdate<T>) then) =
      _$EmitterUpdateCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$EmitterUpdateCopyWithImpl<T, $Res> implements $EmitterUpdateCopyWith<T, $Res> {
  _$EmitterUpdateCopyWithImpl(this._value, this._then);

  final EmitterUpdate<T> _value;
  // ignore: unused_field
  final $Res Function(EmitterUpdate<T>) _then;
}

/// @nodoc
abstract class $EmitterUpdateResultCopyWith<T, $Res> {
  factory $EmitterUpdateResultCopyWith(EmitterUpdateResult<T> value, $Res Function(EmitterUpdateResult<T>) then) =
      _$EmitterUpdateResultCopyWithImpl<T, $Res>;
  $Res call({T value});
}

/// @nodoc
class _$EmitterUpdateResultCopyWithImpl<T, $Res> extends _$EmitterUpdateCopyWithImpl<T, $Res>
    implements $EmitterUpdateResultCopyWith<T, $Res> {
  _$EmitterUpdateResultCopyWithImpl(EmitterUpdateResult<T> _value, $Res Function(EmitterUpdateResult<T>) _then)
      : super(_value, (v) => _then(v as EmitterUpdateResult<T>));

  @override
  EmitterUpdateResult<T> get _value => super._value as EmitterUpdateResult<T>;

  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(EmitterUpdateResult<T>(
      value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$EmitterUpdateResult<T> implements EmitterUpdateResult<T> {
  const _$EmitterUpdateResult(this.value);

  @override
  final T value;

  @override
  String toString() {
    return 'EmitterUpdate<$T>.result(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is EmitterUpdateResult<T> &&
            (identical(other.value, value) || const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode => runtimeType.hashCode ^ const DeepCollectionEquality().hash(value);

  @JsonKey(ignore: true)
  @override
  $EmitterUpdateResultCopyWith<T, EmitterUpdateResult<T>> get copyWith =>
      _$EmitterUpdateResultCopyWithImpl<T, EmitterUpdateResult<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) result,
    required TResult Function(Failure<dynamic> failure) error,
    required TResult Function(Map<String, Object?> configs) config,
  }) {
    return result(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
  }) {
    return result?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
    required TResult orElse(),
  }) {
    if (result != null) {
      return result(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EmitterUpdateResult<T> value) result,
    required TResult Function(EmitterUpdateError<T> value) error,
    required TResult Function(EmitterUpdateConfig<T> value) config,
  }) {
    return result(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(EmitterUpdateResult<T> value)? result,
    TResult Function(EmitterUpdateError<T> value)? error,
    TResult Function(EmitterUpdateConfig<T> value)? config,
  }) {
    return result?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EmitterUpdateResult<T> value)? result,
    TResult Function(EmitterUpdateError<T> value)? error,
    TResult Function(EmitterUpdateConfig<T> value)? config,
    required TResult orElse(),
  }) {
    if (result != null) {
      return result(this);
    }
    return orElse();
  }
}

abstract class EmitterUpdateResult<T> implements EmitterUpdate<T> {
  const factory EmitterUpdateResult(T value) = _$EmitterUpdateResult<T>;

  T get value => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmitterUpdateResultCopyWith<T, EmitterUpdateResult<T>> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmitterUpdateErrorCopyWith<T, $Res> {
  factory $EmitterUpdateErrorCopyWith(EmitterUpdateError<T> value, $Res Function(EmitterUpdateError<T>) then) =
      _$EmitterUpdateErrorCopyWithImpl<T, $Res>;
  $Res call({Failure<dynamic> failure});
}

/// @nodoc
class _$EmitterUpdateErrorCopyWithImpl<T, $Res> extends _$EmitterUpdateCopyWithImpl<T, $Res>
    implements $EmitterUpdateErrorCopyWith<T, $Res> {
  _$EmitterUpdateErrorCopyWithImpl(EmitterUpdateError<T> _value, $Res Function(EmitterUpdateError<T>) _then)
      : super(_value, (v) => _then(v as EmitterUpdateError<T>));

  @override
  EmitterUpdateError<T> get _value => super._value as EmitterUpdateError<T>;

  @override
  $Res call({
    Object? failure = freezed,
  }) {
    return _then(EmitterUpdateError<T>(
      failure == freezed
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure<dynamic>,
    ));
  }
}

/// @nodoc

class _$EmitterUpdateError<T> implements EmitterUpdateError<T> {
  const _$EmitterUpdateError(this.failure);

  @override
  final Failure<dynamic> failure;

  @override
  String toString() {
    return 'EmitterUpdate<$T>.error(failure: $failure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is EmitterUpdateError<T> &&
            (identical(other.failure, failure) || const DeepCollectionEquality().equals(other.failure, failure)));
  }

  @override
  int get hashCode => runtimeType.hashCode ^ const DeepCollectionEquality().hash(failure);

  @JsonKey(ignore: true)
  @override
  $EmitterUpdateErrorCopyWith<T, EmitterUpdateError<T>> get copyWith =>
      _$EmitterUpdateErrorCopyWithImpl<T, EmitterUpdateError<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) result,
    required TResult Function(Failure<dynamic> failure) error,
    required TResult Function(Map<String, Object?> configs) config,
  }) {
    return error(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
  }) {
    return error?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EmitterUpdateResult<T> value) result,
    required TResult Function(EmitterUpdateError<T> value) error,
    required TResult Function(EmitterUpdateConfig<T> value) config,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(EmitterUpdateResult<T> value)? result,
    TResult Function(EmitterUpdateError<T> value)? error,
    TResult Function(EmitterUpdateConfig<T> value)? config,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EmitterUpdateResult<T> value)? result,
    TResult Function(EmitterUpdateError<T> value)? error,
    TResult Function(EmitterUpdateConfig<T> value)? config,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class EmitterUpdateError<T> implements EmitterUpdate<T> {
  const factory EmitterUpdateError(Failure<dynamic> failure) = _$EmitterUpdateError<T>;

  Failure<dynamic> get failure => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmitterUpdateErrorCopyWith<T, EmitterUpdateError<T>> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmitterUpdateConfigCopyWith<T, $Res> {
  factory $EmitterUpdateConfigCopyWith(EmitterUpdateConfig<T> value, $Res Function(EmitterUpdateConfig<T>) then) =
      _$EmitterUpdateConfigCopyWithImpl<T, $Res>;
  $Res call({Map<String, Object?> configs});
}

/// @nodoc
class _$EmitterUpdateConfigCopyWithImpl<T, $Res> extends _$EmitterUpdateCopyWithImpl<T, $Res>
    implements $EmitterUpdateConfigCopyWith<T, $Res> {
  _$EmitterUpdateConfigCopyWithImpl(EmitterUpdateConfig<T> _value, $Res Function(EmitterUpdateConfig<T>) _then)
      : super(_value, (v) => _then(v as EmitterUpdateConfig<T>));

  @override
  EmitterUpdateConfig<T> get _value => super._value as EmitterUpdateConfig<T>;

  @override
  $Res call({
    Object? configs = freezed,
  }) {
    return _then(EmitterUpdateConfig<T>(
      configs == freezed
          ? _value.configs
          : configs // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>,
    ));
  }
}

/// @nodoc

class _$EmitterUpdateConfig<T> implements EmitterUpdateConfig<T> {
  const _$EmitterUpdateConfig(this.configs);

  @override
  final Map<String, Object?> configs;

  @override
  String toString() {
    return 'EmitterUpdate<$T>.config(configs: $configs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is EmitterUpdateConfig<T> &&
            (identical(other.configs, configs) || const DeepCollectionEquality().equals(other.configs, configs)));
  }

  @override
  int get hashCode => runtimeType.hashCode ^ const DeepCollectionEquality().hash(configs);

  @JsonKey(ignore: true)
  @override
  $EmitterUpdateConfigCopyWith<T, EmitterUpdateConfig<T>> get copyWith =>
      _$EmitterUpdateConfigCopyWithImpl<T, EmitterUpdateConfig<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T value) result,
    required TResult Function(Failure<dynamic> failure) error,
    required TResult Function(Map<String, Object?> configs) config,
  }) {
    return config(configs);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
  }) {
    return config?.call(configs);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
    required TResult orElse(),
  }) {
    if (config != null) {
      return config(configs);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EmitterUpdateResult<T> value) result,
    required TResult Function(EmitterUpdateError<T> value) error,
    required TResult Function(EmitterUpdateConfig<T> value) config,
  }) {
    return config(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(EmitterUpdateResult<T> value)? result,
    TResult Function(EmitterUpdateError<T> value)? error,
    TResult Function(EmitterUpdateConfig<T> value)? config,
  }) {
    return config?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EmitterUpdateResult<T> value)? result,
    TResult Function(EmitterUpdateError<T> value)? error,
    TResult Function(EmitterUpdateConfig<T> value)? config,
    required TResult orElse(),
  }) {
    if (config != null) {
      return config(this);
    }
    return orElse();
  }
}

abstract class EmitterUpdateConfig<T> implements EmitterUpdate<T> {
  const factory EmitterUpdateConfig(Map<String, Object?> configs) = _$EmitterUpdateConfig<T>;

  Map<String, Object?> get configs => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmitterUpdateConfigCopyWith<T, EmitterUpdateConfig<T>> get copyWith => throw _privateConstructorUsedError;
}
