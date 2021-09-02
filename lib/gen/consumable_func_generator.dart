import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

Builder consumableFuncGeneratorBuilder(BuilderOptions options) =>
    LibraryBuilder(ConsumableFuncGenerator(), generatedExtension: '.con.dart');

enum Consumables {
  consumable,
  consumableFuture,
  consumableAsync,
  consumableAsyncFuture,
}

const extensionNames = {
  Consumables.consumable: 'ConsumableExtensions<T>',
  Consumables.consumableFuture: 'ConsumableFutureExtensions<T>',
  Consumables.consumableAsync: 'ConsumableAsyncExtensions<T>',
  Consumables.consumableAsyncFuture: 'ConsumableAsyncFutureExtensions<T>',
};

const extensionTarget = {
  Consumables.consumable: 'Consumable<T>',
  Consumables.consumableFuture: 'FutureOr<Consumable<T>>',
  Consumables.consumableAsync: 'ConsumableAsync<T>',
  Consumables.consumableAsyncFuture: 'FutureOr<ConsumableAsync<T>>',
};

const classes = [];

const functions = [
  '''
  @return{bool} get success @async => @this.consume(onSuccess: (_) => true, onError: (_) => false);
  ''',
  '''
  @return{bool} get failure @async => @this.consume(onSuccess: (_) => false, onError: (_) => true);
  ''',
  '''
  @return{void} invoke() @async => @this.consume(onSuccess: (_) {}, onError: (_) {});
  ''',
  '''
  @return{Consumable@Async<void>} discardValue() @async => @this.consume(
    onSuccess: (_) => const ActionResult@Async.success(),
    onError: (failure) => ActionResult@Async.fail(failure),
  );
  ''',
  '''
  @return{Consumable@Async<T>} discardError(T value) @async => @this.consume(
    onSuccess: (_) => this,
    onError: (_) => ValueActionResult@Async<T>.success(value),
  );
  ''',
  '''
  @return{Consumable@Async<T?>} discardErrorNullable([T? value]) @async => @this.consume(
    onSuccess: (_) => this,
    onError: (_) => ValueActionResult@Async<T?>.success(value),
  );
  ''',
  '''
  @return{T} valueOr(T value) @async => @this.consume(
    onSuccess: (value) => value,
    onError: (_) => value,
  );
  ''',
  '''
  @return{T?} valueOrNullable([T? value]) @async => @this.consume(
    onSuccess: (value) => value,
    onError: (_) => value,
  );
  ''',
  '''
  @return{void} onSuccess(@futureOr{void} callback(T value)) @async => @this.consume(
    onSuccess: callback,
    onError: (_) {},
  );
  ''',
  '''
  @return{void} onError(void callback(Failure failure)) @async => @this.consume(
    onSuccess: (_) {},
    onError: callback,
  );
  ''',
  '''
  @return{Consumable@Async<S>} map<S>(@futureOr{S} mapper(T value)) @async => @this.consume(
    onSuccess: (value) @async => ValueActionResult@Async.success(@await mapper(value)),
    onError: (failure) => ValueActionResult@Async.fail(failure),
  );
  ''',
  '''
  @return{Consumable@Async<S>} flatMap<S>(Consumable@Async<S> mapper(T value)) @async => @this.consume(
    onSuccess: (value) => mapper(value),
    onError: (failure) => ValueActionResult@Async.fail(failure),
  );
  ''',
  '''
  @return{Consumable@Async<S>} cast<S>({Failure failure()?, @futureOr{S} fallback()?}) @async { 
    assert(failure != null || fallback != null, 'either failure or fallback must be set');
    return @this.consume(
      onSuccess: (value) @async {
        if (value is S) {
          return this as Consumable@Async<S>;
        } else if (fallback != null) {
          return ValueActionResult@Async.success(@await fallback());
        } else {
          return ValueActionResult@Async.fail(failure!.call());
        }
      },
      onError: (failure) => ValueActionResult@Async.fail(failure),
    );
  }
  ''',
  '''
  @return{Consumable@Async<T>} resolve({
    required @futureOr{bool} condition(Failure value),
    required @futureOr{Consumable@Async<T>} match(Failure value),
  }) @async => @this.consume(
    onSuccess: (_) => this,
    onError: (failure) @async {
      if (@await condition(failure))
        return @await match(failure);
      else
        return this;
    },
  );
  ''',
];

const syncFunctions = [
  '''
  Future<void> onSuccessAsync(FutureOr<void> callback(T value)) => @this.consume(
    onSuccess: (value) async => callback(value),
    onError: (_) async {},
  );
  ''',
  '''
  Future<ConsumableAsync<S>> mapAsync<S>(FutureOr<S> mapper(T value)) => @this.consume(
    onSuccess: (value) async => ValueActionResultAsync.success(await mapper(value)),
    onError: (failure) async => ValueActionResultAsync.fail(failure),
  );
  ''',
  '''
  Future<ConsumableAsync<S>> flatMapAsync<S>(FutureOr<ConsumableAsync<S>> mapper(T value)) => @this.consume(
    onSuccess: (value) async => mapper(value),
    onError: (failure) async => ValueActionResultAsync.fail(failure),
  );
  ''',
];

const asyncFunctions = [
  '''
  Future<Consumable<S>> flatMapSync<S>(FutureOr<Consumable<S>> mapper(T value)) @async => @this.consume(
    onSuccess: (value) async => mapper(value),
    onError: (failure) async => ValueActionResult.fail(failure),
  );
  '''
];

class ConsumableFuncGenerator extends Generator {
  final returnRegex = RegExp(r'(?<=@return{)[^}]*(?=})');
  final returnRegexReplace = RegExp(r'@return{[^}]*}');

  final futureOrRegex = RegExp(r'(?<=@futureOr{)[^}]*(?=})');
  final futureOrRegexReplace = RegExp(r'@futureOr{[^}]*}');

  @override
  String generate(LibraryReader _, BuildStep __) {
    final buf = StringBuffer();

    buf.writeln(''' 
// ignore_for_file: unnecessary_this

import 'dart:async';
import 'formz.dart';
    ''');

    generateClass(buf, false);
    generateClass(buf, true);

    Consumables.values.forEach((c) => generateExtension(buf, c));
    return buf.toString();
  }

  String getExtensionName(Consumables consumable) {
    return extensionNames[consumable]!;
  }

  String getExtensionTarget(Consumables consumable) {
    return extensionTarget[consumable]!;
  }

  String convertReturnType(String function, Consumables consumable) {
    final returnType = returnRegex.firstMatch(function)?.group(0) ?? 'void';

    final wrappedReturnType;
    if (consumable == Consumables.consumable)
      wrappedReturnType = returnType;
    else
      wrappedReturnType = 'Future<$returnType>';

    return function.replaceFirst(returnRegexReplace, wrappedReturnType);
  }

  String convertAsync(String function, Consumables consumable) {
    final asyncStr;
    if (consumable == Consumables.consumable)
      asyncStr = '';
    else
      asyncStr = 'async';

    return function.replaceAll('@async', asyncStr);
  }

  String convertAwait(String function, Consumables consumable) {
    final awaitStr;
    if (consumable == Consumables.consumable)
      awaitStr = '';
    else
      awaitStr = 'await';

    return function.replaceAll('@await', awaitStr);
  }

  String convertUpAsync(String function, Consumables consumable) {
    final asyncStr;
    if (consumable == Consumables.consumable || consumable == Consumables.consumableFuture)
      asyncStr = '';
    else
      asyncStr = 'Async';

    return function.replaceAll('@Async', asyncStr);
  }

  String convertThis(String function, Consumables consumable) {
    final thisStr;
    if (consumable == Consumables.consumableFuture || consumable == Consumables.consumableAsyncFuture)
      thisStr = '(await this)';
    else
      thisStr = 'this';

    return function.replaceAll('@this', thisStr);
  }

  String convertFutureOr(String function, bool async) {
    while (futureOrRegex.hasMatch(function)) {
      final futureOrType = futureOrRegex.firstMatch(function)?.group(0) ?? 'void';

      final wrappedFutureOrType;
      if (!async)
        wrappedFutureOrType = futureOrType;
      else
        wrappedFutureOrType = 'FutureOr<$futureOrType>';

      function = function.replaceFirst(futureOrRegexReplace, wrappedFutureOrType);
    }
    return function;
  }

  String convert(String function, Consumables consumable) {
    final async = consumable == Consumables.consumableAsync || consumable == Consumables.consumableAsyncFuture;

    return convertThis(
      convertFutureOr(
        convertUpAsync(
          convertAwait(
            convertAsync(
              convertReturnType(
                function,
                consumable,
              ),
              consumable,
            ),
            consumable,
          ),
          consumable,
        ),
        async,
      ),
      consumable,
    );
  }

  void generateExtension(StringBuffer buf, Consumables consumable) {
    final name = getExtensionName(consumable);
    final target = getExtensionTarget(consumable);

    buf.writeln('extension $name on $target {');

    for (final function in functions) {
      buf.writeln(convert(function, consumable));
    }

    if (consumable == Consumables.consumable) {
      for (final function in syncFunctions) {
        buf.writeln(convert(function, consumable));
      }
    }

    if (consumable == Consumables.consumableAsync || consumable == Consumables.consumableAsyncFuture) {
      for (final function in asyncFunctions) {
        buf.writeln(convert(function, consumable));
      }
    }

    buf.writeln('}');
  }

  String convertConsume(String function, bool async) {
    final startIndex = function.indexOf('@consume');

    var endIndex = startIndex + 10;
    var open = 1;
    var close = 0;

    while (endIndex < function.length) {
      final char = function[endIndex];

      if (char == '}') close++;
      if (char == '{') open++;

      if (close >= open) break;

      endIndex++;
    }

    final dataType = async ? 'FutureOr<S>' : 'S';
    final returnType = async ? 'Future<S>' : 'S';
    final asyncStr = async ? 'async' : '';

    return '''
    ${function.substring(0, startIndex)}
    @override
    $returnType consume<S>({
      required $dataType onSuccess(T value),
      required $dataType onError(Failure failure),
    }) $asyncStr {
      ${function.substring(startIndex + 9, endIndex)}
    }
    ${function.substring(endIndex + 1)}
    ''';
  }

  void generateClass(StringBuffer buf, bool async) {
    final consumable = async ? Consumables.consumableAsync : Consumables.consumable;

    for (final classData in classes) {
      final converted = convertConsume(convertFutureOr(convertUpAsync(classData, consumable), async), async);

      buf.writeln(converted);
    }
  }
}
