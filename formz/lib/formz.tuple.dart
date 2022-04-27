// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:equatable/equatable.dart';

// **************************************************************************
// TupleGenerator
// **************************************************************************

import 'annotation.dart';

class Tuple<A, B> extends Equatable {
  const Tuple({required this.first, required this.second});

  final A first;

  final B second;

  @override
  List<Object?> get props => [first, second];
  Tuple<A, B> copyWith({SupplyFunc<A>? first, SupplyFunc<B>? second}) => Tuple<A, B>(
        first: first == null ? this.first : first(),
        second: second == null ? this.second : second(),
      );
  Tuple<T, B> mapFirst<T>(T Function(A value) mapper) => Tuple<T, B>(
        first: mapper(first),
        second: second,
      );
  Tuple<A, T> mapSecond<T>(T Function(B value) mapper) => Tuple<A, T>(
        first: first,
        second: mapper(second),
      );
  Future<Tuple<T, B>> mapFirstAsync<T>(Future<T> Function(A value) mapper) async => Tuple<T, B>(
        first: await mapper(first),
        second: second,
      );
  Future<Tuple<A, T>> mapSecondAsync<T>(Future<T> Function(B value) mapper) async => Tuple<A, T>(
        first: first,
        second: await mapper(second),
      );
}

class Tuple3<A, B, C> extends Equatable {
  const Tuple3({required this.first, required this.second, required this.third});

  final A first;

  final B second;

  final C third;

  @override
  List<Object?> get props => [first, second, third];
  Tuple3<A, B, C> copyWith({SupplyFunc<A>? first, SupplyFunc<B>? second, SupplyFunc<C>? third}) => Tuple3<A, B, C>(
        first: first == null ? this.first : first(),
        second: second == null ? this.second : second(),
        third: third == null ? this.third : third(),
      );
  Tuple3<T, B, C> mapFirst<T>(T Function(A value) mapper) => Tuple3<T, B, C>(
        first: mapper(first),
        second: second,
        third: third,
      );
  Tuple3<A, T, C> mapSecond<T>(T Function(B value) mapper) => Tuple3<A, T, C>(
        first: first,
        second: mapper(second),
        third: third,
      );
  Tuple3<A, B, T> mapThird<T>(T Function(C value) mapper) => Tuple3<A, B, T>(
        first: first,
        second: second,
        third: mapper(third),
      );
  Future<Tuple3<T, B, C>> mapFirstAsync<T>(Future<T> Function(A value) mapper) async => Tuple3<T, B, C>(
        first: await mapper(first),
        second: second,
        third: third,
      );
  Future<Tuple3<A, T, C>> mapSecondAsync<T>(Future<T> Function(B value) mapper) async => Tuple3<A, T, C>(
        first: first,
        second: await mapper(second),
        third: third,
      );
  Future<Tuple3<A, B, T>> mapThirdAsync<T>(Future<T> Function(C value) mapper) async => Tuple3<A, B, T>(
        first: first,
        second: second,
        third: await mapper(third),
      );
}

class Tuple4<A, B, C, D> extends Equatable {
  const Tuple4({required this.first, required this.second, required this.third, required this.fourth});

  final A first;

  final B second;

  final C third;

  final D fourth;

  @override
  List<Object?> get props => [first, second, third, fourth];
  Tuple4<A, B, C, D> copyWith(
          {SupplyFunc<A>? first, SupplyFunc<B>? second, SupplyFunc<C>? third, SupplyFunc<D>? fourth}) =>
      Tuple4<A, B, C, D>(
        first: first == null ? this.first : first(),
        second: second == null ? this.second : second(),
        third: third == null ? this.third : third(),
        fourth: fourth == null ? this.fourth : fourth(),
      );
  Tuple4<T, B, C, D> mapFirst<T>(T Function(A value) mapper) => Tuple4<T, B, C, D>(
        first: mapper(first),
        second: second,
        third: third,
        fourth: fourth,
      );
  Tuple4<A, T, C, D> mapSecond<T>(T Function(B value) mapper) => Tuple4<A, T, C, D>(
        first: first,
        second: mapper(second),
        third: third,
        fourth: fourth,
      );
  Tuple4<A, B, T, D> mapThird<T>(T Function(C value) mapper) => Tuple4<A, B, T, D>(
        first: first,
        second: second,
        third: mapper(third),
        fourth: fourth,
      );
  Tuple4<A, B, C, T> mapFourth<T>(T Function(D value) mapper) => Tuple4<A, B, C, T>(
        first: first,
        second: second,
        third: third,
        fourth: mapper(fourth),
      );
  Future<Tuple4<T, B, C, D>> mapFirstAsync<T>(Future<T> Function(A value) mapper) async => Tuple4<T, B, C, D>(
        first: await mapper(first),
        second: second,
        third: third,
        fourth: fourth,
      );
  Future<Tuple4<A, T, C, D>> mapSecondAsync<T>(Future<T> Function(B value) mapper) async => Tuple4<A, T, C, D>(
        first: first,
        second: await mapper(second),
        third: third,
        fourth: fourth,
      );
  Future<Tuple4<A, B, T, D>> mapThirdAsync<T>(Future<T> Function(C value) mapper) async => Tuple4<A, B, T, D>(
        first: first,
        second: second,
        third: await mapper(third),
        fourth: fourth,
      );
  Future<Tuple4<A, B, C, T>> mapFourthAsync<T>(Future<T> Function(D value) mapper) async => Tuple4<A, B, C, T>(
        first: first,
        second: second,
        third: third,
        fourth: await mapper(fourth),
      );
}

class Tuple5<A, B, C, D, E> extends Equatable {
  const Tuple5(
      {required this.first, required this.second, required this.third, required this.fourth, required this.fifth});

  final A first;

  final B second;

  final C third;

  final D fourth;

  final E fifth;

  @override
  List<Object?> get props => [first, second, third, fourth, fifth];
  Tuple5<A, B, C, D, E> copyWith(
          {SupplyFunc<A>? first,
          SupplyFunc<B>? second,
          SupplyFunc<C>? third,
          SupplyFunc<D>? fourth,
          SupplyFunc<E>? fifth}) =>
      Tuple5<A, B, C, D, E>(
        first: first == null ? this.first : first(),
        second: second == null ? this.second : second(),
        third: third == null ? this.third : third(),
        fourth: fourth == null ? this.fourth : fourth(),
        fifth: fifth == null ? this.fifth : fifth(),
      );
  Tuple5<T, B, C, D, E> mapFirst<T>(T Function(A value) mapper) => Tuple5<T, B, C, D, E>(
        first: mapper(first),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  Tuple5<A, T, C, D, E> mapSecond<T>(T Function(B value) mapper) => Tuple5<A, T, C, D, E>(
        first: first,
        second: mapper(second),
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  Tuple5<A, B, T, D, E> mapThird<T>(T Function(C value) mapper) => Tuple5<A, B, T, D, E>(
        first: first,
        second: second,
        third: mapper(third),
        fourth: fourth,
        fifth: fifth,
      );
  Tuple5<A, B, C, T, E> mapFourth<T>(T Function(D value) mapper) => Tuple5<A, B, C, T, E>(
        first: first,
        second: second,
        third: third,
        fourth: mapper(fourth),
        fifth: fifth,
      );
  Tuple5<A, B, C, D, T> mapFifth<T>(T Function(E value) mapper) => Tuple5<A, B, C, D, T>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: mapper(fifth),
      );
  Future<Tuple5<T, B, C, D, E>> mapFirstAsync<T>(Future<T> Function(A value) mapper) async => Tuple5<T, B, C, D, E>(
        first: await mapper(first),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  Future<Tuple5<A, T, C, D, E>> mapSecondAsync<T>(Future<T> Function(B value) mapper) async => Tuple5<A, T, C, D, E>(
        first: first,
        second: await mapper(second),
        third: third,
        fourth: fourth,
        fifth: fifth,
      );
  Future<Tuple5<A, B, T, D, E>> mapThirdAsync<T>(Future<T> Function(C value) mapper) async => Tuple5<A, B, T, D, E>(
        first: first,
        second: second,
        third: await mapper(third),
        fourth: fourth,
        fifth: fifth,
      );
  Future<Tuple5<A, B, C, T, E>> mapFourthAsync<T>(Future<T> Function(D value) mapper) async => Tuple5<A, B, C, T, E>(
        first: first,
        second: second,
        third: third,
        fourth: await mapper(fourth),
        fifth: fifth,
      );
  Future<Tuple5<A, B, C, D, T>> mapFifthAsync<T>(Future<T> Function(E value) mapper) async => Tuple5<A, B, C, D, T>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: await mapper(fifth),
      );
}

class Tuple6<A, B, C, D, E, F> extends Equatable {
  const Tuple6(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth});

  final A first;

  final B second;

  final C third;

  final D fourth;

  final E fifth;

  final F sixth;

  @override
  List<Object?> get props => [first, second, third, fourth, fifth, sixth];
  Tuple6<A, B, C, D, E, F> copyWith(
          {SupplyFunc<A>? first,
          SupplyFunc<B>? second,
          SupplyFunc<C>? third,
          SupplyFunc<D>? fourth,
          SupplyFunc<E>? fifth,
          SupplyFunc<F>? sixth}) =>
      Tuple6<A, B, C, D, E, F>(
        first: first == null ? this.first : first(),
        second: second == null ? this.second : second(),
        third: third == null ? this.third : third(),
        fourth: fourth == null ? this.fourth : fourth(),
        fifth: fifth == null ? this.fifth : fifth(),
        sixth: sixth == null ? this.sixth : sixth(),
      );
  Tuple6<T, B, C, D, E, F> mapFirst<T>(T Function(A value) mapper) => Tuple6<T, B, C, D, E, F>(
        first: mapper(first),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Tuple6<A, T, C, D, E, F> mapSecond<T>(T Function(B value) mapper) => Tuple6<A, T, C, D, E, F>(
        first: first,
        second: mapper(second),
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Tuple6<A, B, T, D, E, F> mapThird<T>(T Function(C value) mapper) => Tuple6<A, B, T, D, E, F>(
        first: first,
        second: second,
        third: mapper(third),
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Tuple6<A, B, C, T, E, F> mapFourth<T>(T Function(D value) mapper) => Tuple6<A, B, C, T, E, F>(
        first: first,
        second: second,
        third: third,
        fourth: mapper(fourth),
        fifth: fifth,
        sixth: sixth,
      );
  Tuple6<A, B, C, D, T, F> mapFifth<T>(T Function(E value) mapper) => Tuple6<A, B, C, D, T, F>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: mapper(fifth),
        sixth: sixth,
      );
  Tuple6<A, B, C, D, E, T> mapSixth<T>(T Function(F value) mapper) => Tuple6<A, B, C, D, E, T>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: mapper(sixth),
      );
  Future<Tuple6<T, B, C, D, E, F>> mapFirstAsync<T>(Future<T> Function(A value) mapper) async =>
      Tuple6<T, B, C, D, E, F>(
        first: await mapper(first),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Future<Tuple6<A, T, C, D, E, F>> mapSecondAsync<T>(Future<T> Function(B value) mapper) async =>
      Tuple6<A, T, C, D, E, F>(
        first: first,
        second: await mapper(second),
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Future<Tuple6<A, B, T, D, E, F>> mapThirdAsync<T>(Future<T> Function(C value) mapper) async =>
      Tuple6<A, B, T, D, E, F>(
        first: first,
        second: second,
        third: await mapper(third),
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
      );
  Future<Tuple6<A, B, C, T, E, F>> mapFourthAsync<T>(Future<T> Function(D value) mapper) async =>
      Tuple6<A, B, C, T, E, F>(
        first: first,
        second: second,
        third: third,
        fourth: await mapper(fourth),
        fifth: fifth,
        sixth: sixth,
      );
  Future<Tuple6<A, B, C, D, T, F>> mapFifthAsync<T>(Future<T> Function(E value) mapper) async =>
      Tuple6<A, B, C, D, T, F>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: await mapper(fifth),
        sixth: sixth,
      );
  Future<Tuple6<A, B, C, D, E, T>> mapSixthAsync<T>(Future<T> Function(F value) mapper) async =>
      Tuple6<A, B, C, D, E, T>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: await mapper(sixth),
      );
}

class Tuple7<A, B, C, D, E, F, G> extends Equatable {
  const Tuple7(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh});

  final A first;

  final B second;

  final C third;

  final D fourth;

  final E fifth;

  final F sixth;

  final G seventh;

  @override
  List<Object?> get props => [first, second, third, fourth, fifth, sixth, seventh];
  Tuple7<A, B, C, D, E, F, G> copyWith(
          {SupplyFunc<A>? first,
          SupplyFunc<B>? second,
          SupplyFunc<C>? third,
          SupplyFunc<D>? fourth,
          SupplyFunc<E>? fifth,
          SupplyFunc<F>? sixth,
          SupplyFunc<G>? seventh}) =>
      Tuple7<A, B, C, D, E, F, G>(
        first: first == null ? this.first : first(),
        second: second == null ? this.second : second(),
        third: third == null ? this.third : third(),
        fourth: fourth == null ? this.fourth : fourth(),
        fifth: fifth == null ? this.fifth : fifth(),
        sixth: sixth == null ? this.sixth : sixth(),
        seventh: seventh == null ? this.seventh : seventh(),
      );
  Tuple7<T, B, C, D, E, F, G> mapFirst<T>(T Function(A value) mapper) => Tuple7<T, B, C, D, E, F, G>(
        first: mapper(first),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Tuple7<A, T, C, D, E, F, G> mapSecond<T>(T Function(B value) mapper) => Tuple7<A, T, C, D, E, F, G>(
        first: first,
        second: mapper(second),
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Tuple7<A, B, T, D, E, F, G> mapThird<T>(T Function(C value) mapper) => Tuple7<A, B, T, D, E, F, G>(
        first: first,
        second: second,
        third: mapper(third),
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Tuple7<A, B, C, T, E, F, G> mapFourth<T>(T Function(D value) mapper) => Tuple7<A, B, C, T, E, F, G>(
        first: first,
        second: second,
        third: third,
        fourth: mapper(fourth),
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Tuple7<A, B, C, D, T, F, G> mapFifth<T>(T Function(E value) mapper) => Tuple7<A, B, C, D, T, F, G>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: mapper(fifth),
        sixth: sixth,
        seventh: seventh,
      );
  Tuple7<A, B, C, D, E, T, G> mapSixth<T>(T Function(F value) mapper) => Tuple7<A, B, C, D, E, T, G>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: mapper(sixth),
        seventh: seventh,
      );
  Tuple7<A, B, C, D, E, F, T> mapSeventh<T>(T Function(G value) mapper) => Tuple7<A, B, C, D, E, F, T>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: mapper(seventh),
      );
  Future<Tuple7<T, B, C, D, E, F, G>> mapFirstAsync<T>(Future<T> Function(A value) mapper) async =>
      Tuple7<T, B, C, D, E, F, G>(
        first: await mapper(first),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Future<Tuple7<A, T, C, D, E, F, G>> mapSecondAsync<T>(Future<T> Function(B value) mapper) async =>
      Tuple7<A, T, C, D, E, F, G>(
        first: first,
        second: await mapper(second),
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Future<Tuple7<A, B, T, D, E, F, G>> mapThirdAsync<T>(Future<T> Function(C value) mapper) async =>
      Tuple7<A, B, T, D, E, F, G>(
        first: first,
        second: second,
        third: await mapper(third),
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Future<Tuple7<A, B, C, T, E, F, G>> mapFourthAsync<T>(Future<T> Function(D value) mapper) async =>
      Tuple7<A, B, C, T, E, F, G>(
        first: first,
        second: second,
        third: third,
        fourth: await mapper(fourth),
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
      );
  Future<Tuple7<A, B, C, D, T, F, G>> mapFifthAsync<T>(Future<T> Function(E value) mapper) async =>
      Tuple7<A, B, C, D, T, F, G>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: await mapper(fifth),
        sixth: sixth,
        seventh: seventh,
      );
  Future<Tuple7<A, B, C, D, E, T, G>> mapSixthAsync<T>(Future<T> Function(F value) mapper) async =>
      Tuple7<A, B, C, D, E, T, G>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: await mapper(sixth),
        seventh: seventh,
      );
  Future<Tuple7<A, B, C, D, E, F, T>> mapSeventhAsync<T>(Future<T> Function(G value) mapper) async =>
      Tuple7<A, B, C, D, E, F, T>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: await mapper(seventh),
      );
}

class Tuple8<A, B, C, D, E, F, G, H> extends Equatable {
  const Tuple8(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh,
      required this.eighth});

  final A first;

  final B second;

  final C third;

  final D fourth;

  final E fifth;

  final F sixth;

  final G seventh;

  final H eighth;

  @override
  List<Object?> get props => [first, second, third, fourth, fifth, sixth, seventh, eighth];
  Tuple8<A, B, C, D, E, F, G, H> copyWith(
          {SupplyFunc<A>? first,
          SupplyFunc<B>? second,
          SupplyFunc<C>? third,
          SupplyFunc<D>? fourth,
          SupplyFunc<E>? fifth,
          SupplyFunc<F>? sixth,
          SupplyFunc<G>? seventh,
          SupplyFunc<H>? eighth}) =>
      Tuple8<A, B, C, D, E, F, G, H>(
        first: first == null ? this.first : first(),
        second: second == null ? this.second : second(),
        third: third == null ? this.third : third(),
        fourth: fourth == null ? this.fourth : fourth(),
        fifth: fifth == null ? this.fifth : fifth(),
        sixth: sixth == null ? this.sixth : sixth(),
        seventh: seventh == null ? this.seventh : seventh(),
        eighth: eighth == null ? this.eighth : eighth(),
      );
  Tuple8<T, B, C, D, E, F, G, H> mapFirst<T>(T Function(A value) mapper) => Tuple8<T, B, C, D, E, F, G, H>(
        first: mapper(first),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Tuple8<A, T, C, D, E, F, G, H> mapSecond<T>(T Function(B value) mapper) => Tuple8<A, T, C, D, E, F, G, H>(
        first: first,
        second: mapper(second),
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Tuple8<A, B, T, D, E, F, G, H> mapThird<T>(T Function(C value) mapper) => Tuple8<A, B, T, D, E, F, G, H>(
        first: first,
        second: second,
        third: mapper(third),
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Tuple8<A, B, C, T, E, F, G, H> mapFourth<T>(T Function(D value) mapper) => Tuple8<A, B, C, T, E, F, G, H>(
        first: first,
        second: second,
        third: third,
        fourth: mapper(fourth),
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Tuple8<A, B, C, D, T, F, G, H> mapFifth<T>(T Function(E value) mapper) => Tuple8<A, B, C, D, T, F, G, H>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: mapper(fifth),
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Tuple8<A, B, C, D, E, T, G, H> mapSixth<T>(T Function(F value) mapper) => Tuple8<A, B, C, D, E, T, G, H>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: mapper(sixth),
        seventh: seventh,
        eighth: eighth,
      );
  Tuple8<A, B, C, D, E, F, T, H> mapSeventh<T>(T Function(G value) mapper) => Tuple8<A, B, C, D, E, F, T, H>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: mapper(seventh),
        eighth: eighth,
      );
  Tuple8<A, B, C, D, E, F, G, T> mapEighth<T>(T Function(H value) mapper) => Tuple8<A, B, C, D, E, F, G, T>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: mapper(eighth),
      );
  Future<Tuple8<T, B, C, D, E, F, G, H>> mapFirstAsync<T>(Future<T> Function(A value) mapper) async =>
      Tuple8<T, B, C, D, E, F, G, H>(
        first: await mapper(first),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Future<Tuple8<A, T, C, D, E, F, G, H>> mapSecondAsync<T>(Future<T> Function(B value) mapper) async =>
      Tuple8<A, T, C, D, E, F, G, H>(
        first: first,
        second: await mapper(second),
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Future<Tuple8<A, B, T, D, E, F, G, H>> mapThirdAsync<T>(Future<T> Function(C value) mapper) async =>
      Tuple8<A, B, T, D, E, F, G, H>(
        first: first,
        second: second,
        third: await mapper(third),
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Future<Tuple8<A, B, C, T, E, F, G, H>> mapFourthAsync<T>(Future<T> Function(D value) mapper) async =>
      Tuple8<A, B, C, T, E, F, G, H>(
        first: first,
        second: second,
        third: third,
        fourth: await mapper(fourth),
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Future<Tuple8<A, B, C, D, T, F, G, H>> mapFifthAsync<T>(Future<T> Function(E value) mapper) async =>
      Tuple8<A, B, C, D, T, F, G, H>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: await mapper(fifth),
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
      );
  Future<Tuple8<A, B, C, D, E, T, G, H>> mapSixthAsync<T>(Future<T> Function(F value) mapper) async =>
      Tuple8<A, B, C, D, E, T, G, H>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: await mapper(sixth),
        seventh: seventh,
        eighth: eighth,
      );
  Future<Tuple8<A, B, C, D, E, F, T, H>> mapSeventhAsync<T>(Future<T> Function(G value) mapper) async =>
      Tuple8<A, B, C, D, E, F, T, H>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: await mapper(seventh),
        eighth: eighth,
      );
  Future<Tuple8<A, B, C, D, E, F, G, T>> mapEighthAsync<T>(Future<T> Function(H value) mapper) async =>
      Tuple8<A, B, C, D, E, F, G, T>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: await mapper(eighth),
      );
}

class Tuple9<A, B, C, D, E, F, G, H, I> extends Equatable {
  const Tuple9(
      {required this.first,
      required this.second,
      required this.third,
      required this.fourth,
      required this.fifth,
      required this.sixth,
      required this.seventh,
      required this.eighth,
      required this.ninth});

  final A first;

  final B second;

  final C third;

  final D fourth;

  final E fifth;

  final F sixth;

  final G seventh;

  final H eighth;

  final I ninth;

  @override
  List<Object?> get props => [first, second, third, fourth, fifth, sixth, seventh, eighth, ninth];
  Tuple9<A, B, C, D, E, F, G, H, I> copyWith(
          {SupplyFunc<A>? first,
          SupplyFunc<B>? second,
          SupplyFunc<C>? third,
          SupplyFunc<D>? fourth,
          SupplyFunc<E>? fifth,
          SupplyFunc<F>? sixth,
          SupplyFunc<G>? seventh,
          SupplyFunc<H>? eighth,
          SupplyFunc<I>? ninth}) =>
      Tuple9<A, B, C, D, E, F, G, H, I>(
        first: first == null ? this.first : first(),
        second: second == null ? this.second : second(),
        third: third == null ? this.third : third(),
        fourth: fourth == null ? this.fourth : fourth(),
        fifth: fifth == null ? this.fifth : fifth(),
        sixth: sixth == null ? this.sixth : sixth(),
        seventh: seventh == null ? this.seventh : seventh(),
        eighth: eighth == null ? this.eighth : eighth(),
        ninth: ninth == null ? this.ninth : ninth(),
      );
  Tuple9<T, B, C, D, E, F, G, H, I> mapFirst<T>(T Function(A value) mapper) => Tuple9<T, B, C, D, E, F, G, H, I>(
        first: mapper(first),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Tuple9<A, T, C, D, E, F, G, H, I> mapSecond<T>(T Function(B value) mapper) => Tuple9<A, T, C, D, E, F, G, H, I>(
        first: first,
        second: mapper(second),
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Tuple9<A, B, T, D, E, F, G, H, I> mapThird<T>(T Function(C value) mapper) => Tuple9<A, B, T, D, E, F, G, H, I>(
        first: first,
        second: second,
        third: mapper(third),
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Tuple9<A, B, C, T, E, F, G, H, I> mapFourth<T>(T Function(D value) mapper) => Tuple9<A, B, C, T, E, F, G, H, I>(
        first: first,
        second: second,
        third: third,
        fourth: mapper(fourth),
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Tuple9<A, B, C, D, T, F, G, H, I> mapFifth<T>(T Function(E value) mapper) => Tuple9<A, B, C, D, T, F, G, H, I>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: mapper(fifth),
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Tuple9<A, B, C, D, E, T, G, H, I> mapSixth<T>(T Function(F value) mapper) => Tuple9<A, B, C, D, E, T, G, H, I>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: mapper(sixth),
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Tuple9<A, B, C, D, E, F, T, H, I> mapSeventh<T>(T Function(G value) mapper) => Tuple9<A, B, C, D, E, F, T, H, I>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: mapper(seventh),
        eighth: eighth,
        ninth: ninth,
      );
  Tuple9<A, B, C, D, E, F, G, T, I> mapEighth<T>(T Function(H value) mapper) => Tuple9<A, B, C, D, E, F, G, T, I>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: mapper(eighth),
        ninth: ninth,
      );
  Tuple9<A, B, C, D, E, F, G, H, T> mapNinth<T>(T Function(I value) mapper) => Tuple9<A, B, C, D, E, F, G, H, T>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: mapper(ninth),
      );
  Future<Tuple9<T, B, C, D, E, F, G, H, I>> mapFirstAsync<T>(Future<T> Function(A value) mapper) async =>
      Tuple9<T, B, C, D, E, F, G, H, I>(
        first: await mapper(first),
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Future<Tuple9<A, T, C, D, E, F, G, H, I>> mapSecondAsync<T>(Future<T> Function(B value) mapper) async =>
      Tuple9<A, T, C, D, E, F, G, H, I>(
        first: first,
        second: await mapper(second),
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Future<Tuple9<A, B, T, D, E, F, G, H, I>> mapThirdAsync<T>(Future<T> Function(C value) mapper) async =>
      Tuple9<A, B, T, D, E, F, G, H, I>(
        first: first,
        second: second,
        third: await mapper(third),
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Future<Tuple9<A, B, C, T, E, F, G, H, I>> mapFourthAsync<T>(Future<T> Function(D value) mapper) async =>
      Tuple9<A, B, C, T, E, F, G, H, I>(
        first: first,
        second: second,
        third: third,
        fourth: await mapper(fourth),
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Future<Tuple9<A, B, C, D, T, F, G, H, I>> mapFifthAsync<T>(Future<T> Function(E value) mapper) async =>
      Tuple9<A, B, C, D, T, F, G, H, I>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: await mapper(fifth),
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Future<Tuple9<A, B, C, D, E, T, G, H, I>> mapSixthAsync<T>(Future<T> Function(F value) mapper) async =>
      Tuple9<A, B, C, D, E, T, G, H, I>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: await mapper(sixth),
        seventh: seventh,
        eighth: eighth,
        ninth: ninth,
      );
  Future<Tuple9<A, B, C, D, E, F, T, H, I>> mapSeventhAsync<T>(Future<T> Function(G value) mapper) async =>
      Tuple9<A, B, C, D, E, F, T, H, I>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: await mapper(seventh),
        eighth: eighth,
        ninth: ninth,
      );
  Future<Tuple9<A, B, C, D, E, F, G, T, I>> mapEighthAsync<T>(Future<T> Function(H value) mapper) async =>
      Tuple9<A, B, C, D, E, F, G, T, I>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: await mapper(eighth),
        ninth: ninth,
      );
  Future<Tuple9<A, B, C, D, E, F, G, H, T>> mapNinthAsync<T>(Future<T> Function(I value) mapper) async =>
      Tuple9<A, B, C, D, E, F, G, H, T>(
        first: first,
        second: second,
        third: third,
        fourth: fourth,
        fifth: fifth,
        sixth: sixth,
        seventh: seventh,
        eighth: eighth,
        ninth: await mapper(ninth),
      );
}
