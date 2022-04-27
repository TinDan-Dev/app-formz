// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'result_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$ResultStateTearOff {
  const _$ResultStateTearOff();

  ResultStateLoading<T> loading<T>([T? value]) {
    return ResultStateLoading<T>(
      value,
    );
  }

  ResultStateSuccess<T> success<T>(T value) {
    return ResultStateSuccess<T>(
      value,
    );
  }

  ResultStateError<T> error<T>(Failure<dynamic> failure) {
    return ResultStateError<T>(
      failure,
    );
  }
}

/// @nodoc
const $ResultState = _$ResultStateTearOff();

/// @nodoc
mixin _$ResultState<T> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? value) loading,
    required TResult Function(T value) success,
    required TResult Function(Failure<dynamic> failure) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T? value)? loading,
    TResult Function(T value)? success,
    TResult Function(Failure<dynamic> failure)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? value)? loading,
    TResult Function(T value)? success,
    TResult Function(Failure<dynamic> failure)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ResultStateLoading<T> value) loading,
    required TResult Function(ResultStateSuccess<T> value) success,
    required TResult Function(ResultStateError<T> value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ResultStateLoading<T> value)? loading,
    TResult Function(ResultStateSuccess<T> value)? success,
    TResult Function(ResultStateError<T> value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResultStateLoading<T> value)? loading,
    TResult Function(ResultStateSuccess<T> value)? success,
    TResult Function(ResultStateError<T> value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultStateCopyWith<T, $Res> {
  factory $ResultStateCopyWith(ResultState<T> value, $Res Function(ResultState<T>) then) =
      _$ResultStateCopyWithImpl<T, $Res>;
}

/// @nodoc
class _$ResultStateCopyWithImpl<T, $Res> implements $ResultStateCopyWith<T, $Res> {
  _$ResultStateCopyWithImpl(this._value, this._then);

  final ResultState<T> _value;
  // ignore: unused_field
  final $Res Function(ResultState<T>) _then;
}

/// @nodoc
abstract class $ResultStateLoadingCopyWith<T, $Res> {
  factory $ResultStateLoadingCopyWith(ResultStateLoading<T> value, $Res Function(ResultStateLoading<T>) then) =
      _$ResultStateLoadingCopyWithImpl<T, $Res>;
  $Res call({T? value});
}

/// @nodoc
class _$ResultStateLoadingCopyWithImpl<T, $Res> extends _$ResultStateCopyWithImpl<T, $Res>
    implements $ResultStateLoadingCopyWith<T, $Res> {
  _$ResultStateLoadingCopyWithImpl(ResultStateLoading<T> _value, $Res Function(ResultStateLoading<T>) _then)
      : super(_value, (v) => _then(v as ResultStateLoading<T>));

  @override
  ResultStateLoading<T> get _value => super._value as ResultStateLoading<T>;

  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(ResultStateLoading<T>(
      value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T?,
    ));
  }
}

/// @nodoc

class _$ResultStateLoading<T> extends ResultStateLoading<T> {
  const _$ResultStateLoading([this.value]) : super._();

  @override
  final T? value;

  @override
  String toString() {
    return 'ResultState<$T>.loading(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ResultStateLoading<T> &&
            (identical(other.value, value) || const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode => runtimeType.hashCode ^ const DeepCollectionEquality().hash(value);

  @JsonKey(ignore: true)
  @override
  $ResultStateLoadingCopyWith<T, ResultStateLoading<T>> get copyWith =>
      _$ResultStateLoadingCopyWithImpl<T, ResultStateLoading<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? value) loading,
    required TResult Function(T value) success,
    required TResult Function(Failure<dynamic> failure) error,
  }) {
    return loading(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T? value)? loading,
    TResult Function(T value)? success,
    TResult Function(Failure<dynamic> failure)? error,
  }) {
    return loading?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? value)? loading,
    TResult Function(T value)? success,
    TResult Function(Failure<dynamic> failure)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ResultStateLoading<T> value) loading,
    required TResult Function(ResultStateSuccess<T> value) success,
    required TResult Function(ResultStateError<T> value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ResultStateLoading<T> value)? loading,
    TResult Function(ResultStateSuccess<T> value)? success,
    TResult Function(ResultStateError<T> value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResultStateLoading<T> value)? loading,
    TResult Function(ResultStateSuccess<T> value)? success,
    TResult Function(ResultStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ResultStateLoading<T> extends ResultState<T> {
  const factory ResultStateLoading([T? value]) = _$ResultStateLoading<T>;
  const ResultStateLoading._() : super._();

  T? get value => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResultStateLoadingCopyWith<T, ResultStateLoading<T>> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultStateSuccessCopyWith<T, $Res> {
  factory $ResultStateSuccessCopyWith(ResultStateSuccess<T> value, $Res Function(ResultStateSuccess<T>) then) =
      _$ResultStateSuccessCopyWithImpl<T, $Res>;
  $Res call({T value});
}

/// @nodoc
class _$ResultStateSuccessCopyWithImpl<T, $Res> extends _$ResultStateCopyWithImpl<T, $Res>
    implements $ResultStateSuccessCopyWith<T, $Res> {
  _$ResultStateSuccessCopyWithImpl(ResultStateSuccess<T> _value, $Res Function(ResultStateSuccess<T>) _then)
      : super(_value, (v) => _then(v as ResultStateSuccess<T>));

  @override
  ResultStateSuccess<T> get _value => super._value as ResultStateSuccess<T>;

  @override
  $Res call({
    Object? value = freezed,
  }) {
    return _then(ResultStateSuccess<T>(
      value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as T,
    ));
  }
}

/// @nodoc

class _$ResultStateSuccess<T> extends ResultStateSuccess<T> {
  const _$ResultStateSuccess(this.value) : super._();

  @override
  final T value;

  @override
  String toString() {
    return 'ResultState<$T>.success(value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ResultStateSuccess<T> &&
            (identical(other.value, value) || const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode => runtimeType.hashCode ^ const DeepCollectionEquality().hash(value);

  @JsonKey(ignore: true)
  @override
  $ResultStateSuccessCopyWith<T, ResultStateSuccess<T>> get copyWith =>
      _$ResultStateSuccessCopyWithImpl<T, ResultStateSuccess<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? value) loading,
    required TResult Function(T value) success,
    required TResult Function(Failure<dynamic> failure) error,
  }) {
    return success(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T? value)? loading,
    TResult Function(T value)? success,
    TResult Function(Failure<dynamic> failure)? error,
  }) {
    return success?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? value)? loading,
    TResult Function(T value)? success,
    TResult Function(Failure<dynamic> failure)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ResultStateLoading<T> value) loading,
    required TResult Function(ResultStateSuccess<T> value) success,
    required TResult Function(ResultStateError<T> value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ResultStateLoading<T> value)? loading,
    TResult Function(ResultStateSuccess<T> value)? success,
    TResult Function(ResultStateError<T> value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResultStateLoading<T> value)? loading,
    TResult Function(ResultStateSuccess<T> value)? success,
    TResult Function(ResultStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class ResultStateSuccess<T> extends ResultState<T> {
  const factory ResultStateSuccess(T value) = _$ResultStateSuccess<T>;
  const ResultStateSuccess._() : super._();

  T get value => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResultStateSuccessCopyWith<T, ResultStateSuccess<T>> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResultStateErrorCopyWith<T, $Res> {
  factory $ResultStateErrorCopyWith(ResultStateError<T> value, $Res Function(ResultStateError<T>) then) =
      _$ResultStateErrorCopyWithImpl<T, $Res>;
  $Res call({Failure<dynamic> failure});
}

/// @nodoc
class _$ResultStateErrorCopyWithImpl<T, $Res> extends _$ResultStateCopyWithImpl<T, $Res>
    implements $ResultStateErrorCopyWith<T, $Res> {
  _$ResultStateErrorCopyWithImpl(ResultStateError<T> _value, $Res Function(ResultStateError<T>) _then)
      : super(_value, (v) => _then(v as ResultStateError<T>));

  @override
  ResultStateError<T> get _value => super._value as ResultStateError<T>;

  @override
  $Res call({
    Object? failure = freezed,
  }) {
    return _then(ResultStateError<T>(
      failure == freezed
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure<dynamic>,
    ));
  }
}

/// @nodoc

class _$ResultStateError<T> extends ResultStateError<T> {
  const _$ResultStateError(this.failure) : super._();

  @override
  final Failure<dynamic> failure;

  @override
  String toString() {
    return 'ResultState<$T>.error(failure: $failure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ResultStateError<T> &&
            (identical(other.failure, failure) || const DeepCollectionEquality().equals(other.failure, failure)));
  }

  @override
  int get hashCode => runtimeType.hashCode ^ const DeepCollectionEquality().hash(failure);

  @JsonKey(ignore: true)
  @override
  $ResultStateErrorCopyWith<T, ResultStateError<T>> get copyWith =>
      _$ResultStateErrorCopyWithImpl<T, ResultStateError<T>>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? value) loading,
    required TResult Function(T value) success,
    required TResult Function(Failure<dynamic> failure) error,
  }) {
    return error(failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T? value)? loading,
    TResult Function(T value)? success,
    TResult Function(Failure<dynamic> failure)? error,
  }) {
    return error?.call(failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? value)? loading,
    TResult Function(T value)? success,
    TResult Function(Failure<dynamic> failure)? error,
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
    required TResult Function(ResultStateLoading<T> value) loading,
    required TResult Function(ResultStateSuccess<T> value) success,
    required TResult Function(ResultStateError<T> value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(ResultStateLoading<T> value)? loading,
    TResult Function(ResultStateSuccess<T> value)? success,
    TResult Function(ResultStateError<T> value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ResultStateLoading<T> value)? loading,
    TResult Function(ResultStateSuccess<T> value)? success,
    TResult Function(ResultStateError<T> value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class ResultStateError<T> extends ResultState<T> {
  const factory ResultStateError(Failure<dynamic> failure) = _$ResultStateError<T>;
  const ResultStateError._() : super._();

  Failure<dynamic> get failure => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResultStateErrorCopyWith<T, ResultStateError<T>> get copyWith => throw _privateConstructorUsedError;
}
