part of 'consumable_merge.dart';

class _MergeConsumableAsync<A, B> with ConsumableAsyncMixin<Tuple<A, B>> {
  final ConsumableAsync<A> first;
  final FutureOr<ConsumableAsync<B>> Function() second;

  const _MergeConsumableAsync({
    required this.first,
    required this.second,
  });

  @override
  Future<G> consume<G>({
    required FutureOr<G> onSuccess(Tuple<A, B> value),
    required FutureOr<G> onError(Failure failure),
  }) {
    return first.consume(
      onSuccess: (firstValue) async => (await second()).consume(
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

class _MergeConsumableAsync3<A, B, C> with ConsumableAsyncMixin<Tuple3<A, B, C>> {
  final ConsumableAsync<A> first;
  final FutureOr<ConsumableAsync<B>> Function() second;
  final FutureOr<ConsumableAsync<C>> Function() third;

  const _MergeConsumableAsync3({
    required this.first,
    required this.second,
    required this.third,
  });

  @override
  Future<G> consume<G>({
    required FutureOr<G> onSuccess(Tuple3<A, B, C> value),
    required FutureOr<G> onError(Failure failure),
  }) {
    return first.consume(
      onSuccess: (firstValue) async => (await second()).consume(
        onSuccess: (secondValue) async => (await third()).consume(
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

extension MergeAsyncConsumableExtension<T> on ConsumableAsync<T> {
  ConsumableAsync<Tuple<T, B>> merge<B>(FutureOr<ConsumableAsync<B>> second()) {
    return _MergeConsumableAsync<T, B>(first: this, second: second);
  }

  ConsumableAsync<Tuple<T, B>> mergeSync<B>(FutureOr<Consumable<B>> second()) {
    return _MergeConsumableAsync<T, B>(
      first: this,
      second: () async {
        return (await second()).toConsumableAsync();
      },
    );
  }

  ConsumableAsync<Tuple3<T, B, C>> merge3<B, C>({
    required FutureOr<ConsumableAsync<B>> second(),
    required FutureOr<ConsumableAsync<C>> third(),
  }) {
    return _MergeConsumableAsync3<T, B, C>(first: this, second: second, third: third);
  }

  ConsumableAsync<Tuple3<T, B, C>> mergeSync3<B, C>({
    required FutureOr<Consumable<B>> second(),
    required FutureOr<Consumable<C>> third(),
  }) {
    return _MergeConsumableAsync3<T, B, C>(
      first: this,
      second: () async {
        return (await second()).toConsumableAsync();
      },
      third: () async {
        return (await third()).toConsumableAsync();
      },
    );
  }
}

extension FutureMergeAsyncConsumableExtension<T> on Future<ConsumableAsync<T>> {
  Future<ConsumableAsync<Tuple<T, B>>> merge<B>(FutureOr<ConsumableAsync<B>> second()) async {
    return _MergeConsumableAsync<T, B>(first: await this, second: second);
  }

  Future<ConsumableAsync<Tuple<T, B>>> mergeSync<B>(FutureOr<Consumable<B>> second()) async {
    return _MergeConsumableAsync<T, B>(
      first: await this,
      second: () async {
        return (await second()).toConsumableAsync();
      },
    );
  }

  Future<ConsumableAsync<Tuple3<T, B, C>>> merge3<B, C>({
    required FutureOr<ConsumableAsync<B>> second(),
    required FutureOr<ConsumableAsync<C>> third(),
  }) async {
    return _MergeConsumableAsync3<T, B, C>(first: await this, second: second, third: third);
  }

  Future<ConsumableAsync<Tuple3<T, B, C>>> mergeSync3<B, C>({
    required FutureOr<Consumable<B>> second(),
    required FutureOr<Consumable<C>> third(),
  }) async {
    return _MergeConsumableAsync3<T, B, C>(
      first: await this,
      second: () async {
        return (await second()).toConsumableAsync();
      },
      third: () async {
        return (await third()).toConsumableAsync();
      },
    );
  }
}
