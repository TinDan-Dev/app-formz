// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MergeGenerator
// **************************************************************************

import 'dart:async';

import 'formz.tuple.dart';
import 'src/utils/consumable.dart';
import 'src/utils/failure.dart';

class _MergeConsumable<A, B> with ConsumableMixin<Tuple<A, B>> {
  _MergeConsumable({required this.first, required this.second});

  final Consumable<A> first;

  final Consumable<B> Function() second;

  @override
  T consume<T>({required T Function(Tuple<A, B> value) onSuccess, required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second().consume(
          onSuccess: (secondValue) => onSuccess(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsync<A, B> with ConsumableAsyncMixin<Tuple<A, B>> {
  _MergeConsumableAsync({required this.first, required this.second});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function() second;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple<A, B> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second()).consume(
          onSuccess: (secondValue) => onSuccess(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableJoining<A, B> with ConsumableMixin<Tuple<A, B>> {
  _MergeConsumableJoining({required this.first, required this.second});

  final Consumable<A> first;

  final Consumable<B> Function(A previous) second;

  @override
  T consume<T>({required T Function(Tuple<A, B> value) onSuccess, required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second(firstValue).consume(
          onSuccess: (secondValue) => onSuccess(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsyncJoining<A, B> with ConsumableAsyncMixin<Tuple<A, B>> {
  _MergeConsumableAsyncJoining({required this.first, required this.second});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function(A previous) second;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple<A, B> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second(firstValue)).consume(
          onSuccess: (secondValue) => onSuccess(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumable3<A, B, C> with ConsumableMixin<Tuple3<A, B, C>> {
  _MergeConsumable3({required this.first, required this.second, required this.third});

  final Consumable<A> first;

  final Consumable<B> Function() second;

  final Consumable<C> Function() third;

  @override
  T consume<T>({required T Function(Tuple3<A, B, C> value) onSuccess, required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second().consume(
          onSuccess: (secondValue) => third().consume(
            onSuccess: (thirdValue) => onSuccess(Tuple3<A, B, C>(
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

class _MergeConsumableAsync3<A, B, C> with ConsumableAsyncMixin<Tuple3<A, B, C>> {
  _MergeConsumableAsync3({required this.first, required this.second, required this.third});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function() second;

  final FutureOr<ConsumableAsync<C>> Function() third;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple3<A, B, C> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second()).consume(
          onSuccess: (secondValue) async => (await third()).consume(
            onSuccess: (thirdValue) => onSuccess(Tuple3<A, B, C>(
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

class _MergeConsumableJoining3<A, B, C> with ConsumableMixin<Tuple3<A, B, C>> {
  _MergeConsumableJoining3({required this.first, required this.second, required this.third});

  final Consumable<A> first;

  final Consumable<B> Function(A previous) second;

  final Consumable<C> Function(Tuple<A, B> previous) third;

  @override
  T consume<T>({required T Function(Tuple3<A, B, C> value) onSuccess, required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second(firstValue).consume(
          onSuccess: (secondValue) => third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )).consume(
            onSuccess: (thirdValue) => onSuccess(Tuple3<A, B, C>(
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

class _MergeConsumableAsyncJoining3<A, B, C> with ConsumableAsyncMixin<Tuple3<A, B, C>> {
  _MergeConsumableAsyncJoining3({required this.first, required this.second, required this.third});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function(A previous) second;

  final FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple3<A, B, C> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second(firstValue)).consume(
          onSuccess: (secondValue) async => (await third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )))
              .consume(
            onSuccess: (thirdValue) => onSuccess(Tuple3<A, B, C>(
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

class _MergeConsumable4<A, B, C, D> with ConsumableMixin<Tuple4<A, B, C, D>> {
  _MergeConsumable4({required this.first, required this.second, required this.third, required this.fourth});

  final Consumable<A> first;

  final Consumable<B> Function() second;

  final Consumable<C> Function() third;

  final Consumable<D> Function() fourth;

  @override
  T consume<T>(
          {required T Function(Tuple4<A, B, C, D> value) onSuccess, required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second().consume(
          onSuccess: (secondValue) => third().consume(
            onSuccess: (thirdValue) => fourth().consume(
              onSuccess: (fourthValue) => onSuccess(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsync4<A, B, C, D> with ConsumableAsyncMixin<Tuple4<A, B, C, D>> {
  _MergeConsumableAsync4({required this.first, required this.second, required this.third, required this.fourth});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function() second;

  final FutureOr<ConsumableAsync<C>> Function() third;

  final FutureOr<ConsumableAsync<D>> Function() fourth;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple4<A, B, C, D> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second()).consume(
          onSuccess: (secondValue) async => (await third()).consume(
            onSuccess: (thirdValue) async => (await fourth()).consume(
              onSuccess: (fourthValue) => onSuccess(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableJoining4<A, B, C, D> with ConsumableMixin<Tuple4<A, B, C, D>> {
  _MergeConsumableJoining4({required this.first, required this.second, required this.third, required this.fourth});

  final Consumable<A> first;

  final Consumable<B> Function(A previous) second;

  final Consumable<C> Function(Tuple<A, B> previous) third;

  final Consumable<D> Function(Tuple3<A, B, C> previous) fourth;

  @override
  T consume<T>(
          {required T Function(Tuple4<A, B, C, D> value) onSuccess, required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second(firstValue).consume(
          onSuccess: (secondValue) => third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )).consume(
            onSuccess: (thirdValue) => fourth(Tuple3<A, B, C>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
            )).consume(
              onSuccess: (fourthValue) => onSuccess(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsyncJoining4<A, B, C, D> with ConsumableAsyncMixin<Tuple4<A, B, C, D>> {
  _MergeConsumableAsyncJoining4({required this.first, required this.second, required this.third, required this.fourth});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function(A previous) second;

  final FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third;

  final FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple4<A, B, C, D> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second(firstValue)).consume(
          onSuccess: (secondValue) async => (await third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )))
              .consume(
            onSuccess: (thirdValue) async => (await fourth(Tuple3<A, B, C>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
            )))
                .consume(
              onSuccess: (fourthValue) => onSuccess(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumable5<A, B, C, D, E> with ConsumableMixin<Tuple5<A, B, C, D, E>> {
  _MergeConsumable5(
      {required this.first, required this.second, required this.third, required this.fourth, required this.fifth});

  final Consumable<A> first;

  final Consumable<B> Function() second;

  final Consumable<C> Function() third;

  final Consumable<D> Function() fourth;

  final Consumable<E> Function() fifth;

  @override
  T consume<T>(
          {required T Function(Tuple5<A, B, C, D, E> value) onSuccess, required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second().consume(
          onSuccess: (secondValue) => third().consume(
            onSuccess: (thirdValue) => fourth().consume(
              onSuccess: (fourthValue) => fifth().consume(
                onSuccess: (fifthValue) => onSuccess(Tuple5<A, B, C, D, E>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                )),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsync5<A, B, C, D, E> with ConsumableAsyncMixin<Tuple5<A, B, C, D, E>> {
  _MergeConsumableAsync5(
      {required this.first, required this.second, required this.third, required this.fourth, required this.fifth});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function() second;

  final FutureOr<ConsumableAsync<C>> Function() third;

  final FutureOr<ConsumableAsync<D>> Function() fourth;

  final FutureOr<ConsumableAsync<E>> Function() fifth;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple5<A, B, C, D, E> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second()).consume(
          onSuccess: (secondValue) async => (await third()).consume(
            onSuccess: (thirdValue) async => (await fourth()).consume(
              onSuccess: (fourthValue) async => (await fifth()).consume(
                onSuccess: (fifthValue) => onSuccess(Tuple5<A, B, C, D, E>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                )),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableJoining5<A, B, C, D, E> with ConsumableMixin<Tuple5<A, B, C, D, E>> {
  _MergeConsumableJoining5(
      {required this.first, required this.second, required this.third, required this.fourth, required this.fifth});

  final Consumable<A> first;

  final Consumable<B> Function(A previous) second;

  final Consumable<C> Function(Tuple<A, B> previous) third;

  final Consumable<D> Function(Tuple3<A, B, C> previous) fourth;

  final Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth;

  @override
  T consume<T>(
          {required T Function(Tuple5<A, B, C, D, E> value) onSuccess, required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second(firstValue).consume(
          onSuccess: (secondValue) => third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )).consume(
            onSuccess: (thirdValue) => fourth(Tuple3<A, B, C>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
            )).consume(
              onSuccess: (fourthValue) => fifth(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )).consume(
                onSuccess: (fifthValue) => onSuccess(Tuple5<A, B, C, D, E>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                )),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsyncJoining5<A, B, C, D, E> with ConsumableAsyncMixin<Tuple5<A, B, C, D, E>> {
  _MergeConsumableAsyncJoining5(
      {required this.first, required this.second, required this.third, required this.fourth, required this.fifth});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function(A previous) second;

  final FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third;

  final FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth;

  final FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple5<A, B, C, D, E> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second(firstValue)).consume(
          onSuccess: (secondValue) async => (await third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )))
              .consume(
            onSuccess: (thirdValue) async => (await fourth(Tuple3<A, B, C>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
            )))
                .consume(
              onSuccess: (fourthValue) async => (await fifth(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )))
                  .consume(
                onSuccess: (fifthValue) => onSuccess(Tuple5<A, B, C, D, E>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                )),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumable6<A, B, C, D, E, F> with ConsumableMixin<Tuple6<A, B, C, D, E, F>> {
  _MergeConsumable6(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth});

  final Consumable<A> first;

  final Consumable<B> Function() second;

  final Consumable<C> Function() third;

  final Consumable<D> Function() fourth;

  final Consumable<E> Function() fifth;

  final Consumable<F> Function() sixth;

  @override
  T consume<T>(
          {required T Function(Tuple6<A, B, C, D, E, F> value) onSuccess,
          required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second().consume(
          onSuccess: (secondValue) => third().consume(
            onSuccess: (thirdValue) => fourth().consume(
              onSuccess: (fourthValue) => fifth().consume(
                onSuccess: (fifthValue) => sixth().consume(
                  onSuccess: (sixthValue) => onSuccess(Tuple6<A, B, C, D, E, F>(
                    first: firstValue,
                    second: secondValue,
                    third: thirdValue,
                    fourth: fourthValue,
                    fifth: fifthValue,
                    sixth: sixthValue,
                  )),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsync6<A, B, C, D, E, F> with ConsumableAsyncMixin<Tuple6<A, B, C, D, E, F>> {
  _MergeConsumableAsync6(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function() second;

  final FutureOr<ConsumableAsync<C>> Function() third;

  final FutureOr<ConsumableAsync<D>> Function() fourth;

  final FutureOr<ConsumableAsync<E>> Function() fifth;

  final FutureOr<ConsumableAsync<F>> Function() sixth;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple6<A, B, C, D, E, F> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second()).consume(
          onSuccess: (secondValue) async => (await third()).consume(
            onSuccess: (thirdValue) async => (await fourth()).consume(
              onSuccess: (fourthValue) async => (await fifth()).consume(
                onSuccess: (fifthValue) async => (await sixth()).consume(
                  onSuccess: (sixthValue) => onSuccess(Tuple6<A, B, C, D, E, F>(
                    first: firstValue,
                    second: secondValue,
                    third: thirdValue,
                    fourth: fourthValue,
                    fifth: fifthValue,
                    sixth: sixthValue,
                  )),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableJoining6<A, B, C, D, E, F> with ConsumableMixin<Tuple6<A, B, C, D, E, F>> {
  _MergeConsumableJoining6(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth});

  final Consumable<A> first;

  final Consumable<B> Function(A previous) second;

  final Consumable<C> Function(Tuple<A, B> previous) third;

  final Consumable<D> Function(Tuple3<A, B, C> previous) fourth;

  final Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth;

  final Consumable<F> Function(Tuple5<A, B, C, D, E> previous) sixth;

  @override
  T consume<T>(
          {required T Function(Tuple6<A, B, C, D, E, F> value) onSuccess,
          required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second(firstValue).consume(
          onSuccess: (secondValue) => third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )).consume(
            onSuccess: (thirdValue) => fourth(Tuple3<A, B, C>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
            )).consume(
              onSuccess: (fourthValue) => fifth(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )).consume(
                onSuccess: (fifthValue) => sixth(Tuple5<A, B, C, D, E>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                )).consume(
                  onSuccess: (sixthValue) => onSuccess(Tuple6<A, B, C, D, E, F>(
                    first: firstValue,
                    second: secondValue,
                    third: thirdValue,
                    fourth: fourthValue,
                    fifth: fifthValue,
                    sixth: sixthValue,
                  )),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsyncJoining6<A, B, C, D, E, F> with ConsumableAsyncMixin<Tuple6<A, B, C, D, E, F>> {
  _MergeConsumableAsyncJoining6(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function(A previous) second;

  final FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third;

  final FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth;

  final FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth;

  final FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple6<A, B, C, D, E, F> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second(firstValue)).consume(
          onSuccess: (secondValue) async => (await third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )))
              .consume(
            onSuccess: (thirdValue) async => (await fourth(Tuple3<A, B, C>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
            )))
                .consume(
              onSuccess: (fourthValue) async => (await fifth(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )))
                  .consume(
                onSuccess: (fifthValue) async => (await sixth(Tuple5<A, B, C, D, E>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                )))
                    .consume(
                  onSuccess: (sixthValue) => onSuccess(Tuple6<A, B, C, D, E, F>(
                    first: firstValue,
                    second: secondValue,
                    third: thirdValue,
                    fourth: fourthValue,
                    fifth: fifthValue,
                    sixth: sixthValue,
                  )),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumable7<A, B, C, D, E, F, G> with ConsumableMixin<Tuple7<A, B, C, D, E, F, G>> {
  _MergeConsumable7(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh});

  final Consumable<A> first;

  final Consumable<B> Function() second;

  final Consumable<C> Function() third;

  final Consumable<D> Function() fourth;

  final Consumable<E> Function() fifth;

  final Consumable<F> Function() sixth;

  final Consumable<G> Function() seventh;

  @override
  T consume<T>(
          {required T Function(Tuple7<A, B, C, D, E, F, G> value) onSuccess,
          required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second().consume(
          onSuccess: (secondValue) => third().consume(
            onSuccess: (thirdValue) => fourth().consume(
              onSuccess: (fourthValue) => fifth().consume(
                onSuccess: (fifthValue) => sixth().consume(
                  onSuccess: (sixthValue) => seventh().consume(
                    onSuccess: (seventhValue) => onSuccess(Tuple7<A, B, C, D, E, F, G>(
                      first: firstValue,
                      second: secondValue,
                      third: thirdValue,
                      fourth: fourthValue,
                      fifth: fifthValue,
                      sixth: sixthValue,
                      seventh: seventhValue,
                    )),
                    onError: onError,
                  ),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsync7<A, B, C, D, E, F, G> with ConsumableAsyncMixin<Tuple7<A, B, C, D, E, F, G>> {
  _MergeConsumableAsync7(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function() second;

  final FutureOr<ConsumableAsync<C>> Function() third;

  final FutureOr<ConsumableAsync<D>> Function() fourth;

  final FutureOr<ConsumableAsync<E>> Function() fifth;

  final FutureOr<ConsumableAsync<F>> Function() sixth;

  final FutureOr<ConsumableAsync<G>> Function() seventh;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple7<A, B, C, D, E, F, G> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second()).consume(
          onSuccess: (secondValue) async => (await third()).consume(
            onSuccess: (thirdValue) async => (await fourth()).consume(
              onSuccess: (fourthValue) async => (await fifth()).consume(
                onSuccess: (fifthValue) async => (await sixth()).consume(
                  onSuccess: (sixthValue) async => (await seventh()).consume(
                    onSuccess: (seventhValue) => onSuccess(Tuple7<A, B, C, D, E, F, G>(
                      first: firstValue,
                      second: secondValue,
                      third: thirdValue,
                      fourth: fourthValue,
                      fifth: fifthValue,
                      sixth: sixthValue,
                      seventh: seventhValue,
                    )),
                    onError: onError,
                  ),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableJoining7<A, B, C, D, E, F, G> with ConsumableMixin<Tuple7<A, B, C, D, E, F, G>> {
  _MergeConsumableJoining7(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh});

  final Consumable<A> first;

  final Consumable<B> Function(A previous) second;

  final Consumable<C> Function(Tuple<A, B> previous) third;

  final Consumable<D> Function(Tuple3<A, B, C> previous) fourth;

  final Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth;

  final Consumable<F> Function(Tuple5<A, B, C, D, E> previous) sixth;

  final Consumable<G> Function(Tuple6<A, B, C, D, E, F> previous) seventh;

  @override
  T consume<T>(
          {required T Function(Tuple7<A, B, C, D, E, F, G> value) onSuccess,
          required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second(firstValue).consume(
          onSuccess: (secondValue) => third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )).consume(
            onSuccess: (thirdValue) => fourth(Tuple3<A, B, C>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
            )).consume(
              onSuccess: (fourthValue) => fifth(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )).consume(
                onSuccess: (fifthValue) => sixth(Tuple5<A, B, C, D, E>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                )).consume(
                  onSuccess: (sixthValue) => seventh(Tuple6<A, B, C, D, E, F>(
                    first: firstValue,
                    second: secondValue,
                    third: thirdValue,
                    fourth: fourthValue,
                    fifth: fifthValue,
                    sixth: sixthValue,
                  )).consume(
                    onSuccess: (seventhValue) => onSuccess(Tuple7<A, B, C, D, E, F, G>(
                      first: firstValue,
                      second: secondValue,
                      third: thirdValue,
                      fourth: fourthValue,
                      fifth: fifthValue,
                      sixth: sixthValue,
                      seventh: seventhValue,
                    )),
                    onError: onError,
                  ),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsyncJoining7<A, B, C, D, E, F, G> with ConsumableAsyncMixin<Tuple7<A, B, C, D, E, F, G>> {
  _MergeConsumableAsyncJoining7(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function(A previous) second;

  final FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third;

  final FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth;

  final FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth;

  final FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth;

  final FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple7<A, B, C, D, E, F, G> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second(firstValue)).consume(
          onSuccess: (secondValue) async => (await third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )))
              .consume(
            onSuccess: (thirdValue) async => (await fourth(Tuple3<A, B, C>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
            )))
                .consume(
              onSuccess: (fourthValue) async => (await fifth(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )))
                  .consume(
                onSuccess: (fifthValue) async => (await sixth(Tuple5<A, B, C, D, E>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                )))
                    .consume(
                  onSuccess: (sixthValue) async => (await seventh(Tuple6<A, B, C, D, E, F>(
                    first: firstValue,
                    second: secondValue,
                    third: thirdValue,
                    fourth: fourthValue,
                    fifth: fifthValue,
                    sixth: sixthValue,
                  )))
                      .consume(
                    onSuccess: (seventhValue) => onSuccess(Tuple7<A, B, C, D, E, F, G>(
                      first: firstValue,
                      second: secondValue,
                      third: thirdValue,
                      fourth: fourthValue,
                      fifth: fifthValue,
                      sixth: sixthValue,
                      seventh: seventhValue,
                    )),
                    onError: onError,
                  ),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumable8<A, B, C, D, E, F, G, H> with ConsumableMixin<Tuple8<A, B, C, D, E, F, G, H>> {
  _MergeConsumable8(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh,
      required this.eighth});

  final Consumable<A> first;

  final Consumable<B> Function() second;

  final Consumable<C> Function() third;

  final Consumable<D> Function() fourth;

  final Consumable<E> Function() fifth;

  final Consumable<F> Function() sixth;

  final Consumable<G> Function() seventh;

  final Consumable<H> Function() eighth;

  @override
  T consume<T>(
          {required T Function(Tuple8<A, B, C, D, E, F, G, H> value) onSuccess,
          required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second().consume(
          onSuccess: (secondValue) => third().consume(
            onSuccess: (thirdValue) => fourth().consume(
              onSuccess: (fourthValue) => fifth().consume(
                onSuccess: (fifthValue) => sixth().consume(
                  onSuccess: (sixthValue) => seventh().consume(
                    onSuccess: (seventhValue) => eighth().consume(
                      onSuccess: (eighthValue) => onSuccess(Tuple8<A, B, C, D, E, F, G, H>(
                        first: firstValue,
                        second: secondValue,
                        third: thirdValue,
                        fourth: fourthValue,
                        fifth: fifthValue,
                        sixth: sixthValue,
                        seventh: seventhValue,
                        eighth: eighthValue,
                      )),
                      onError: onError,
                    ),
                    onError: onError,
                  ),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsync8<A, B, C, D, E, F, G, H> with ConsumableAsyncMixin<Tuple8<A, B, C, D, E, F, G, H>> {
  _MergeConsumableAsync8(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh,
      required this.eighth});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function() second;

  final FutureOr<ConsumableAsync<C>> Function() third;

  final FutureOr<ConsumableAsync<D>> Function() fourth;

  final FutureOr<ConsumableAsync<E>> Function() fifth;

  final FutureOr<ConsumableAsync<F>> Function() sixth;

  final FutureOr<ConsumableAsync<G>> Function() seventh;

  final FutureOr<ConsumableAsync<H>> Function() eighth;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple8<A, B, C, D, E, F, G, H> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second()).consume(
          onSuccess: (secondValue) async => (await third()).consume(
            onSuccess: (thirdValue) async => (await fourth()).consume(
              onSuccess: (fourthValue) async => (await fifth()).consume(
                onSuccess: (fifthValue) async => (await sixth()).consume(
                  onSuccess: (sixthValue) async => (await seventh()).consume(
                    onSuccess: (seventhValue) async => (await eighth()).consume(
                      onSuccess: (eighthValue) => onSuccess(Tuple8<A, B, C, D, E, F, G, H>(
                        first: firstValue,
                        second: secondValue,
                        third: thirdValue,
                        fourth: fourthValue,
                        fifth: fifthValue,
                        sixth: sixthValue,
                        seventh: seventhValue,
                        eighth: eighthValue,
                      )),
                      onError: onError,
                    ),
                    onError: onError,
                  ),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableJoining8<A, B, C, D, E, F, G, H> with ConsumableMixin<Tuple8<A, B, C, D, E, F, G, H>> {
  _MergeConsumableJoining8(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh,
      required this.eighth});

  final Consumable<A> first;

  final Consumable<B> Function(A previous) second;

  final Consumable<C> Function(Tuple<A, B> previous) third;

  final Consumable<D> Function(Tuple3<A, B, C> previous) fourth;

  final Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth;

  final Consumable<F> Function(Tuple5<A, B, C, D, E> previous) sixth;

  final Consumable<G> Function(Tuple6<A, B, C, D, E, F> previous) seventh;

  final Consumable<H> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth;

  @override
  T consume<T>(
          {required T Function(Tuple8<A, B, C, D, E, F, G, H> value) onSuccess,
          required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second(firstValue).consume(
          onSuccess: (secondValue) => third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )).consume(
            onSuccess: (thirdValue) => fourth(Tuple3<A, B, C>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
            )).consume(
              onSuccess: (fourthValue) => fifth(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )).consume(
                onSuccess: (fifthValue) => sixth(Tuple5<A, B, C, D, E>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                )).consume(
                  onSuccess: (sixthValue) => seventh(Tuple6<A, B, C, D, E, F>(
                    first: firstValue,
                    second: secondValue,
                    third: thirdValue,
                    fourth: fourthValue,
                    fifth: fifthValue,
                    sixth: sixthValue,
                  )).consume(
                    onSuccess: (seventhValue) => eighth(Tuple7<A, B, C, D, E, F, G>(
                      first: firstValue,
                      second: secondValue,
                      third: thirdValue,
                      fourth: fourthValue,
                      fifth: fifthValue,
                      sixth: sixthValue,
                      seventh: seventhValue,
                    )).consume(
                      onSuccess: (eighthValue) => onSuccess(Tuple8<A, B, C, D, E, F, G, H>(
                        first: firstValue,
                        second: secondValue,
                        third: thirdValue,
                        fourth: fourthValue,
                        fifth: fifthValue,
                        sixth: sixthValue,
                        seventh: seventhValue,
                        eighth: eighthValue,
                      )),
                      onError: onError,
                    ),
                    onError: onError,
                  ),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsyncJoining8<A, B, C, D, E, F, G, H> with ConsumableAsyncMixin<Tuple8<A, B, C, D, E, F, G, H>> {
  _MergeConsumableAsyncJoining8(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh,
      required this.eighth});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function(A previous) second;

  final FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third;

  final FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth;

  final FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth;

  final FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth;

  final FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh;

  final FutureOr<ConsumableAsync<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple8<A, B, C, D, E, F, G, H> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second(firstValue)).consume(
          onSuccess: (secondValue) async => (await third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )))
              .consume(
            onSuccess: (thirdValue) async => (await fourth(Tuple3<A, B, C>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
            )))
                .consume(
              onSuccess: (fourthValue) async => (await fifth(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )))
                  .consume(
                onSuccess: (fifthValue) async => (await sixth(Tuple5<A, B, C, D, E>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                )))
                    .consume(
                  onSuccess: (sixthValue) async => (await seventh(Tuple6<A, B, C, D, E, F>(
                    first: firstValue,
                    second: secondValue,
                    third: thirdValue,
                    fourth: fourthValue,
                    fifth: fifthValue,
                    sixth: sixthValue,
                  )))
                      .consume(
                    onSuccess: (seventhValue) async => (await eighth(Tuple7<A, B, C, D, E, F, G>(
                      first: firstValue,
                      second: secondValue,
                      third: thirdValue,
                      fourth: fourthValue,
                      fifth: fifthValue,
                      sixth: sixthValue,
                      seventh: seventhValue,
                    )))
                        .consume(
                      onSuccess: (eighthValue) => onSuccess(Tuple8<A, B, C, D, E, F, G, H>(
                        first: firstValue,
                        second: secondValue,
                        third: thirdValue,
                        fourth: fourthValue,
                        fifth: fifthValue,
                        sixth: sixthValue,
                        seventh: seventhValue,
                        eighth: eighthValue,
                      )),
                      onError: onError,
                    ),
                    onError: onError,
                  ),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumable9<A, B, C, D, E, F, G, H, I> with ConsumableMixin<Tuple9<A, B, C, D, E, F, G, H, I>> {
  _MergeConsumable9(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh,
      required this.eighth,
      required this.ninth});

  final Consumable<A> first;

  final Consumable<B> Function() second;

  final Consumable<C> Function() third;

  final Consumable<D> Function() fourth;

  final Consumable<E> Function() fifth;

  final Consumable<F> Function() sixth;

  final Consumable<G> Function() seventh;

  final Consumable<H> Function() eighth;

  final Consumable<I> Function() ninth;

  @override
  T consume<T>(
          {required T Function(Tuple9<A, B, C, D, E, F, G, H, I> value) onSuccess,
          required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second().consume(
          onSuccess: (secondValue) => third().consume(
            onSuccess: (thirdValue) => fourth().consume(
              onSuccess: (fourthValue) => fifth().consume(
                onSuccess: (fifthValue) => sixth().consume(
                  onSuccess: (sixthValue) => seventh().consume(
                    onSuccess: (seventhValue) => eighth().consume(
                      onSuccess: (eighthValue) => ninth().consume(
                        onSuccess: (ninthValue) => onSuccess(Tuple9<A, B, C, D, E, F, G, H, I>(
                          first: firstValue,
                          second: secondValue,
                          third: thirdValue,
                          fourth: fourthValue,
                          fifth: fifthValue,
                          sixth: sixthValue,
                          seventh: seventhValue,
                          eighth: eighthValue,
                          ninth: ninthValue,
                        )),
                        onError: onError,
                      ),
                      onError: onError,
                    ),
                    onError: onError,
                  ),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsync9<A, B, C, D, E, F, G, H, I> with ConsumableAsyncMixin<Tuple9<A, B, C, D, E, F, G, H, I>> {
  _MergeConsumableAsync9(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh,
      required this.eighth,
      required this.ninth});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function() second;

  final FutureOr<ConsumableAsync<C>> Function() third;

  final FutureOr<ConsumableAsync<D>> Function() fourth;

  final FutureOr<ConsumableAsync<E>> Function() fifth;

  final FutureOr<ConsumableAsync<F>> Function() sixth;

  final FutureOr<ConsumableAsync<G>> Function() seventh;

  final FutureOr<ConsumableAsync<H>> Function() eighth;

  final FutureOr<ConsumableAsync<I>> Function() ninth;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple9<A, B, C, D, E, F, G, H, I> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second()).consume(
          onSuccess: (secondValue) async => (await third()).consume(
            onSuccess: (thirdValue) async => (await fourth()).consume(
              onSuccess: (fourthValue) async => (await fifth()).consume(
                onSuccess: (fifthValue) async => (await sixth()).consume(
                  onSuccess: (sixthValue) async => (await seventh()).consume(
                    onSuccess: (seventhValue) async => (await eighth()).consume(
                      onSuccess: (eighthValue) async => (await ninth()).consume(
                        onSuccess: (ninthValue) => onSuccess(Tuple9<A, B, C, D, E, F, G, H, I>(
                          first: firstValue,
                          second: secondValue,
                          third: thirdValue,
                          fourth: fourthValue,
                          fifth: fifthValue,
                          sixth: sixthValue,
                          seventh: seventhValue,
                          eighth: eighthValue,
                          ninth: ninthValue,
                        )),
                        onError: onError,
                      ),
                      onError: onError,
                    ),
                    onError: onError,
                  ),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableJoining9<A, B, C, D, E, F, G, H, I> with ConsumableMixin<Tuple9<A, B, C, D, E, F, G, H, I>> {
  _MergeConsumableJoining9(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh,
      required this.eighth,
      required this.ninth});

  final Consumable<A> first;

  final Consumable<B> Function(A previous) second;

  final Consumable<C> Function(Tuple<A, B> previous) third;

  final Consumable<D> Function(Tuple3<A, B, C> previous) fourth;

  final Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth;

  final Consumable<F> Function(Tuple5<A, B, C, D, E> previous) sixth;

  final Consumable<G> Function(Tuple6<A, B, C, D, E, F> previous) seventh;

  final Consumable<H> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth;

  final Consumable<I> Function(Tuple8<A, B, C, D, E, F, G, H> previous) ninth;

  @override
  T consume<T>(
          {required T Function(Tuple9<A, B, C, D, E, F, G, H, I> value) onSuccess,
          required T Function(Failure failure) onError}) =>
      first.consume(
        onSuccess: (firstValue) => second(firstValue).consume(
          onSuccess: (secondValue) => third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )).consume(
            onSuccess: (thirdValue) => fourth(Tuple3<A, B, C>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
            )).consume(
              onSuccess: (fourthValue) => fifth(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )).consume(
                onSuccess: (fifthValue) => sixth(Tuple5<A, B, C, D, E>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                )).consume(
                  onSuccess: (sixthValue) => seventh(Tuple6<A, B, C, D, E, F>(
                    first: firstValue,
                    second: secondValue,
                    third: thirdValue,
                    fourth: fourthValue,
                    fifth: fifthValue,
                    sixth: sixthValue,
                  )).consume(
                    onSuccess: (seventhValue) => eighth(Tuple7<A, B, C, D, E, F, G>(
                      first: firstValue,
                      second: secondValue,
                      third: thirdValue,
                      fourth: fourthValue,
                      fifth: fifthValue,
                      sixth: sixthValue,
                      seventh: seventhValue,
                    )).consume(
                      onSuccess: (eighthValue) => ninth(Tuple8<A, B, C, D, E, F, G, H>(
                        first: firstValue,
                        second: secondValue,
                        third: thirdValue,
                        fourth: fourthValue,
                        fifth: fifthValue,
                        sixth: sixthValue,
                        seventh: seventhValue,
                        eighth: eighthValue,
                      )).consume(
                        onSuccess: (ninthValue) => onSuccess(Tuple9<A, B, C, D, E, F, G, H, I>(
                          first: firstValue,
                          second: secondValue,
                          third: thirdValue,
                          fourth: fourthValue,
                          fifth: fifthValue,
                          sixth: sixthValue,
                          seventh: seventhValue,
                          eighth: eighthValue,
                          ninth: ninthValue,
                        )),
                        onError: onError,
                      ),
                      onError: onError,
                    ),
                    onError: onError,
                  ),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

class _MergeConsumableAsyncJoining9<A, B, C, D, E, F, G, H, I>
    with ConsumableAsyncMixin<Tuple9<A, B, C, D, E, F, G, H, I>> {
  _MergeConsumableAsyncJoining9(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh,
      required this.eighth,
      required this.ninth});

  final ConsumableAsync<A> first;

  final FutureOr<ConsumableAsync<B>> Function(A previous) second;

  final FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third;

  final FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth;

  final FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth;

  final FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth;

  final FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh;

  final FutureOr<ConsumableAsync<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth;

  final FutureOr<ConsumableAsync<I>> Function(Tuple8<A, B, C, D, E, F, G, H> previous) ninth;

  @override
  Future<T> consume<T>(
          {required FutureOr<T> Function(Tuple9<A, B, C, D, E, F, G, H, I> value) onSuccess,
          required FutureOr<T> Function(Failure failure) onError}) async =>
      first.consume(
        onSuccess: (firstValue) async => (await second(firstValue)).consume(
          onSuccess: (secondValue) async => (await third(Tuple<A, B>(
            first: firstValue,
            second: secondValue,
          )))
              .consume(
            onSuccess: (thirdValue) async => (await fourth(Tuple3<A, B, C>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
            )))
                .consume(
              onSuccess: (fourthValue) async => (await fifth(Tuple4<A, B, C, D>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
              )))
                  .consume(
                onSuccess: (fifthValue) async => (await sixth(Tuple5<A, B, C, D, E>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                )))
                    .consume(
                  onSuccess: (sixthValue) async => (await seventh(Tuple6<A, B, C, D, E, F>(
                    first: firstValue,
                    second: secondValue,
                    third: thirdValue,
                    fourth: fourthValue,
                    fifth: fifthValue,
                    sixth: sixthValue,
                  )))
                      .consume(
                    onSuccess: (seventhValue) async => (await eighth(Tuple7<A, B, C, D, E, F, G>(
                      first: firstValue,
                      second: secondValue,
                      third: thirdValue,
                      fourth: fourthValue,
                      fifth: fifthValue,
                      sixth: sixthValue,
                      seventh: seventhValue,
                    )))
                        .consume(
                      onSuccess: (eighthValue) async => (await ninth(Tuple8<A, B, C, D, E, F, G, H>(
                        first: firstValue,
                        second: secondValue,
                        third: thirdValue,
                        fourth: fourthValue,
                        fifth: fifthValue,
                        sixth: sixthValue,
                        seventh: seventhValue,
                        eighth: eighthValue,
                      )))
                          .consume(
                        onSuccess: (ninthValue) => onSuccess(Tuple9<A, B, C, D, E, F, G, H, I>(
                          first: firstValue,
                          second: secondValue,
                          third: thirdValue,
                          fourth: fourthValue,
                          fifth: fifthValue,
                          sixth: sixthValue,
                          seventh: seventhValue,
                          eighth: eighthValue,
                          ninth: ninthValue,
                        )),
                        onError: onError,
                      ),
                      onError: onError,
                    ),
                    onError: onError,
                  ),
                  onError: onError,
                ),
                onError: onError,
              ),
              onError: onError,
            ),
            onError: onError,
          ),
          onError: onError,
        ),
        onError: onError,
      );
}

extension FutureMergeConsumableExtension<A> on Future<Consumable<A>> {
  Future<Consumable<Tuple<A, B>>> merge<B>({required Consumable<B> Function() second}) async => _MergeConsumable<A, B>(
        first: await this,
        second: second,
      );
  Future<ConsumableAsync<Tuple<A, B>>> mergeAsync<B>({required FutureOr<ConsumableAsync<B>> Function() second}) async =>
      _MergeConsumableAsync<A, B>(
        first: (await this).toConsumableAsync(),
        second: second,
      );
  Future<Consumable<Tuple<A, B>>> mergeJoining<B>({required Consumable<B> Function(A previous) second}) async =>
      _MergeConsumableJoining<A, B>(
        first: await this,
        second: second,
      );
  Future<ConsumableAsync<Tuple<A, B>>> mergeAsyncJoining<B>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second}) async =>
      _MergeConsumableAsyncJoining<A, B>(
        first: (await this).toConsumableAsync(),
        second: second,
      );
  Future<Consumable<Tuple3<A, B, C>>> merge3<B, C>(
          {required Consumable<B> Function() second, required Consumable<C> Function() third}) async =>
      _MergeConsumable3<A, B, C>(
        first: await this,
        second: second,
        third: third,
      );
  Future<ConsumableAsync<Tuple3<A, B, C>>> mergeAsync3<B, C>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third}) async =>
      _MergeConsumableAsync3<A, B, C>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
      );
  Future<Consumable<Tuple3<A, B, C>>> mergeJoining3<B, C>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third}) async =>
      _MergeConsumableJoining3<A, B, C>(
        first: await this,
        second: second,
        third: third,
      );
  Future<ConsumableAsync<Tuple3<A, B, C>>> mergeAsyncJoining3<B, C>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third}) async =>
      _MergeConsumableAsyncJoining3<A, B, C>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
      );
  Future<Consumable<Tuple4<A, B, C, D>>> merge4<B, C, D>(
          {required Consumable<B> Function() second,
          required Consumable<C> Function() third,
          required Consumable<D> Function() fourth}) async =>
      _MergeConsumable4<A, B, C, D>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
      );
  Future<ConsumableAsync<Tuple4<A, B, C, D>>> mergeAsync4<B, C, D>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth}) async =>
      _MergeConsumableAsync4<A, B, C, D>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
      );
  Future<Consumable<Tuple4<A, B, C, D>>> mergeJoining4<B, C, D>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third,
          required Consumable<D> Function(Tuple3<A, B, C> previous) fourth}) async =>
      _MergeConsumableJoining4<A, B, C, D>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
      );
  Future<ConsumableAsync<Tuple4<A, B, C, D>>> mergeAsyncJoining4<B, C, D>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth}) async =>
      _MergeConsumableAsyncJoining4<A, B, C, D>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
      );
  Future<Consumable<Tuple5<A, B, C, D, E>>> merge5<B, C, D, E>(
          {required Consumable<B> Function() second,
          required Consumable<C> Function() third,
          required Consumable<D> Function() fourth,
          required Consumable<E> Function() fifth}) async =>
      _MergeConsumable5<A, B, C, D, E>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  Future<ConsumableAsync<Tuple5<A, B, C, D, E>>> mergeAsync5<B, C, D, E>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth}) async =>
      _MergeConsumableAsync5<A, B, C, D, E>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  Future<Consumable<Tuple5<A, B, C, D, E>>> mergeJoining5<B, C, D, E>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third,
          required Consumable<D> Function(Tuple3<A, B, C> previous) fourth,
          required Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth}) async =>
      _MergeConsumableJoining5<A, B, C, D, E>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  Future<ConsumableAsync<Tuple5<A, B, C, D, E>>> mergeAsyncJoining5<B, C, D, E>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth}) async =>
      _MergeConsumableAsyncJoining5<A, B, C, D, E>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  Future<Consumable<Tuple6<A, B, C, D, E, F>>> merge6<B, C, D, E, F>(
          {required Consumable<B> Function() second,
          required Consumable<C> Function() third,
          required Consumable<D> Function() fourth,
          required Consumable<E> Function() fifth,
          required Consumable<F> Function() sixth}) async =>
      _MergeConsumable6<A, B, C, D, E, F>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Future<ConsumableAsync<Tuple6<A, B, C, D, E, F>>> mergeAsync6<B, C, D, E, F>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth}) async =>
      _MergeConsumableAsync6<A, B, C, D, E, F>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Future<Consumable<Tuple6<A, B, C, D, E, F>>> mergeJoining6<B, C, D, E, F>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third,
          required Consumable<D> Function(Tuple3<A, B, C> previous) fourth,
          required Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth,
          required Consumable<F> Function(Tuple5<A, B, C, D, E> previous) sixth}) async =>
      _MergeConsumableJoining6<A, B, C, D, E, F>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Future<ConsumableAsync<Tuple6<A, B, C, D, E, F>>> mergeAsyncJoining6<B, C, D, E, F>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth}) async =>
      _MergeConsumableAsyncJoining6<A, B, C, D, E, F>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Future<Consumable<Tuple7<A, B, C, D, E, F, G>>> merge7<B, C, D, E, F, G>(
          {required Consumable<B> Function() second,
          required Consumable<C> Function() third,
          required Consumable<D> Function() fourth,
          required Consumable<E> Function() fifth,
          required Consumable<F> Function() sixth,
          required Consumable<G> Function() seventh}) async =>
      _MergeConsumable7<A, B, C, D, E, F, G>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Future<ConsumableAsync<Tuple7<A, B, C, D, E, F, G>>> mergeAsync7<B, C, D, E, F, G>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth,
          required FutureOr<ConsumableAsync<G>> Function() seventh}) async =>
      _MergeConsumableAsync7<A, B, C, D, E, F, G>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Future<Consumable<Tuple7<A, B, C, D, E, F, G>>> mergeJoining7<B, C, D, E, F, G>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third,
          required Consumable<D> Function(Tuple3<A, B, C> previous) fourth,
          required Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth,
          required Consumable<F> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required Consumable<G> Function(Tuple6<A, B, C, D, E, F> previous) seventh}) async =>
      _MergeConsumableJoining7<A, B, C, D, E, F, G>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Future<ConsumableAsync<Tuple7<A, B, C, D, E, F, G>>> mergeAsyncJoining7<B, C, D, E, F, G>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh}) async =>
      _MergeConsumableAsyncJoining7<A, B, C, D, E, F, G>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Future<Consumable<Tuple8<A, B, C, D, E, F, G, H>>> merge8<B, C, D, E, F, G, H>(
          {required Consumable<B> Function() second,
          required Consumable<C> Function() third,
          required Consumable<D> Function() fourth,
          required Consumable<E> Function() fifth,
          required Consumable<F> Function() sixth,
          required Consumable<G> Function() seventh,
          required Consumable<H> Function() eighth}) async =>
      _MergeConsumable8<A, B, C, D, E, F, G, H>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Future<ConsumableAsync<Tuple8<A, B, C, D, E, F, G, H>>> mergeAsync8<B, C, D, E, F, G, H>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth,
          required FutureOr<ConsumableAsync<G>> Function() seventh,
          required FutureOr<ConsumableAsync<H>> Function() eighth}) async =>
      _MergeConsumableAsync8<A, B, C, D, E, F, G, H>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Future<Consumable<Tuple8<A, B, C, D, E, F, G, H>>> mergeJoining8<B, C, D, E, F, G, H>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third,
          required Consumable<D> Function(Tuple3<A, B, C> previous) fourth,
          required Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth,
          required Consumable<F> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required Consumable<G> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required Consumable<H> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth}) async =>
      _MergeConsumableJoining8<A, B, C, D, E, F, G, H>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Future<ConsumableAsync<Tuple8<A, B, C, D, E, F, G, H>>> mergeAsyncJoining8<B, C, D, E, F, G, H>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required FutureOr<ConsumableAsync<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth}) async =>
      _MergeConsumableAsyncJoining8<A, B, C, D, E, F, G, H>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Future<Consumable<Tuple9<A, B, C, D, E, F, G, H, I>>> merge9<B, C, D, E, F, G, H, I>(
          {required Consumable<B> Function() second,
          required Consumable<C> Function() third,
          required Consumable<D> Function() fourth,
          required Consumable<E> Function() fifth,
          required Consumable<F> Function() sixth,
          required Consumable<G> Function() seventh,
          required Consumable<H> Function() eighth,
          required Consumable<I> Function() ninth}) async =>
      _MergeConsumable9<A, B, C, D, E, F, G, H, I>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Future<ConsumableAsync<Tuple9<A, B, C, D, E, F, G, H, I>>> mergeAsync9<B, C, D, E, F, G, H, I>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth,
          required FutureOr<ConsumableAsync<G>> Function() seventh,
          required FutureOr<ConsumableAsync<H>> Function() eighth,
          required FutureOr<ConsumableAsync<I>> Function() ninth}) async =>
      _MergeConsumableAsync9<A, B, C, D, E, F, G, H, I>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Future<Consumable<Tuple9<A, B, C, D, E, F, G, H, I>>> mergeJoining9<B, C, D, E, F, G, H, I>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third,
          required Consumable<D> Function(Tuple3<A, B, C> previous) fourth,
          required Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth,
          required Consumable<F> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required Consumable<G> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required Consumable<H> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth,
          required Consumable<I> Function(Tuple8<A, B, C, D, E, F, G, H> previous) ninth}) async =>
      _MergeConsumableJoining9<A, B, C, D, E, F, G, H, I>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Future<ConsumableAsync<Tuple9<A, B, C, D, E, F, G, H, I>>> mergeAsyncJoining9<B, C, D, E, F, G, H, I>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required FutureOr<ConsumableAsync<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth,
          required FutureOr<ConsumableAsync<I>> Function(Tuple8<A, B, C, D, E, F, G, H> previous) ninth}) async =>
      _MergeConsumableAsyncJoining9<A, B, C, D, E, F, G, H, I>(
        first: (await this).toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
}

extension MergeConsumableExtension<A> on Consumable<A> {
  Consumable<Tuple<A, B>> merge<B>({required Consumable<B> Function() second}) => _MergeConsumable<A, B>(
        first: this,
        second: second,
      );
  ConsumableAsync<Tuple<A, B>> mergeAsync<B>({required FutureOr<ConsumableAsync<B>> Function() second}) =>
      _MergeConsumableAsync<A, B>(
        first: toConsumableAsync(),
        second: second,
      );
  Consumable<Tuple<A, B>> mergeJoining<B>({required Consumable<B> Function(A previous) second}) =>
      _MergeConsumableJoining<A, B>(
        first: this,
        second: second,
      );
  ConsumableAsync<Tuple<A, B>> mergeAsyncJoining<B>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second}) =>
      _MergeConsumableAsyncJoining<A, B>(
        first: toConsumableAsync(),
        second: second,
      );
  Consumable<Tuple3<A, B, C>> merge3<B, C>(
          {required Consumable<B> Function() second, required Consumable<C> Function() third}) =>
      _MergeConsumable3<A, B, C>(
        first: this,
        second: second,
        third: third,
      );
  ConsumableAsync<Tuple3<A, B, C>> mergeAsync3<B, C>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third}) =>
      _MergeConsumableAsync3<A, B, C>(
        first: toConsumableAsync(),
        second: second,
        third: third,
      );
  Consumable<Tuple3<A, B, C>> mergeJoining3<B, C>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third}) =>
      _MergeConsumableJoining3<A, B, C>(
        first: this,
        second: second,
        third: third,
      );
  ConsumableAsync<Tuple3<A, B, C>> mergeAsyncJoining3<B, C>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third}) =>
      _MergeConsumableAsyncJoining3<A, B, C>(
        first: toConsumableAsync(),
        second: second,
        third: third,
      );
  Consumable<Tuple4<A, B, C, D>> merge4<B, C, D>(
          {required Consumable<B> Function() second,
          required Consumable<C> Function() third,
          required Consumable<D> Function() fourth}) =>
      _MergeConsumable4<A, B, C, D>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
      );
  ConsumableAsync<Tuple4<A, B, C, D>> mergeAsync4<B, C, D>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth}) =>
      _MergeConsumableAsync4<A, B, C, D>(
        first: toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
      );
  Consumable<Tuple4<A, B, C, D>> mergeJoining4<B, C, D>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third,
          required Consumable<D> Function(Tuple3<A, B, C> previous) fourth}) =>
      _MergeConsumableJoining4<A, B, C, D>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
      );
  ConsumableAsync<Tuple4<A, B, C, D>> mergeAsyncJoining4<B, C, D>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth}) =>
      _MergeConsumableAsyncJoining4<A, B, C, D>(
        first: toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
      );
  Consumable<Tuple5<A, B, C, D, E>> merge5<B, C, D, E>(
          {required Consumable<B> Function() second,
          required Consumable<C> Function() third,
          required Consumable<D> Function() fourth,
          required Consumable<E> Function() fifth}) =>
      _MergeConsumable5<A, B, C, D, E>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  ConsumableAsync<Tuple5<A, B, C, D, E>> mergeAsync5<B, C, D, E>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth}) =>
      _MergeConsumableAsync5<A, B, C, D, E>(
        first: toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  Consumable<Tuple5<A, B, C, D, E>> mergeJoining5<B, C, D, E>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third,
          required Consumable<D> Function(Tuple3<A, B, C> previous) fourth,
          required Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth}) =>
      _MergeConsumableJoining5<A, B, C, D, E>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  ConsumableAsync<Tuple5<A, B, C, D, E>> mergeAsyncJoining5<B, C, D, E>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth}) =>
      _MergeConsumableAsyncJoining5<A, B, C, D, E>(
        first: toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  Consumable<Tuple6<A, B, C, D, E, F>> merge6<B, C, D, E, F>(
          {required Consumable<B> Function() second,
          required Consumable<C> Function() third,
          required Consumable<D> Function() fourth,
          required Consumable<E> Function() fifth,
          required Consumable<F> Function() sixth}) =>
      _MergeConsumable6<A, B, C, D, E, F>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  ConsumableAsync<Tuple6<A, B, C, D, E, F>> mergeAsync6<B, C, D, E, F>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth}) =>
      _MergeConsumableAsync6<A, B, C, D, E, F>(
        first: toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Consumable<Tuple6<A, B, C, D, E, F>> mergeJoining6<B, C, D, E, F>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third,
          required Consumable<D> Function(Tuple3<A, B, C> previous) fourth,
          required Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth,
          required Consumable<F> Function(Tuple5<A, B, C, D, E> previous) sixth}) =>
      _MergeConsumableJoining6<A, B, C, D, E, F>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  ConsumableAsync<Tuple6<A, B, C, D, E, F>> mergeAsyncJoining6<B, C, D, E, F>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth}) =>
      _MergeConsumableAsyncJoining6<A, B, C, D, E, F>(
        first: toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Consumable<Tuple7<A, B, C, D, E, F, G>> merge7<B, C, D, E, F, G>(
          {required Consumable<B> Function() second,
          required Consumable<C> Function() third,
          required Consumable<D> Function() fourth,
          required Consumable<E> Function() fifth,
          required Consumable<F> Function() sixth,
          required Consumable<G> Function() seventh}) =>
      _MergeConsumable7<A, B, C, D, E, F, G>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  ConsumableAsync<Tuple7<A, B, C, D, E, F, G>> mergeAsync7<B, C, D, E, F, G>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth,
          required FutureOr<ConsumableAsync<G>> Function() seventh}) =>
      _MergeConsumableAsync7<A, B, C, D, E, F, G>(
        first: toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Consumable<Tuple7<A, B, C, D, E, F, G>> mergeJoining7<B, C, D, E, F, G>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third,
          required Consumable<D> Function(Tuple3<A, B, C> previous) fourth,
          required Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth,
          required Consumable<F> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required Consumable<G> Function(Tuple6<A, B, C, D, E, F> previous) seventh}) =>
      _MergeConsumableJoining7<A, B, C, D, E, F, G>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  ConsumableAsync<Tuple7<A, B, C, D, E, F, G>> mergeAsyncJoining7<B, C, D, E, F, G>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh}) =>
      _MergeConsumableAsyncJoining7<A, B, C, D, E, F, G>(
        first: toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Consumable<Tuple8<A, B, C, D, E, F, G, H>> merge8<B, C, D, E, F, G, H>(
          {required Consumable<B> Function() second,
          required Consumable<C> Function() third,
          required Consumable<D> Function() fourth,
          required Consumable<E> Function() fifth,
          required Consumable<F> Function() sixth,
          required Consumable<G> Function() seventh,
          required Consumable<H> Function() eighth}) =>
      _MergeConsumable8<A, B, C, D, E, F, G, H>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  ConsumableAsync<Tuple8<A, B, C, D, E, F, G, H>> mergeAsync8<B, C, D, E, F, G, H>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth,
          required FutureOr<ConsumableAsync<G>> Function() seventh,
          required FutureOr<ConsumableAsync<H>> Function() eighth}) =>
      _MergeConsumableAsync8<A, B, C, D, E, F, G, H>(
        first: toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Consumable<Tuple8<A, B, C, D, E, F, G, H>> mergeJoining8<B, C, D, E, F, G, H>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third,
          required Consumable<D> Function(Tuple3<A, B, C> previous) fourth,
          required Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth,
          required Consumable<F> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required Consumable<G> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required Consumable<H> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth}) =>
      _MergeConsumableJoining8<A, B, C, D, E, F, G, H>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  ConsumableAsync<Tuple8<A, B, C, D, E, F, G, H>> mergeAsyncJoining8<B, C, D, E, F, G, H>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required FutureOr<ConsumableAsync<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth}) =>
      _MergeConsumableAsyncJoining8<A, B, C, D, E, F, G, H>(
        first: toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Consumable<Tuple9<A, B, C, D, E, F, G, H, I>> merge9<B, C, D, E, F, G, H, I>(
          {required Consumable<B> Function() second,
          required Consumable<C> Function() third,
          required Consumable<D> Function() fourth,
          required Consumable<E> Function() fifth,
          required Consumable<F> Function() sixth,
          required Consumable<G> Function() seventh,
          required Consumable<H> Function() eighth,
          required Consumable<I> Function() ninth}) =>
      _MergeConsumable9<A, B, C, D, E, F, G, H, I>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  ConsumableAsync<Tuple9<A, B, C, D, E, F, G, H, I>> mergeAsync9<B, C, D, E, F, G, H, I>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth,
          required FutureOr<ConsumableAsync<G>> Function() seventh,
          required FutureOr<ConsumableAsync<H>> Function() eighth,
          required FutureOr<ConsumableAsync<I>> Function() ninth}) =>
      _MergeConsumableAsync9<A, B, C, D, E, F, G, H, I>(
        first: toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Consumable<Tuple9<A, B, C, D, E, F, G, H, I>> mergeJoining9<B, C, D, E, F, G, H, I>(
          {required Consumable<B> Function(A previous) second,
          required Consumable<C> Function(Tuple<A, B> previous) third,
          required Consumable<D> Function(Tuple3<A, B, C> previous) fourth,
          required Consumable<E> Function(Tuple4<A, B, C, D> previous) fifth,
          required Consumable<F> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required Consumable<G> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required Consumable<H> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth,
          required Consumable<I> Function(Tuple8<A, B, C, D, E, F, G, H> previous) ninth}) =>
      _MergeConsumableJoining9<A, B, C, D, E, F, G, H, I>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  ConsumableAsync<Tuple9<A, B, C, D, E, F, G, H, I>> mergeAsyncJoining9<B, C, D, E, F, G, H, I>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required FutureOr<ConsumableAsync<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth,
          required FutureOr<ConsumableAsync<I>> Function(Tuple8<A, B, C, D, E, F, G, H> previous) ninth}) =>
      _MergeConsumableAsyncJoining9<A, B, C, D, E, F, G, H, I>(
        first: toConsumableAsync(),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
}

extension FutureMergeConsumableAsyncExtension<A> on Future<ConsumableAsync<A>> {
  Future<ConsumableAsync<Tuple<A, B>>> merge<B>({required FutureOr<ConsumableAsync<B>> Function() second}) async =>
      _MergeConsumableAsync<A, B>(
        first: await this,
        second: second,
      );
  Future<ConsumableAsync<Tuple<A, B>>> mergeSync<B>({required FutureOr<Consumable<B>> Function() second}) async =>
      _MergeConsumableAsync<A, B>(
        first: await this,
        second: () async => (await second()).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple<A, B>>> mergeJoining<B>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second}) async =>
      _MergeConsumableAsyncJoining<A, B>(
        first: await this,
        second: second,
      );
  Future<ConsumableAsync<Tuple<A, B>>> mergeSyncJoining<B>(
          {required FutureOr<Consumable<B>> Function(A previous) second}) async =>
      _MergeConsumableAsyncJoining<A, B>(
        first: await this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple3<A, B, C>>> merge3<B, C>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third}) async =>
      _MergeConsumableAsync3<A, B, C>(
        first: await this,
        second: second,
        third: third,
      );
  Future<ConsumableAsync<Tuple3<A, B, C>>> mergeSync3<B, C>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third}) async =>
      _MergeConsumableAsync3<A, B, C>(
        first: await this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple3<A, B, C>>> mergeJoining3<B, C>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third}) async =>
      _MergeConsumableAsyncJoining3<A, B, C>(
        first: await this,
        second: second,
        third: third,
      );
  Future<ConsumableAsync<Tuple3<A, B, C>>> mergeSyncJoining3<B, C>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third}) async =>
      _MergeConsumableAsyncJoining3<A, B, C>(
        first: await this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple4<A, B, C, D>>> merge4<B, C, D>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth}) async =>
      _MergeConsumableAsync4<A, B, C, D>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
      );
  Future<ConsumableAsync<Tuple4<A, B, C, D>>> mergeSync4<B, C, D>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third,
          required FutureOr<Consumable<D>> Function() fourth}) async =>
      _MergeConsumableAsync4<A, B, C, D>(
        first: await this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
        fourth: () async => (await fourth()).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple4<A, B, C, D>>> mergeJoining4<B, C, D>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth}) async =>
      _MergeConsumableAsyncJoining4<A, B, C, D>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
      );
  Future<ConsumableAsync<Tuple4<A, B, C, D>>> mergeSyncJoining4<B, C, D>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<Consumable<D>> Function(Tuple3<A, B, C> previous) fourth}) async =>
      _MergeConsumableAsyncJoining4<A, B, C, D>(
        first: await this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
        fourth: (previous) async => (await fourth(previous)).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple5<A, B, C, D, E>>> merge5<B, C, D, E>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth}) async =>
      _MergeConsumableAsync5<A, B, C, D, E>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  Future<ConsumableAsync<Tuple5<A, B, C, D, E>>> mergeSync5<B, C, D, E>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third,
          required FutureOr<Consumable<D>> Function() fourth,
          required FutureOr<Consumable<E>> Function() fifth}) async =>
      _MergeConsumableAsync5<A, B, C, D, E>(
        first: await this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
        fourth: () async => (await fourth()).toConsumableAsync(),
        fifth: () async => (await fifth()).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple5<A, B, C, D, E>>> mergeJoining5<B, C, D, E>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth}) async =>
      _MergeConsumableAsyncJoining5<A, B, C, D, E>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  Future<ConsumableAsync<Tuple5<A, B, C, D, E>>> mergeSyncJoining5<B, C, D, E>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<Consumable<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<Consumable<E>> Function(Tuple4<A, B, C, D> previous) fifth}) async =>
      _MergeConsumableAsyncJoining5<A, B, C, D, E>(
        first: await this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
        fourth: (previous) async => (await fourth(previous)).toConsumableAsync(),
        fifth: (previous) async => (await fifth(previous)).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple6<A, B, C, D, E, F>>> merge6<B, C, D, E, F>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth}) async =>
      _MergeConsumableAsync6<A, B, C, D, E, F>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Future<ConsumableAsync<Tuple6<A, B, C, D, E, F>>> mergeSync6<B, C, D, E, F>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third,
          required FutureOr<Consumable<D>> Function() fourth,
          required FutureOr<Consumable<E>> Function() fifth,
          required FutureOr<Consumable<F>> Function() sixth}) async =>
      _MergeConsumableAsync6<A, B, C, D, E, F>(
        first: await this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
        fourth: () async => (await fourth()).toConsumableAsync(),
        fifth: () async => (await fifth()).toConsumableAsync(),
        sixth: () async => (await sixth()).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple6<A, B, C, D, E, F>>> mergeJoining6<B, C, D, E, F>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth}) async =>
      _MergeConsumableAsyncJoining6<A, B, C, D, E, F>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Future<ConsumableAsync<Tuple6<A, B, C, D, E, F>>> mergeSyncJoining6<B, C, D, E, F>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<Consumable<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<Consumable<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<Consumable<F>> Function(Tuple5<A, B, C, D, E> previous) sixth}) async =>
      _MergeConsumableAsyncJoining6<A, B, C, D, E, F>(
        first: await this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
        fourth: (previous) async => (await fourth(previous)).toConsumableAsync(),
        fifth: (previous) async => (await fifth(previous)).toConsumableAsync(),
        sixth: (previous) async => (await sixth(previous)).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple7<A, B, C, D, E, F, G>>> merge7<B, C, D, E, F, G>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth,
          required FutureOr<ConsumableAsync<G>> Function() seventh}) async =>
      _MergeConsumableAsync7<A, B, C, D, E, F, G>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Future<ConsumableAsync<Tuple7<A, B, C, D, E, F, G>>> mergeSync7<B, C, D, E, F, G>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third,
          required FutureOr<Consumable<D>> Function() fourth,
          required FutureOr<Consumable<E>> Function() fifth,
          required FutureOr<Consumable<F>> Function() sixth,
          required FutureOr<Consumable<G>> Function() seventh}) async =>
      _MergeConsumableAsync7<A, B, C, D, E, F, G>(
        first: await this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
        fourth: () async => (await fourth()).toConsumableAsync(),
        fifth: () async => (await fifth()).toConsumableAsync(),
        sixth: () async => (await sixth()).toConsumableAsync(),
        seventh: () async => (await seventh()).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple7<A, B, C, D, E, F, G>>> mergeJoining7<B, C, D, E, F, G>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh}) async =>
      _MergeConsumableAsyncJoining7<A, B, C, D, E, F, G>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Future<ConsumableAsync<Tuple7<A, B, C, D, E, F, G>>> mergeSyncJoining7<B, C, D, E, F, G>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<Consumable<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<Consumable<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<Consumable<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<Consumable<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh}) async =>
      _MergeConsumableAsyncJoining7<A, B, C, D, E, F, G>(
        first: await this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
        fourth: (previous) async => (await fourth(previous)).toConsumableAsync(),
        fifth: (previous) async => (await fifth(previous)).toConsumableAsync(),
        sixth: (previous) async => (await sixth(previous)).toConsumableAsync(),
        seventh: (previous) async => (await seventh(previous)).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple8<A, B, C, D, E, F, G, H>>> merge8<B, C, D, E, F, G, H>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth,
          required FutureOr<ConsumableAsync<G>> Function() seventh,
          required FutureOr<ConsumableAsync<H>> Function() eighth}) async =>
      _MergeConsumableAsync8<A, B, C, D, E, F, G, H>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Future<ConsumableAsync<Tuple8<A, B, C, D, E, F, G, H>>> mergeSync8<B, C, D, E, F, G, H>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third,
          required FutureOr<Consumable<D>> Function() fourth,
          required FutureOr<Consumable<E>> Function() fifth,
          required FutureOr<Consumable<F>> Function() sixth,
          required FutureOr<Consumable<G>> Function() seventh,
          required FutureOr<Consumable<H>> Function() eighth}) async =>
      _MergeConsumableAsync8<A, B, C, D, E, F, G, H>(
        first: await this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
        fourth: () async => (await fourth()).toConsumableAsync(),
        fifth: () async => (await fifth()).toConsumableAsync(),
        sixth: () async => (await sixth()).toConsumableAsync(),
        seventh: () async => (await seventh()).toConsumableAsync(),
        eighth: () async => (await eighth()).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple8<A, B, C, D, E, F, G, H>>> mergeJoining8<B, C, D, E, F, G, H>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required FutureOr<ConsumableAsync<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth}) async =>
      _MergeConsumableAsyncJoining8<A, B, C, D, E, F, G, H>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Future<ConsumableAsync<Tuple8<A, B, C, D, E, F, G, H>>> mergeSyncJoining8<B, C, D, E, F, G, H>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<Consumable<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<Consumable<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<Consumable<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<Consumable<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required FutureOr<Consumable<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth}) async =>
      _MergeConsumableAsyncJoining8<A, B, C, D, E, F, G, H>(
        first: await this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
        fourth: (previous) async => (await fourth(previous)).toConsumableAsync(),
        fifth: (previous) async => (await fifth(previous)).toConsumableAsync(),
        sixth: (previous) async => (await sixth(previous)).toConsumableAsync(),
        seventh: (previous) async => (await seventh(previous)).toConsumableAsync(),
        eighth: (previous) async => (await eighth(previous)).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple9<A, B, C, D, E, F, G, H, I>>> merge9<B, C, D, E, F, G, H, I>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth,
          required FutureOr<ConsumableAsync<G>> Function() seventh,
          required FutureOr<ConsumableAsync<H>> Function() eighth,
          required FutureOr<ConsumableAsync<I>> Function() ninth}) async =>
      _MergeConsumableAsync9<A, B, C, D, E, F, G, H, I>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Future<ConsumableAsync<Tuple9<A, B, C, D, E, F, G, H, I>>> mergeSync9<B, C, D, E, F, G, H, I>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third,
          required FutureOr<Consumable<D>> Function() fourth,
          required FutureOr<Consumable<E>> Function() fifth,
          required FutureOr<Consumable<F>> Function() sixth,
          required FutureOr<Consumable<G>> Function() seventh,
          required FutureOr<Consumable<H>> Function() eighth,
          required FutureOr<Consumable<I>> Function() ninth}) async =>
      _MergeConsumableAsync9<A, B, C, D, E, F, G, H, I>(
        first: await this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
        fourth: () async => (await fourth()).toConsumableAsync(),
        fifth: () async => (await fifth()).toConsumableAsync(),
        sixth: () async => (await sixth()).toConsumableAsync(),
        seventh: () async => (await seventh()).toConsumableAsync(),
        eighth: () async => (await eighth()).toConsumableAsync(),
        ninth: () async => (await ninth()).toConsumableAsync(),
      );
  Future<ConsumableAsync<Tuple9<A, B, C, D, E, F, G, H, I>>> mergeJoining9<B, C, D, E, F, G, H, I>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required FutureOr<ConsumableAsync<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth,
          required FutureOr<ConsumableAsync<I>> Function(Tuple8<A, B, C, D, E, F, G, H> previous) ninth}) async =>
      _MergeConsumableAsyncJoining9<A, B, C, D, E, F, G, H, I>(
        first: await this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Future<ConsumableAsync<Tuple9<A, B, C, D, E, F, G, H, I>>> mergeSyncJoining9<B, C, D, E, F, G, H, I>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<Consumable<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<Consumable<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<Consumable<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<Consumable<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required FutureOr<Consumable<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth,
          required FutureOr<Consumable<I>> Function(Tuple8<A, B, C, D, E, F, G, H> previous) ninth}) async =>
      _MergeConsumableAsyncJoining9<A, B, C, D, E, F, G, H, I>(
        first: await this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
        fourth: (previous) async => (await fourth(previous)).toConsumableAsync(),
        fifth: (previous) async => (await fifth(previous)).toConsumableAsync(),
        sixth: (previous) async => (await sixth(previous)).toConsumableAsync(),
        seventh: (previous) async => (await seventh(previous)).toConsumableAsync(),
        eighth: (previous) async => (await eighth(previous)).toConsumableAsync(),
        ninth: (previous) async => (await ninth(previous)).toConsumableAsync(),
      );
}

extension MergeConsumableAsyncExtension<A> on ConsumableAsync<A> {
  ConsumableAsync<Tuple<A, B>> merge<B>({required FutureOr<ConsumableAsync<B>> Function() second}) =>
      _MergeConsumableAsync<A, B>(
        first: this,
        second: second,
      );
  ConsumableAsync<Tuple<A, B>> mergeSync<B>({required FutureOr<Consumable<B>> Function() second}) =>
      _MergeConsumableAsync<A, B>(
        first: this,
        second: () async => (await second()).toConsumableAsync(),
      );
  ConsumableAsync<Tuple<A, B>> mergeJoining<B>({required FutureOr<ConsumableAsync<B>> Function(A previous) second}) =>
      _MergeConsumableAsyncJoining<A, B>(
        first: this,
        second: second,
      );
  ConsumableAsync<Tuple<A, B>> mergeSyncJoining<B>({required FutureOr<Consumable<B>> Function(A previous) second}) =>
      _MergeConsumableAsyncJoining<A, B>(
        first: this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
      );
  ConsumableAsync<Tuple3<A, B, C>> merge3<B, C>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third}) =>
      _MergeConsumableAsync3<A, B, C>(
        first: this,
        second: second,
        third: third,
      );
  ConsumableAsync<Tuple3<A, B, C>> mergeSync3<B, C>(
          {required FutureOr<Consumable<B>> Function() second, required FutureOr<Consumable<C>> Function() third}) =>
      _MergeConsumableAsync3<A, B, C>(
        first: this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
      );
  ConsumableAsync<Tuple3<A, B, C>> mergeJoining3<B, C>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third}) =>
      _MergeConsumableAsyncJoining3<A, B, C>(
        first: this,
        second: second,
        third: third,
      );
  ConsumableAsync<Tuple3<A, B, C>> mergeSyncJoining3<B, C>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third}) =>
      _MergeConsumableAsyncJoining3<A, B, C>(
        first: this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
      );
  ConsumableAsync<Tuple4<A, B, C, D>> merge4<B, C, D>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth}) =>
      _MergeConsumableAsync4<A, B, C, D>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
      );
  ConsumableAsync<Tuple4<A, B, C, D>> mergeSync4<B, C, D>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third,
          required FutureOr<Consumable<D>> Function() fourth}) =>
      _MergeConsumableAsync4<A, B, C, D>(
        first: this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
        fourth: () async => (await fourth()).toConsumableAsync(),
      );
  ConsumableAsync<Tuple4<A, B, C, D>> mergeJoining4<B, C, D>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth}) =>
      _MergeConsumableAsyncJoining4<A, B, C, D>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
      );
  ConsumableAsync<Tuple4<A, B, C, D>> mergeSyncJoining4<B, C, D>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<Consumable<D>> Function(Tuple3<A, B, C> previous) fourth}) =>
      _MergeConsumableAsyncJoining4<A, B, C, D>(
        first: this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
        fourth: (previous) async => (await fourth(previous)).toConsumableAsync(),
      );
  ConsumableAsync<Tuple5<A, B, C, D, E>> merge5<B, C, D, E>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth}) =>
      _MergeConsumableAsync5<A, B, C, D, E>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  ConsumableAsync<Tuple5<A, B, C, D, E>> mergeSync5<B, C, D, E>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third,
          required FutureOr<Consumable<D>> Function() fourth,
          required FutureOr<Consumable<E>> Function() fifth}) =>
      _MergeConsumableAsync5<A, B, C, D, E>(
        first: this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
        fourth: () async => (await fourth()).toConsumableAsync(),
        fifth: () async => (await fifth()).toConsumableAsync(),
      );
  ConsumableAsync<Tuple5<A, B, C, D, E>> mergeJoining5<B, C, D, E>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth}) =>
      _MergeConsumableAsyncJoining5<A, B, C, D, E>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  ConsumableAsync<Tuple5<A, B, C, D, E>> mergeSyncJoining5<B, C, D, E>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<Consumable<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<Consumable<E>> Function(Tuple4<A, B, C, D> previous) fifth}) =>
      _MergeConsumableAsyncJoining5<A, B, C, D, E>(
        first: this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
        fourth: (previous) async => (await fourth(previous)).toConsumableAsync(),
        fifth: (previous) async => (await fifth(previous)).toConsumableAsync(),
      );
  ConsumableAsync<Tuple6<A, B, C, D, E, F>> merge6<B, C, D, E, F>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth}) =>
      _MergeConsumableAsync6<A, B, C, D, E, F>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  ConsumableAsync<Tuple6<A, B, C, D, E, F>> mergeSync6<B, C, D, E, F>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third,
          required FutureOr<Consumable<D>> Function() fourth,
          required FutureOr<Consumable<E>> Function() fifth,
          required FutureOr<Consumable<F>> Function() sixth}) =>
      _MergeConsumableAsync6<A, B, C, D, E, F>(
        first: this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
        fourth: () async => (await fourth()).toConsumableAsync(),
        fifth: () async => (await fifth()).toConsumableAsync(),
        sixth: () async => (await sixth()).toConsumableAsync(),
      );
  ConsumableAsync<Tuple6<A, B, C, D, E, F>> mergeJoining6<B, C, D, E, F>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth}) =>
      _MergeConsumableAsyncJoining6<A, B, C, D, E, F>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  ConsumableAsync<Tuple6<A, B, C, D, E, F>> mergeSyncJoining6<B, C, D, E, F>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<Consumable<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<Consumable<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<Consumable<F>> Function(Tuple5<A, B, C, D, E> previous) sixth}) =>
      _MergeConsumableAsyncJoining6<A, B, C, D, E, F>(
        first: this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
        fourth: (previous) async => (await fourth(previous)).toConsumableAsync(),
        fifth: (previous) async => (await fifth(previous)).toConsumableAsync(),
        sixth: (previous) async => (await sixth(previous)).toConsumableAsync(),
      );
  ConsumableAsync<Tuple7<A, B, C, D, E, F, G>> merge7<B, C, D, E, F, G>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth,
          required FutureOr<ConsumableAsync<G>> Function() seventh}) =>
      _MergeConsumableAsync7<A, B, C, D, E, F, G>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  ConsumableAsync<Tuple7<A, B, C, D, E, F, G>> mergeSync7<B, C, D, E, F, G>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third,
          required FutureOr<Consumable<D>> Function() fourth,
          required FutureOr<Consumable<E>> Function() fifth,
          required FutureOr<Consumable<F>> Function() sixth,
          required FutureOr<Consumable<G>> Function() seventh}) =>
      _MergeConsumableAsync7<A, B, C, D, E, F, G>(
        first: this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
        fourth: () async => (await fourth()).toConsumableAsync(),
        fifth: () async => (await fifth()).toConsumableAsync(),
        sixth: () async => (await sixth()).toConsumableAsync(),
        seventh: () async => (await seventh()).toConsumableAsync(),
      );
  ConsumableAsync<Tuple7<A, B, C, D, E, F, G>> mergeJoining7<B, C, D, E, F, G>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh}) =>
      _MergeConsumableAsyncJoining7<A, B, C, D, E, F, G>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  ConsumableAsync<Tuple7<A, B, C, D, E, F, G>> mergeSyncJoining7<B, C, D, E, F, G>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<Consumable<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<Consumable<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<Consumable<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<Consumable<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh}) =>
      _MergeConsumableAsyncJoining7<A, B, C, D, E, F, G>(
        first: this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
        fourth: (previous) async => (await fourth(previous)).toConsumableAsync(),
        fifth: (previous) async => (await fifth(previous)).toConsumableAsync(),
        sixth: (previous) async => (await sixth(previous)).toConsumableAsync(),
        seventh: (previous) async => (await seventh(previous)).toConsumableAsync(),
      );
  ConsumableAsync<Tuple8<A, B, C, D, E, F, G, H>> merge8<B, C, D, E, F, G, H>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth,
          required FutureOr<ConsumableAsync<G>> Function() seventh,
          required FutureOr<ConsumableAsync<H>> Function() eighth}) =>
      _MergeConsumableAsync8<A, B, C, D, E, F, G, H>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  ConsumableAsync<Tuple8<A, B, C, D, E, F, G, H>> mergeSync8<B, C, D, E, F, G, H>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third,
          required FutureOr<Consumable<D>> Function() fourth,
          required FutureOr<Consumable<E>> Function() fifth,
          required FutureOr<Consumable<F>> Function() sixth,
          required FutureOr<Consumable<G>> Function() seventh,
          required FutureOr<Consumable<H>> Function() eighth}) =>
      _MergeConsumableAsync8<A, B, C, D, E, F, G, H>(
        first: this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
        fourth: () async => (await fourth()).toConsumableAsync(),
        fifth: () async => (await fifth()).toConsumableAsync(),
        sixth: () async => (await sixth()).toConsumableAsync(),
        seventh: () async => (await seventh()).toConsumableAsync(),
        eighth: () async => (await eighth()).toConsumableAsync(),
      );
  ConsumableAsync<Tuple8<A, B, C, D, E, F, G, H>> mergeJoining8<B, C, D, E, F, G, H>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required FutureOr<ConsumableAsync<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth}) =>
      _MergeConsumableAsyncJoining8<A, B, C, D, E, F, G, H>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  ConsumableAsync<Tuple8<A, B, C, D, E, F, G, H>> mergeSyncJoining8<B, C, D, E, F, G, H>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<Consumable<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<Consumable<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<Consumable<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<Consumable<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required FutureOr<Consumable<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth}) =>
      _MergeConsumableAsyncJoining8<A, B, C, D, E, F, G, H>(
        first: this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
        fourth: (previous) async => (await fourth(previous)).toConsumableAsync(),
        fifth: (previous) async => (await fifth(previous)).toConsumableAsync(),
        sixth: (previous) async => (await sixth(previous)).toConsumableAsync(),
        seventh: (previous) async => (await seventh(previous)).toConsumableAsync(),
        eighth: (previous) async => (await eighth(previous)).toConsumableAsync(),
      );
  ConsumableAsync<Tuple9<A, B, C, D, E, F, G, H, I>> merge9<B, C, D, E, F, G, H, I>(
          {required FutureOr<ConsumableAsync<B>> Function() second,
          required FutureOr<ConsumableAsync<C>> Function() third,
          required FutureOr<ConsumableAsync<D>> Function() fourth,
          required FutureOr<ConsumableAsync<E>> Function() fifth,
          required FutureOr<ConsumableAsync<F>> Function() sixth,
          required FutureOr<ConsumableAsync<G>> Function() seventh,
          required FutureOr<ConsumableAsync<H>> Function() eighth,
          required FutureOr<ConsumableAsync<I>> Function() ninth}) =>
      _MergeConsumableAsync9<A, B, C, D, E, F, G, H, I>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  ConsumableAsync<Tuple9<A, B, C, D, E, F, G, H, I>> mergeSync9<B, C, D, E, F, G, H, I>(
          {required FutureOr<Consumable<B>> Function() second,
          required FutureOr<Consumable<C>> Function() third,
          required FutureOr<Consumable<D>> Function() fourth,
          required FutureOr<Consumable<E>> Function() fifth,
          required FutureOr<Consumable<F>> Function() sixth,
          required FutureOr<Consumable<G>> Function() seventh,
          required FutureOr<Consumable<H>> Function() eighth,
          required FutureOr<Consumable<I>> Function() ninth}) =>
      _MergeConsumableAsync9<A, B, C, D, E, F, G, H, I>(
        first: this,
        second: () async => (await second()).toConsumableAsync(),
        third: () async => (await third()).toConsumableAsync(),
        fourth: () async => (await fourth()).toConsumableAsync(),
        fifth: () async => (await fifth()).toConsumableAsync(),
        sixth: () async => (await sixth()).toConsumableAsync(),
        seventh: () async => (await seventh()).toConsumableAsync(),
        eighth: () async => (await eighth()).toConsumableAsync(),
        ninth: () async => (await ninth()).toConsumableAsync(),
      );
  ConsumableAsync<Tuple9<A, B, C, D, E, F, G, H, I>> mergeJoining9<B, C, D, E, F, G, H, I>(
          {required FutureOr<ConsumableAsync<B>> Function(A previous) second,
          required FutureOr<ConsumableAsync<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<ConsumableAsync<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<ConsumableAsync<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<ConsumableAsync<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<ConsumableAsync<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required FutureOr<ConsumableAsync<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth,
          required FutureOr<ConsumableAsync<I>> Function(Tuple8<A, B, C, D, E, F, G, H> previous) ninth}) =>
      _MergeConsumableAsyncJoining9<A, B, C, D, E, F, G, H, I>(
        first: this,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  ConsumableAsync<Tuple9<A, B, C, D, E, F, G, H, I>> mergeSyncJoining9<B, C, D, E, F, G, H, I>(
          {required FutureOr<Consumable<B>> Function(A previous) second,
          required FutureOr<Consumable<C>> Function(Tuple<A, B> previous) third,
          required FutureOr<Consumable<D>> Function(Tuple3<A, B, C> previous) fourth,
          required FutureOr<Consumable<E>> Function(Tuple4<A, B, C, D> previous) fifth,
          required FutureOr<Consumable<F>> Function(Tuple5<A, B, C, D, E> previous) sixth,
          required FutureOr<Consumable<G>> Function(Tuple6<A, B, C, D, E, F> previous) seventh,
          required FutureOr<Consumable<H>> Function(Tuple7<A, B, C, D, E, F, G> previous) eighth,
          required FutureOr<Consumable<I>> Function(Tuple8<A, B, C, D, E, F, G, H> previous) ninth}) =>
      _MergeConsumableAsyncJoining9<A, B, C, D, E, F, G, H, I>(
        first: this,
        second: (previous) async => (await second(previous)).toConsumableAsync(),
        third: (previous) async => (await third(previous)).toConsumableAsync(),
        fourth: (previous) async => (await fourth(previous)).toConsumableAsync(),
        fifth: (previous) async => (await fifth(previous)).toConsumableAsync(),
        sixth: (previous) async => (await sixth(previous)).toConsumableAsync(),
        seventh: (previous) async => (await seventh(previous)).toConsumableAsync(),
        eighth: (previous) async => (await eighth(previous)).toConsumableAsync(),
        ninth: (previous) async => (await ninth(previous)).toConsumableAsync(),
      );
}
