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

  EmitterUpdateResult result(Type key, dynamic value) {
    return EmitterUpdateResult(
      key,
      value,
    );
  }

  EmitterUpdateError error(Failure<dynamic> failure) {
    return EmitterUpdateError(
      failure,
    );
  }

  EmitterUpdateConfig config(Map<String, Object?> configs) {
    return EmitterUpdateConfig(
      configs,
    );
  }
}

/// @nodoc
const $EmitterUpdate = _$EmitterUpdateTearOff();

/// @nodoc
mixin _$EmitterUpdate {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Type key, dynamic value) result,
    required TResult Function(Failure<dynamic> failure) error,
    required TResult Function(Map<String, Object?> configs) config,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Type key, dynamic value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Type key, dynamic value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EmitterUpdateResult value) result,
    required TResult Function(EmitterUpdateError value) error,
    required TResult Function(EmitterUpdateConfig value) config,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(EmitterUpdateResult value)? result,
    TResult Function(EmitterUpdateError value)? error,
    TResult Function(EmitterUpdateConfig value)? config,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EmitterUpdateResult value)? result,
    TResult Function(EmitterUpdateError value)? error,
    TResult Function(EmitterUpdateConfig value)? config,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmitterUpdateCopyWith<$Res> {
  factory $EmitterUpdateCopyWith(
          EmitterUpdate value, $Res Function(EmitterUpdate) then) =
      _$EmitterUpdateCopyWithImpl<$Res>;
}

/// @nodoc
class _$EmitterUpdateCopyWithImpl<$Res>
    implements $EmitterUpdateCopyWith<$Res> {
  _$EmitterUpdateCopyWithImpl(this._value, this._then);

  final EmitterUpdate _value;
  // ignore: unused_field
  final $Res Function(EmitterUpdate) _then;
}

/// @nodoc
abstract class $EmitterUpdateResultCopyWith<$Res> {
  factory $EmitterUpdateResultCopyWith(
          EmitterUpdateResult value, $Res Function(EmitterUpdateResult) then) =
      _$EmitterUpdateResultCopyWithImpl<$Res>;
  $Res call({Type key, dynamic value});
}

/// @nodoc
class _$EmitterUpdateResultCopyWithImpl<$Res>
    extends _$EmitterUpdateCopyWithImpl<$Res>
    implements $EmitterUpdateResultCopyWith<$Res> {
  _$EmitterUpdateResultCopyWithImpl(
      EmitterUpdateResult _value, $Res Function(EmitterUpdateResult) _then)
      : super(_value, (v) => _then(v as EmitterUpdateResult));

  @override
  EmitterUpdateResult get _value => super._value as EmitterUpdateResult;

  @override
  $Res call({
    Object? key = freezed,
    Object? value = freezed,
  }) {
    return _then(EmitterUpdateResult(
      key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as Type,
      value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class _$EmitterUpdateResult implements EmitterUpdateResult {
  const _$EmitterUpdateResult(this.key, this.value);

  @override
  final Type key;
  @override
  final dynamic value;

  @override
  String toString() {
    return 'EmitterUpdate.result(key: $key, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is EmitterUpdateResult &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(value);

  @JsonKey(ignore: true)
  @override
  $EmitterUpdateResultCopyWith<EmitterUpdateResult> get copyWith =>
      _$EmitterUpdateResultCopyWithImpl<EmitterUpdateResult>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Type key, dynamic value) result,
    required TResult Function(Failure<dynamic> failure) error,
    required TResult Function(Map<String, Object?> configs) config,
  }) {
    return result(key, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Type key, dynamic value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
  }) {
    return result?.call(key, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Type key, dynamic value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
    required TResult orElse(),
  }) {
    if (result != null) {
      return result(key, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(EmitterUpdateResult value) result,
    required TResult Function(EmitterUpdateError value) error,
    required TResult Function(EmitterUpdateConfig value) config,
  }) {
    return result(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(EmitterUpdateResult value)? result,
    TResult Function(EmitterUpdateError value)? error,
    TResult Function(EmitterUpdateConfig value)? config,
  }) {
    return result?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EmitterUpdateResult value)? result,
    TResult Function(EmitterUpdateError value)? error,
    TResult Function(EmitterUpdateConfig value)? config,
    required TResult orElse(),
  }) {
    if (result != null) {
      return result(this);
    }
    return orElse();
  }
}

abstract class EmitterUpdateResult implements EmitterUpdate {
  const factory EmitterUpdateResult(Type key, dynamic value) =
      _$EmitterUpdateResult;

  Type get key => throw _privateConstructorUsedError;
  dynamic get value => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmitterUpdateResultCopyWith<EmitterUpdateResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmitterUpdateErrorCopyWith<$Res> {
  factory $EmitterUpdateErrorCopyWith(
          EmitterUpdateError value, $Res Function(EmitterUpdateError) then) =
      _$EmitterUpdateErrorCopyWithImpl<$Res>;
  $Res call({Failure<dynamic> failure});
}

/// @nodoc
class _$EmitterUpdateErrorCopyWithImpl<$Res>
    extends _$EmitterUpdateCopyWithImpl<$Res>
    implements $EmitterUpdateErrorCopyWith<$Res> {
  _$EmitterUpdateErrorCopyWithImpl(
      EmitterUpdateError _value, $Res Function(EmitterUpdateError) _then)
      : super(_value, (v) => _then(v as EmitterUpdateError));

  @override
  EmitterUpdateError get _value => super._value as EmitterUpdateError;

  @override
  $Res call({
    Object? failure = freezed,
  }) {
    return _then(EmitterUpdateError(
      failure == freezed
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure<dynamic>,
    ));
  }
}

/// @nodoc

class _$EmitterUpdateError implements EmitterUpdateError {
  const _$EmitterUpdateError(this.failure);

  @override
  final Failure<dynamic> failure;

  @override
  String toString() {
    return 'EmitterUpdate.error(failure: $failure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is EmitterUpdateError &&
            (identical(other.failure, failure) ||
                const DeepCollectionEquality().equals(other.failure, failure)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(failure);

  @JsonKey(ignore: true)
  @override
  $EmitterUpdateErrorCopyWith<EmitterUpdateError> get copyWith =>
      _$EmitterUpdateErrorCopyWithImpl<EmitterUpdateError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Type key, dynamic value) result,
    required TResult Function(Failure<dynamic> failure) error,
    required TResult Function(Map<String, Object?> configs) config,
  }) {
    return error(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Type key, dynamic value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
  }) {
    return error?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Type key, dynamic value)? result,
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
    required TResult Function(EmitterUpdateResult value) result,
    required TResult Function(EmitterUpdateError value) error,
    required TResult Function(EmitterUpdateConfig value) config,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(EmitterUpdateResult value)? result,
    TResult Function(EmitterUpdateError value)? error,
    TResult Function(EmitterUpdateConfig value)? config,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EmitterUpdateResult value)? result,
    TResult Function(EmitterUpdateError value)? error,
    TResult Function(EmitterUpdateConfig value)? config,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class EmitterUpdateError implements EmitterUpdate {
  const factory EmitterUpdateError(Failure<dynamic> failure) =
      _$EmitterUpdateError;

  Failure<dynamic> get failure => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmitterUpdateErrorCopyWith<EmitterUpdateError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EmitterUpdateConfigCopyWith<$Res> {
  factory $EmitterUpdateConfigCopyWith(
          EmitterUpdateConfig value, $Res Function(EmitterUpdateConfig) then) =
      _$EmitterUpdateConfigCopyWithImpl<$Res>;
  $Res call({Map<String, Object?> configs});
}

/// @nodoc
class _$EmitterUpdateConfigCopyWithImpl<$Res>
    extends _$EmitterUpdateCopyWithImpl<$Res>
    implements $EmitterUpdateConfigCopyWith<$Res> {
  _$EmitterUpdateConfigCopyWithImpl(
      EmitterUpdateConfig _value, $Res Function(EmitterUpdateConfig) _then)
      : super(_value, (v) => _then(v as EmitterUpdateConfig));

  @override
  EmitterUpdateConfig get _value => super._value as EmitterUpdateConfig;

  @override
  $Res call({
    Object? configs = freezed,
  }) {
    return _then(EmitterUpdateConfig(
      configs == freezed
          ? _value.configs
          : configs // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>,
    ));
  }
}

/// @nodoc

class _$EmitterUpdateConfig implements EmitterUpdateConfig {
  const _$EmitterUpdateConfig(this.configs);

  @override
  final Map<String, Object?> configs;

  @override
  String toString() {
    return 'EmitterUpdate.config(configs: $configs)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is EmitterUpdateConfig &&
            (identical(other.configs, configs) ||
                const DeepCollectionEquality().equals(other.configs, configs)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(configs);

  @JsonKey(ignore: true)
  @override
  $EmitterUpdateConfigCopyWith<EmitterUpdateConfig> get copyWith =>
      _$EmitterUpdateConfigCopyWithImpl<EmitterUpdateConfig>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Type key, dynamic value) result,
    required TResult Function(Failure<dynamic> failure) error,
    required TResult Function(Map<String, Object?> configs) config,
  }) {
    return config(configs);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(Type key, dynamic value)? result,
    TResult Function(Failure<dynamic> failure)? error,
    TResult Function(Map<String, Object?> configs)? config,
  }) {
    return config?.call(configs);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Type key, dynamic value)? result,
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
    required TResult Function(EmitterUpdateResult value) result,
    required TResult Function(EmitterUpdateError value) error,
    required TResult Function(EmitterUpdateConfig value) config,
  }) {
    return config(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(EmitterUpdateResult value)? result,
    TResult Function(EmitterUpdateError value)? error,
    TResult Function(EmitterUpdateConfig value)? config,
  }) {
    return config?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(EmitterUpdateResult value)? result,
    TResult Function(EmitterUpdateError value)? error,
    TResult Function(EmitterUpdateConfig value)? config,
    required TResult orElse(),
  }) {
    if (config != null) {
      return config(this);
    }
    return orElse();
  }
}

abstract class EmitterUpdateConfig implements EmitterUpdate {
  const factory EmitterUpdateConfig(Map<String, Object?> configs) =
      _$EmitterUpdateConfig;

  Map<String, Object?> get configs => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EmitterUpdateConfigCopyWith<EmitterUpdateConfig> get copyWith =>
      throw _privateConstructorUsedError;
}
