import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart' hide LibraryBuilder;
import 'package:source_gen/source_gen.dart';

import 'tuple_generator.dart';

Builder mergeGeneratorBuilder(BuilderOptions options) =>
    LibraryBuilder(MergeGenerator(), generatedExtension: '.merge.dart');

String enclose(String left, String inner, String right, bool apply) {
  if (apply) {
    return '$left$inner$right';
  } else {
    return inner;
  }
}

class MergeGenerator extends Generator {
  final emitter = DartEmitter();

  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    final buffer = StringBuffer();

    buffer.write('''
import 'dart:async';
import 'formz.tuple.dart';
import 'src/functional/either/either.dart';
    ''');

    for (int i = 2; i <= 9; i++) {
      buffer.writeln(merge(i, true, true).accept(emitter));
      buffer.writeln(merge(i, true, false).accept(emitter));
      buffer.writeln(merge(i, false, true).accept(emitter));
      buffer.writeln(merge(i, false, false).accept(emitter));
    }

    return buffer.toString();
  }

  Method merge(int i, bool right, bool async) {
    final method = Method((builder) {
      builder.name = 'merge${right ? 'Right' : 'Left'}${async ? 'Async' : ''}${TupleGenerator.suffixes[i - 2]}';
      builder.types.add(refer('T'));

      if (right) {
        builder.returns = refer(enclose('Future<', 'Either<T, ${TupleGenerator.getTupleName(i)}>', '>', async));
      } else {
        builder.returns = refer(enclose('Future<', 'Either<${TupleGenerator.getTupleName(i)}, T>', '>', async));
      }

      for (int k = 0; k < i; k++) {
        builder.types.add(refer(TupleGenerator.generics[k]));

        final String returnType;
        if (right) {
          returnType = enclose('FutureOr<', 'Either<T, ${TupleGenerator.generics[k]}>', '>', async);
        } else {
          returnType = enclose('FutureOr<', 'Either<${TupleGenerator.generics[k]}, T>', '>', async);
        }

        builder.optionalParameters.add(Parameter((builder) => builder
          ..name = TupleGenerator.fields[k]
          ..named = true
          ..required = true
          ..type = FunctionType((builder) => builder.returnType = refer(returnType))));
      }

      if (right) {
        builder.body = Code('return ${buildMergeRight(0, i)};');
      } else {
        builder.body = Code('return ${buildMergeLeft(0, i)};');
      }
    });

    return method;
  }

  String buildMergeRight(int lvl, int maxLvl) {
    if (lvl == maxLvl) return 'Either.right(${buildTuple(lvl)})';

    final name = TupleGenerator.fields[lvl];

    return '''
$name().consume(
  onRight: (${name}Value) => ${buildMergeRight(lvl + 1, maxLvl)},
  onLeft: (value) => Either.left(value),
)
  ''';
  }

  String buildMergeLeft(int lvl, int maxLvl) {
    if (lvl == maxLvl) return 'Either.left(${buildTuple(lvl)})';

    final name = TupleGenerator.fields[lvl];

    return '''
$name().consume(
  onRight: (value) => Either.right(value),
  onLeft: (${name}Value) => ${buildMergeLeft(lvl + 1, maxLvl)},
)
  ''';
  }

  String buildTuple(int lvl) {
    final buffer = StringBuffer();
    buffer.write(TupleGenerator.getTupleName(lvl));

    buffer.write('(');
    for (int i = 0; i < lvl; i++) {
      final name = TupleGenerator.fields[i];

      buffer.write('$name: ${name}Value,');
    }
    buffer.write(')');

    return buffer.toString();
  }
}
