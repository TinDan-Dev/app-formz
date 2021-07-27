import 'dart:async';

import '../../formz.tuple.dart';
import 'consumable.dart';
import 'failure.dart';

part 'consumable_merge_async.dart';

class _MergeConsumable<A, B> with ConsumableMixin<Tuple<A, B>> {
  final Consumable<A> first;
  final Consumable<B> Function() second;

  const _MergeConsumable({
    required this.first,
    required this.second,
  });

  @override
  G consume<G>({
    required G onSuccess(Tuple<A, B> value),
    required G onError(Failure failure),
  }) {
    return first.consume(
      onSuccess: (firstValue) => second().consume(
        onSuccess: (secondValue) => onSuccess(Tuple(
          first: firstValue,
          second: secondValue,
        )),
        onError: onError,
      ),
      onError: onError,
    );
  }
}

class _MergeConsumable3<A, B, C> with ConsumableMixin<Tuple3<A, B, C>> {
  final Consumable<A> first;
  final Consumable<B> Function() second;
  final Consumable<C> Function() third;

  const _MergeConsumable3({
    required this.first,
    required this.second,
    required this.third,
  });

  @override
  G consume<G>({
    required G onSuccess(Tuple3<A, B, C> value),
    required G onError(Failure failure),
  }) {
    return first.consume(
      onSuccess: (firstValue) => second().consume(
        onSuccess: (secondValue) => third().consume(
          onSuccess: (thirdValue) => onSuccess(Tuple3(
            first: firstValue,
            second: secondValue,
            third: thirdValue,
          )),
          onError: onError,
        ),
        onError: onError,
      ),
      onError: onError,
    );
  }
}

extension MergeConsumableExtension<T> on Consumable<T> {
  Consumable<Tuple<T, B>> merge<B>(Consumable<B> second()) {
    return _MergeConsumable<T, B>(first: this, second: second);
  }

  ConsumableAsync<Tuple<T, B>> mergeAsync<B>(FutureOr<ConsumableAsync<B>> second()) {
    return _MergeConsumableAsync<T, B>(
      first: toConsumableAsync(),
      second: second,
    );
  }

  Consumable<Tuple3<T, B, C>> merge3<B, C>({
    required Consumable<B> second(),
    required Consumable<C> third(),
  }) {
    return _MergeConsumable3<T, B, C>(first: this, second: second, third: third);
  }

  ConsumableAsync<Tuple3<T, B, C>> mergeAsync3<B, C>({
    required FutureOr<ConsumableAsync<B>> second(),
    required FutureOr<ConsumableAsync<C>> third(),
  }) {
    return _MergeConsumableAsync3<T, B, C>(
      first: toConsumableAsync(),
      second: second,
      third: third,
    );
  }
}

extension FutureMergeConsumableExtension<T> on Future<Consumable<T>> {
  Future<Consumable<Tuple<T, B>>> merge<B>(Consumable<B> second()) async {
    return _MergeConsumable<T, B>(first: await this, second: second);
  }

  Future<ConsumableAsync<Tuple<T, B>>> mergeAsync<B>(FutureOr<ConsumableAsync<B>> second()) async {
    return _MergeConsumableAsync<T, B>(
      first: (await this).toConsumableAsync(),
      second: second,
    );
  }

  Future<Consumable<Tuple3<T, B, C>>> merge3<B, C>({
    required Consumable<B> second(),
    required Consumable<C> third(),
  }) async {
    return _MergeConsumable3<T, B, C>(first: await this, second: second, third: third);
  }

  Future<ConsumableAsync<Tuple3<T, B, C>>> mergeAsync3<B, C>({
    required FutureOr<ConsumableAsync<B>> second(),
    required FutureOr<ConsumableAsync<C>> third(),
  }) async {
    return _MergeConsumableAsync3<T, B, C>(
      first: (await this).toConsumableAsync(),
      second: second,
      third: third,
    );
  }
}
