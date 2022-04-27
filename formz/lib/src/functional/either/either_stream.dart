import 'dart:async';

import 'package:meta/meta.dart';

import 'either.dart';

abstract class EitherStream<T extends Either> implements Stream<T>, Future<T> {
  const EitherStream();

  @protected
  Stream<T> get stream;

  @protected
  Future<T> get toFuture;

  @Deprecated('Use streamTimeout or futureTimeout instead')
  EitherStream<T> timeout(Duration duration, {Function? onTimeout}) => throw UnimplementedError();

  Stream<T> streamTimeout(Duration timeLimit, {void onTimeout(EventSink<T> sink)?}) =>
      stream.timeout(timeLimit, onTimeout: onTimeout);

  Future<T> futureTimeout(Duration timeLimit, {FutureOr<T> onTimeout()?}) =>
      toFuture.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<bool> any(bool test(T element)) => stream.any(test);

  @override
  Stream<T> asBroadcastStream({
    void onListen(StreamSubscription<T> subscription)?,
    void onCancel(StreamSubscription<T> subscription)?,
  }) =>
      stream.asBroadcastStream(onListen: onListen, onCancel: onCancel);

  @override
  Stream<T> asStream() => this;

  @override
  Stream<E> asyncExpand<E>(Stream<E>? convert(T event)) => stream.asyncExpand<E>(convert);

  @override
  Stream<E> asyncMap<E>(FutureOr<E> convert(T event)) => stream.asyncMap<E>(convert);

  @override
  Stream<R> cast<R>() => stream.cast<R>();

  @override
  Future<T> catchError(Function onError, {bool test(Object error)?}) => toFuture.catchError(onError, test: test);

  @override
  Future<bool> contains(Object? needle) => stream.contains(needle);

  @override
  Stream<T> distinct([bool equals(T previous, T next)?]) => stream.distinct(equals);

  @override
  Future<E> drain<E>([E? futureValue]) => stream.drain(futureValue);

  @override
  Future<T> elementAt(int index) => stream.elementAt(index);

  @override
  Future<bool> every(bool test(T element)) => stream.every(test);

  @override
  Stream<S> expand<S>(Iterable<S> convert(T element)) => stream.expand(convert);

  @override
  Future<T> get first => stream.first;

  @override
  Future<T> firstWhere(bool test(T element), {T orElse()?}) => stream.firstWhere(test, orElse: orElse);

  @override
  Future<S> fold<S>(S initialValue, S combine(S previous, T element)) => stream.fold(initialValue, combine);

  @override
  Future forEach(void action(T element)) => stream.forEach(action);

  @override
  Stream<T> handleError(Function onError, {bool test(dynamic error)?}) => stream.handleError(onError, test: test);

  @override
  bool get isBroadcast => stream.isBroadcast;

  @override
  Future<bool> get isEmpty => stream.isEmpty;

  @override
  Future<String> join([String separator = '']) => stream.join(separator);

  @override
  Future<T> get last => stream.last;

  @override
  Future<T> lastWhere(bool test(T element), {T orElse()?}) => stream.lastWhere(test, orElse: orElse);

  @override
  Future<int> get length => stream.length;

  @override
  StreamSubscription<T> listen(
    void onData(T event)?, {
    Function? onError,
    void onDone()?,
    bool? cancelOnError,
  }) =>
      stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);

  @override
  Stream<S> map<S>(S convert(T event)) => stream.map(convert);

  @override
  Future pipe(StreamConsumer<T> streamConsumer) => stream.pipe(streamConsumer);

  @override
  Future<T> reduce(T combine(T previous, T element)) => stream.reduce(combine);

  @override
  Future<T> get single => stream.single;

  @override
  Future<T> singleWhere(bool test(T element), {T orElse()?}) => stream.singleWhere(test, orElse: orElse);

  @override
  Stream<T> skip(int count) => stream.skip(count);

  @override
  Stream<T> skipWhile(bool test(T element)) => stream.skipWhile(test);

  @override
  Stream<T> take(int count) => stream.take(count);

  @override
  Stream<T> takeWhile(bool test(T element)) => stream.takeWhile(test);

  @override
  Future<S> then<S>(FutureOr<S> onValue(T value), {Function? onError}) => toFuture.then(onValue, onError: onError);

  @override
  Future<List<T>> toList() => stream.toList();

  @override
  Future<Set<T>> toSet() => stream.toSet();

  @override
  Stream<S> transform<S>(StreamTransformer<T, S> streamTransformer) => stream.transform(streamTransformer);

  @override
  Future<T> whenComplete(FutureOr<void> action()) => toFuture.whenComplete(action);

  @override
  Stream<T> where(bool test(T event)) => stream.where(test);
}
