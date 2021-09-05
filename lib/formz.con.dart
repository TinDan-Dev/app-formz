// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ConsumableFuncGenerator
// **************************************************************************

// ignore_for_file: unnecessary_this

import 'dart:async';
import 'formz.dart';

extension ConsumableExtensions<T> on Consumable<T> {
  bool get success =>
      this.consume(onSuccess: (_) => true, onError: (_) => false);

  bool get failure =>
      this.consume(onSuccess: (_) => false, onError: (_) => true);

  void invoke() => this.consume(onSuccess: (_) {}, onError: (_) {});

  Consumable<void> discardValue() => this.consume(
        onSuccess: (_) => const ActionResult.success(),
        onError: (failure) => ActionResult.fail(failure),
      );

  Consumable<T> discardError(T value) => this.consume(
        onSuccess: (_) => this,
        onError: (_) => ValueActionResult<T>.success(value),
      );

  Consumable<T?> discardErrorNullable([T? value]) => this.consume(
        onSuccess: (_) => this,
        onError: (_) => ValueActionResult<T?>.success(value),
      );

  T valueOr(T value) => this.consume(
        onSuccess: (value) => value,
        onError: (_) => value,
      );

  T? valueOrNullable([T? value]) => this.consume(
        onSuccess: (value) => value,
        onError: (_) => value,
      );

  S? onSuccess<S>(S? callback(T value)) => this.consume(
        onSuccess: callback,
        onError: (_) => null,
      );

  S? onError<S>(S? callback(Failure failure)) => this.consume(
        onSuccess: (_) => null,
        onError: callback,
      );

  Consumable<S> map<S>(S mapper(T value)) => this.consume(
        onSuccess: (value) => ValueActionResult.success(mapper(value)),
        onError: (failure) => ValueActionResult.fail(failure),
      );

  Consumable<S> flatMap<S>(Consumable<S> mapper(T value)) => this.consume(
        onSuccess: (value) => mapper(value),
        onError: (failure) => ValueActionResult.fail(failure),
      );

  Consumable<S> cast<S>({Failure failure()?, S fallback()?}) {
    assert(failure != null || fallback != null,
        'either failure or fallback must be set');
    return this.consume(
      onSuccess: (value) {
        if (value is S) {
          return this as Consumable<S>;
        } else if (fallback != null) {
          return ValueActionResult.success(fallback());
        } else {
          return ValueActionResult.fail(failure!.call());
        }
      },
      onError: (failure) => ValueActionResult.fail(failure),
    );
  }

  Consumable<T> resolve({
    required bool condition(Failure value),
    required Consumable<T> match(Failure value),
  }) =>
      this.consume(
        onSuccess: (_) => this,
        onError: (failure) {
          if (condition(failure))
            return match(failure);
          else
            return this;
        },
      );

  Future<void> onSuccessAsync(FutureOr<void> callback(T value)) => this.consume(
        onSuccess: (value) async => callback(value),
        onError: (_) async {},
      );

  Future<ConsumableAsync<S>> mapAsync<S>(FutureOr<S> mapper(T value)) =>
      this.consume(
        onSuccess: (value) async =>
            ValueActionResultAsync.success(await mapper(value)),
        onError: (failure) async => ValueActionResultAsync.fail(failure),
      );

  Future<ConsumableAsync<S>> flatMapAsync<S>(
          FutureOr<ConsumableAsync<S>> mapper(T value)) =>
      this.consume(
        onSuccess: (value) async => mapper(value),
        onError: (failure) async => ValueActionResultAsync.fail(failure),
      );
}

extension ConsumableFutureExtensions<T> on FutureOr<Consumable<T>> {
  Future<bool> get success async =>
      (await this).consume(onSuccess: (_) => true, onError: (_) => false);

  Future<bool> get failure async =>
      (await this).consume(onSuccess: (_) => false, onError: (_) => true);

  Future<void> invoke() async =>
      (await this).consume(onSuccess: (_) {}, onError: (_) {});

  Future<Consumable<void>> discardValue() async => (await this).consume(
        onSuccess: (_) => const ActionResult.success(),
        onError: (failure) => ActionResult.fail(failure),
      );

  Future<Consumable<T>> discardError(T value) async => (await this).consume(
        onSuccess: (_) => this,
        onError: (_) => ValueActionResult<T>.success(value),
      );

  Future<Consumable<T?>> discardErrorNullable([T? value]) async =>
      (await this).consume(
        onSuccess: (_) => this,
        onError: (_) => ValueActionResult<T?>.success(value),
      );

  Future<T> valueOr(T value) async => (await this).consume(
        onSuccess: (value) => value,
        onError: (_) => value,
      );

  Future<T?> valueOrNullable([T? value]) async => (await this).consume(
        onSuccess: (value) => value,
        onError: (_) => value,
      );

  Future<S?> onSuccess<S>(S? callback(T value)) async => (await this).consume(
        onSuccess: callback,
        onError: (_) => null,
      );

  Future<S?> onError<S>(S? callback(Failure failure)) async =>
      (await this).consume(
        onSuccess: (_) => null,
        onError: callback,
      );

  Future<Consumable<S>> map<S>(S mapper(T value)) async => (await this).consume(
        onSuccess: (value) async =>
            ValueActionResult.success(await mapper(value)),
        onError: (failure) => ValueActionResult.fail(failure),
      );

  Future<Consumable<S>> flatMap<S>(Consumable<S> mapper(T value)) async =>
      (await this).consume(
        onSuccess: (value) => mapper(value),
        onError: (failure) => ValueActionResult.fail(failure),
      );

  Future<Consumable<S>> cast<S>({Failure failure()?, S fallback()?}) async {
    assert(failure != null || fallback != null,
        'either failure or fallback must be set');
    return (await this).consume(
      onSuccess: (value) async {
        if (value is S) {
          return this as Consumable<S>;
        } else if (fallback != null) {
          return ValueActionResult.success(await fallback());
        } else {
          return ValueActionResult.fail(failure!.call());
        }
      },
      onError: (failure) => ValueActionResult.fail(failure),
    );
  }

  Future<Consumable<T>> resolve({
    required bool condition(Failure value),
    required Consumable<T> match(Failure value),
  }) async =>
      (await this).consume(
        onSuccess: (_) => this,
        onError: (failure) async {
          if (await condition(failure))
            return await match(failure);
          else
            return this;
        },
      );
}

extension ConsumableAsyncExtensions<T> on ConsumableAsync<T> {
  Future<bool> get success async =>
      this.consume(onSuccess: (_) => true, onError: (_) => false);

  Future<bool> get failure async =>
      this.consume(onSuccess: (_) => false, onError: (_) => true);

  Future<void> invoke() async =>
      this.consume(onSuccess: (_) {}, onError: (_) {});

  Future<ConsumableAsync<void>> discardValue() async => this.consume(
        onSuccess: (_) => const ActionResultAsync.success(),
        onError: (failure) => ActionResultAsync.fail(failure),
      );

  Future<ConsumableAsync<T>> discardError(T value) async => this.consume(
        onSuccess: (_) => this,
        onError: (_) => ValueActionResultAsync<T>.success(value),
      );

  Future<ConsumableAsync<T?>> discardErrorNullable([T? value]) async =>
      this.consume(
        onSuccess: (_) => this,
        onError: (_) => ValueActionResultAsync<T?>.success(value),
      );

  Future<T> valueOr(T value) async => this.consume(
        onSuccess: (value) => value,
        onError: (_) => value,
      );

  Future<T?> valueOrNullable([T? value]) async => this.consume(
        onSuccess: (value) => value,
        onError: (_) => value,
      );

  Future<S?> onSuccess<S>(FutureOr<S?> callback(T value)) async => this.consume(
        onSuccess: callback,
        onError: (_) => null,
      );

  Future<S?> onError<S>(FutureOr<S?> callback(Failure failure)) async =>
      this.consume(
        onSuccess: (_) => null,
        onError: callback,
      );

  Future<ConsumableAsync<S>> map<S>(FutureOr<S> mapper(T value)) async =>
      this.consume(
        onSuccess: (value) async =>
            ValueActionResultAsync.success(await mapper(value)),
        onError: (failure) => ValueActionResultAsync.fail(failure),
      );

  Future<ConsumableAsync<S>> flatMap<S>(
          ConsumableAsync<S> mapper(T value)) async =>
      this.consume(
        onSuccess: (value) => mapper(value),
        onError: (failure) => ValueActionResultAsync.fail(failure),
      );

  Future<ConsumableAsync<S>> cast<S>(
      {Failure failure()?, FutureOr<S> fallback()?}) async {
    assert(failure != null || fallback != null,
        'either failure or fallback must be set');
    return this.consume(
      onSuccess: (value) async {
        if (value is S) {
          return this as ConsumableAsync<S>;
        } else if (fallback != null) {
          return ValueActionResultAsync.success(await fallback());
        } else {
          return ValueActionResultAsync.fail(failure!.call());
        }
      },
      onError: (failure) => ValueActionResultAsync.fail(failure),
    );
  }

  Future<ConsumableAsync<T>> resolve({
    required FutureOr<bool> condition(Failure value),
    required FutureOr<ConsumableAsync<T>> match(Failure value),
  }) async =>
      this.consume(
        onSuccess: (_) => this,
        onError: (failure) async {
          if (await condition(failure))
            return await match(failure);
          else
            return this;
        },
      );

  Future<Consumable<S>> flatMapSync<S>(
          FutureOr<Consumable<S>> mapper(T value)) async =>
      this.consume(
        onSuccess: (value) async => mapper(value),
        onError: (failure) async => ValueActionResult.fail(failure),
      );
}

extension ConsumableAsyncFutureExtensions<T> on FutureOr<ConsumableAsync<T>> {
  Future<bool> get success async =>
      (await this).consume(onSuccess: (_) => true, onError: (_) => false);

  Future<bool> get failure async =>
      (await this).consume(onSuccess: (_) => false, onError: (_) => true);

  Future<void> invoke() async =>
      (await this).consume(onSuccess: (_) {}, onError: (_) {});

  Future<ConsumableAsync<void>> discardValue() async => (await this).consume(
        onSuccess: (_) => const ActionResultAsync.success(),
        onError: (failure) => ActionResultAsync.fail(failure),
      );

  Future<ConsumableAsync<T>> discardError(T value) async =>
      (await this).consume(
        onSuccess: (_) => this,
        onError: (_) => ValueActionResultAsync<T>.success(value),
      );

  Future<ConsumableAsync<T?>> discardErrorNullable([T? value]) async =>
      (await this).consume(
        onSuccess: (_) => this,
        onError: (_) => ValueActionResultAsync<T?>.success(value),
      );

  Future<T> valueOr(T value) async => (await this).consume(
        onSuccess: (value) => value,
        onError: (_) => value,
      );

  Future<T?> valueOrNullable([T? value]) async => (await this).consume(
        onSuccess: (value) => value,
        onError: (_) => value,
      );

  Future<S?> onSuccess<S>(FutureOr<S?> callback(T value)) async =>
      (await this).consume(
        onSuccess: callback,
        onError: (_) => null,
      );

  Future<S?> onError<S>(FutureOr<S?> callback(Failure failure)) async =>
      (await this).consume(
        onSuccess: (_) => null,
        onError: callback,
      );

  Future<ConsumableAsync<S>> map<S>(FutureOr<S> mapper(T value)) async =>
      (await this).consume(
        onSuccess: (value) async =>
            ValueActionResultAsync.success(await mapper(value)),
        onError: (failure) => ValueActionResultAsync.fail(failure),
      );

  Future<ConsumableAsync<S>> flatMap<S>(
          ConsumableAsync<S> mapper(T value)) async =>
      (await this).consume(
        onSuccess: (value) => mapper(value),
        onError: (failure) => ValueActionResultAsync.fail(failure),
      );

  Future<ConsumableAsync<S>> cast<S>(
      {Failure failure()?, FutureOr<S> fallback()?}) async {
    assert(failure != null || fallback != null,
        'either failure or fallback must be set');
    return (await this).consume(
      onSuccess: (value) async {
        if (value is S) {
          return this as ConsumableAsync<S>;
        } else if (fallback != null) {
          return ValueActionResultAsync.success(await fallback());
        } else {
          return ValueActionResultAsync.fail(failure!.call());
        }
      },
      onError: (failure) => ValueActionResultAsync.fail(failure),
    );
  }

  Future<ConsumableAsync<T>> resolve({
    required FutureOr<bool> condition(Failure value),
    required FutureOr<ConsumableAsync<T>> match(Failure value),
  }) async =>
      (await this).consume(
        onSuccess: (_) => this,
        onError: (failure) async {
          if (await condition(failure))
            return await match(failure);
          else
            return this;
        },
      );

  Future<Consumable<S>> flatMapSync<S>(
          FutureOr<Consumable<S>> mapper(T value)) async =>
      (await this).consume(
        onSuccess: (value) async => mapper(value),
        onError: (failure) async => ValueActionResult.fail(failure),
      );
}
