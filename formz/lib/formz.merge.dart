// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// MergeGenerator
// **************************************************************************

import 'formz.tuple.dart';
import 'src/functional/either/either.dart';

Either<T, Tuple<A, B>> mergeRight<T, A, B>(
    {required Either<T, A> Function() first, required Either<T, B> Function() second}) {
  return first().consume(
    onRight: (firstValue) => second().consume(
      onRight: (secondValue) => Either.right(Tuple<A, B>(
        first: firstValue,
        second: secondValue,
      )),
      onLeft: (value) => Either.left(value),
    ),
    onLeft: (value) => Either.left(value),
  );
}

Either<Tuple<A, B>, T> mergeLeft<T, A, B>(
    {required Either<A, T> Function() first, required Either<B, T> Function() second}) {
  return first().consume(
    onRight: (value) => Either.right(value),
    onLeft: (firstValue) => second().consume(
      onRight: (value) => Either.right(value),
      onLeft: (secondValue) => Either.left(Tuple<A, B>(
        first: firstValue,
        second: secondValue,
      )),
    ),
  );
}

Either<T, Tuple3<A, B, C>> mergeRight3<T, A, B, C>(
    {required Either<T, A> Function() first,
    required Either<T, B> Function() second,
    required Either<T, C> Function() third}) {
  return first().consume(
    onRight: (firstValue) => second().consume(
      onRight: (secondValue) => third().consume(
        onRight: (thirdValue) => Either.right(Tuple3<A, B, C>(
          first: firstValue,
          second: secondValue,
          third: thirdValue,
        )),
        onLeft: (value) => Either.left(value),
      ),
      onLeft: (value) => Either.left(value),
    ),
    onLeft: (value) => Either.left(value),
  );
}

Either<Tuple3<A, B, C>, T> mergeLeft3<T, A, B, C>(
    {required Either<A, T> Function() first,
    required Either<B, T> Function() second,
    required Either<C, T> Function() third}) {
  return first().consume(
    onRight: (value) => Either.right(value),
    onLeft: (firstValue) => second().consume(
      onRight: (value) => Either.right(value),
      onLeft: (secondValue) => third().consume(
        onRight: (value) => Either.right(value),
        onLeft: (thirdValue) => Either.left(Tuple3<A, B, C>(
          first: firstValue,
          second: secondValue,
          third: thirdValue,
        )),
      ),
    ),
  );
}

Either<T, Tuple4<A, B, C, D>> mergeRight4<T, A, B, C, D>(
    {required Either<T, A> Function() first,
    required Either<T, B> Function() second,
    required Either<T, C> Function() third,
    required Either<T, D> Function() fourth}) {
  return first().consume(
    onRight: (firstValue) => second().consume(
      onRight: (secondValue) => third().consume(
        onRight: (thirdValue) => fourth().consume(
          onRight: (fourthValue) => Either.right(Tuple4<A, B, C, D>(
            first: firstValue,
            second: secondValue,
            third: thirdValue,
            fourth: fourthValue,
          )),
          onLeft: (value) => Either.left(value),
        ),
        onLeft: (value) => Either.left(value),
      ),
      onLeft: (value) => Either.left(value),
    ),
    onLeft: (value) => Either.left(value),
  );
}

Either<Tuple4<A, B, C, D>, T> mergeLeft4<T, A, B, C, D>(
    {required Either<A, T> Function() first,
    required Either<B, T> Function() second,
    required Either<C, T> Function() third,
    required Either<D, T> Function() fourth}) {
  return first().consume(
    onRight: (value) => Either.right(value),
    onLeft: (firstValue) => second().consume(
      onRight: (value) => Either.right(value),
      onLeft: (secondValue) => third().consume(
        onRight: (value) => Either.right(value),
        onLeft: (thirdValue) => fourth().consume(
          onRight: (value) => Either.right(value),
          onLeft: (fourthValue) => Either.left(Tuple4<A, B, C, D>(
            first: firstValue,
            second: secondValue,
            third: thirdValue,
            fourth: fourthValue,
          )),
        ),
      ),
    ),
  );
}

Either<T, Tuple5<A, B, C, D, E>> mergeRight5<T, A, B, C, D, E>(
    {required Either<T, A> Function() first,
    required Either<T, B> Function() second,
    required Either<T, C> Function() third,
    required Either<T, D> Function() fourth,
    required Either<T, E> Function() fifth}) {
  return first().consume(
    onRight: (firstValue) => second().consume(
      onRight: (secondValue) => third().consume(
        onRight: (thirdValue) => fourth().consume(
          onRight: (fourthValue) => fifth().consume(
            onRight: (fifthValue) => Either.right(Tuple5<A, B, C, D, E>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
              fourth: fourthValue,
              fifth: fifthValue,
            )),
            onLeft: (value) => Either.left(value),
          ),
          onLeft: (value) => Either.left(value),
        ),
        onLeft: (value) => Either.left(value),
      ),
      onLeft: (value) => Either.left(value),
    ),
    onLeft: (value) => Either.left(value),
  );
}

Either<Tuple5<A, B, C, D, E>, T> mergeLeft5<T, A, B, C, D, E>(
    {required Either<A, T> Function() first,
    required Either<B, T> Function() second,
    required Either<C, T> Function() third,
    required Either<D, T> Function() fourth,
    required Either<E, T> Function() fifth}) {
  return first().consume(
    onRight: (value) => Either.right(value),
    onLeft: (firstValue) => second().consume(
      onRight: (value) => Either.right(value),
      onLeft: (secondValue) => third().consume(
        onRight: (value) => Either.right(value),
        onLeft: (thirdValue) => fourth().consume(
          onRight: (value) => Either.right(value),
          onLeft: (fourthValue) => fifth().consume(
            onRight: (value) => Either.right(value),
            onLeft: (fifthValue) => Either.left(Tuple5<A, B, C, D, E>(
              first: firstValue,
              second: secondValue,
              third: thirdValue,
              fourth: fourthValue,
              fifth: fifthValue,
            )),
          ),
        ),
      ),
    ),
  );
}

Either<T, Tuple6<A, B, C, D, E, F>> mergeRight6<T, A, B, C, D, E, F>(
    {required Either<T, A> Function() first,
    required Either<T, B> Function() second,
    required Either<T, C> Function() third,
    required Either<T, D> Function() fourth,
    required Either<T, E> Function() fifth,
    required Either<T, F> Function() sixth}) {
  return first().consume(
    onRight: (firstValue) => second().consume(
      onRight: (secondValue) => third().consume(
        onRight: (thirdValue) => fourth().consume(
          onRight: (fourthValue) => fifth().consume(
            onRight: (fifthValue) => sixth().consume(
              onRight: (sixthValue) => Either.right(Tuple6<A, B, C, D, E, F>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
                fifth: fifthValue,
                sixth: sixthValue,
              )),
              onLeft: (value) => Either.left(value),
            ),
            onLeft: (value) => Either.left(value),
          ),
          onLeft: (value) => Either.left(value),
        ),
        onLeft: (value) => Either.left(value),
      ),
      onLeft: (value) => Either.left(value),
    ),
    onLeft: (value) => Either.left(value),
  );
}

Either<Tuple6<A, B, C, D, E, F>, T> mergeLeft6<T, A, B, C, D, E, F>(
    {required Either<A, T> Function() first,
    required Either<B, T> Function() second,
    required Either<C, T> Function() third,
    required Either<D, T> Function() fourth,
    required Either<E, T> Function() fifth,
    required Either<F, T> Function() sixth}) {
  return first().consume(
    onRight: (value) => Either.right(value),
    onLeft: (firstValue) => second().consume(
      onRight: (value) => Either.right(value),
      onLeft: (secondValue) => third().consume(
        onRight: (value) => Either.right(value),
        onLeft: (thirdValue) => fourth().consume(
          onRight: (value) => Either.right(value),
          onLeft: (fourthValue) => fifth().consume(
            onRight: (value) => Either.right(value),
            onLeft: (fifthValue) => sixth().consume(
              onRight: (value) => Either.right(value),
              onLeft: (sixthValue) => Either.left(Tuple6<A, B, C, D, E, F>(
                first: firstValue,
                second: secondValue,
                third: thirdValue,
                fourth: fourthValue,
                fifth: fifthValue,
                sixth: sixthValue,
              )),
            ),
          ),
        ),
      ),
    ),
  );
}

Either<T, Tuple7<A, B, C, D, E, F, G>> mergeRight7<T, A, B, C, D, E, F, G>(
    {required Either<T, A> Function() first,
    required Either<T, B> Function() second,
    required Either<T, C> Function() third,
    required Either<T, D> Function() fourth,
    required Either<T, E> Function() fifth,
    required Either<T, F> Function() sixth,
    required Either<T, G> Function() seventh}) {
  return first().consume(
    onRight: (firstValue) => second().consume(
      onRight: (secondValue) => third().consume(
        onRight: (thirdValue) => fourth().consume(
          onRight: (fourthValue) => fifth().consume(
            onRight: (fifthValue) => sixth().consume(
              onRight: (sixthValue) => seventh().consume(
                onRight: (seventhValue) => Either.right(Tuple7<A, B, C, D, E, F, G>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                  sixth: sixthValue,
                  seventh: seventhValue,
                )),
                onLeft: (value) => Either.left(value),
              ),
              onLeft: (value) => Either.left(value),
            ),
            onLeft: (value) => Either.left(value),
          ),
          onLeft: (value) => Either.left(value),
        ),
        onLeft: (value) => Either.left(value),
      ),
      onLeft: (value) => Either.left(value),
    ),
    onLeft: (value) => Either.left(value),
  );
}

Either<Tuple7<A, B, C, D, E, F, G>, T> mergeLeft7<T, A, B, C, D, E, F, G>(
    {required Either<A, T> Function() first,
    required Either<B, T> Function() second,
    required Either<C, T> Function() third,
    required Either<D, T> Function() fourth,
    required Either<E, T> Function() fifth,
    required Either<F, T> Function() sixth,
    required Either<G, T> Function() seventh}) {
  return first().consume(
    onRight: (value) => Either.right(value),
    onLeft: (firstValue) => second().consume(
      onRight: (value) => Either.right(value),
      onLeft: (secondValue) => third().consume(
        onRight: (value) => Either.right(value),
        onLeft: (thirdValue) => fourth().consume(
          onRight: (value) => Either.right(value),
          onLeft: (fourthValue) => fifth().consume(
            onRight: (value) => Either.right(value),
            onLeft: (fifthValue) => sixth().consume(
              onRight: (value) => Either.right(value),
              onLeft: (sixthValue) => seventh().consume(
                onRight: (value) => Either.right(value),
                onLeft: (seventhValue) => Either.left(Tuple7<A, B, C, D, E, F, G>(
                  first: firstValue,
                  second: secondValue,
                  third: thirdValue,
                  fourth: fourthValue,
                  fifth: fifthValue,
                  sixth: sixthValue,
                  seventh: seventhValue,
                )),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Either<T, Tuple8<A, B, C, D, E, F, G, H>> mergeRight8<T, A, B, C, D, E, F, G, H>(
    {required Either<T, A> Function() first,
    required Either<T, B> Function() second,
    required Either<T, C> Function() third,
    required Either<T, D> Function() fourth,
    required Either<T, E> Function() fifth,
    required Either<T, F> Function() sixth,
    required Either<T, G> Function() seventh,
    required Either<T, H> Function() eighth}) {
  return first().consume(
    onRight: (firstValue) => second().consume(
      onRight: (secondValue) => third().consume(
        onRight: (thirdValue) => fourth().consume(
          onRight: (fourthValue) => fifth().consume(
            onRight: (fifthValue) => sixth().consume(
              onRight: (sixthValue) => seventh().consume(
                onRight: (seventhValue) => eighth().consume(
                  onRight: (eighthValue) => Either.right(Tuple8<A, B, C, D, E, F, G, H>(
                    first: firstValue,
                    second: secondValue,
                    third: thirdValue,
                    fourth: fourthValue,
                    fifth: fifthValue,
                    sixth: sixthValue,
                    seventh: seventhValue,
                    eighth: eighthValue,
                  )),
                  onLeft: (value) => Either.left(value),
                ),
                onLeft: (value) => Either.left(value),
              ),
              onLeft: (value) => Either.left(value),
            ),
            onLeft: (value) => Either.left(value),
          ),
          onLeft: (value) => Either.left(value),
        ),
        onLeft: (value) => Either.left(value),
      ),
      onLeft: (value) => Either.left(value),
    ),
    onLeft: (value) => Either.left(value),
  );
}

Either<Tuple8<A, B, C, D, E, F, G, H>, T> mergeLeft8<T, A, B, C, D, E, F, G, H>(
    {required Either<A, T> Function() first,
    required Either<B, T> Function() second,
    required Either<C, T> Function() third,
    required Either<D, T> Function() fourth,
    required Either<E, T> Function() fifth,
    required Either<F, T> Function() sixth,
    required Either<G, T> Function() seventh,
    required Either<H, T> Function() eighth}) {
  return first().consume(
    onRight: (value) => Either.right(value),
    onLeft: (firstValue) => second().consume(
      onRight: (value) => Either.right(value),
      onLeft: (secondValue) => third().consume(
        onRight: (value) => Either.right(value),
        onLeft: (thirdValue) => fourth().consume(
          onRight: (value) => Either.right(value),
          onLeft: (fourthValue) => fifth().consume(
            onRight: (value) => Either.right(value),
            onLeft: (fifthValue) => sixth().consume(
              onRight: (value) => Either.right(value),
              onLeft: (sixthValue) => seventh().consume(
                onRight: (value) => Either.right(value),
                onLeft: (seventhValue) => eighth().consume(
                  onRight: (value) => Either.right(value),
                  onLeft: (eighthValue) => Either.left(Tuple8<A, B, C, D, E, F, G, H>(
                    first: firstValue,
                    second: secondValue,
                    third: thirdValue,
                    fourth: fourthValue,
                    fifth: fifthValue,
                    sixth: sixthValue,
                    seventh: seventhValue,
                    eighth: eighthValue,
                  )),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Either<T, Tuple9<A, B, C, D, E, F, G, H, I>> mergeRight9<T, A, B, C, D, E, F, G, H, I>(
    {required Either<T, A> Function() first,
    required Either<T, B> Function() second,
    required Either<T, C> Function() third,
    required Either<T, D> Function() fourth,
    required Either<T, E> Function() fifth,
    required Either<T, F> Function() sixth,
    required Either<T, G> Function() seventh,
    required Either<T, H> Function() eighth,
    required Either<T, I> Function() ninth}) {
  return first().consume(
    onRight: (firstValue) => second().consume(
      onRight: (secondValue) => third().consume(
        onRight: (thirdValue) => fourth().consume(
          onRight: (fourthValue) => fifth().consume(
            onRight: (fifthValue) => sixth().consume(
              onRight: (sixthValue) => seventh().consume(
                onRight: (seventhValue) => eighth().consume(
                  onRight: (eighthValue) => ninth().consume(
                    onRight: (ninthValue) => Either.right(Tuple9<A, B, C, D, E, F, G, H, I>(
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
                    onLeft: (value) => Either.left(value),
                  ),
                  onLeft: (value) => Either.left(value),
                ),
                onLeft: (value) => Either.left(value),
              ),
              onLeft: (value) => Either.left(value),
            ),
            onLeft: (value) => Either.left(value),
          ),
          onLeft: (value) => Either.left(value),
        ),
        onLeft: (value) => Either.left(value),
      ),
      onLeft: (value) => Either.left(value),
    ),
    onLeft: (value) => Either.left(value),
  );
}

Either<Tuple9<A, B, C, D, E, F, G, H, I>, T> mergeLeft9<T, A, B, C, D, E, F, G, H, I>(
    {required Either<A, T> Function() first,
    required Either<B, T> Function() second,
    required Either<C, T> Function() third,
    required Either<D, T> Function() fourth,
    required Either<E, T> Function() fifth,
    required Either<F, T> Function() sixth,
    required Either<G, T> Function() seventh,
    required Either<H, T> Function() eighth,
    required Either<I, T> Function() ninth}) {
  return first().consume(
    onRight: (value) => Either.right(value),
    onLeft: (firstValue) => second().consume(
      onRight: (value) => Either.right(value),
      onLeft: (secondValue) => third().consume(
        onRight: (value) => Either.right(value),
        onLeft: (thirdValue) => fourth().consume(
          onRight: (value) => Either.right(value),
          onLeft: (fourthValue) => fifth().consume(
            onRight: (value) => Either.right(value),
            onLeft: (fifthValue) => sixth().consume(
              onRight: (value) => Either.right(value),
              onLeft: (sixthValue) => seventh().consume(
                onRight: (value) => Either.right(value),
                onLeft: (seventhValue) => eighth().consume(
                  onRight: (value) => Either.right(value),
                  onLeft: (eighthValue) => ninth().consume(
                    onRight: (value) => Either.right(value),
                    onLeft: (ninthValue) => Either.left(Tuple9<A, B, C, D, E, F, G, H, I>(
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
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
