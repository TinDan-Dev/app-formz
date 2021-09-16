import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart' hide LibraryBuilder;
import 'package:source_gen/source_gen.dart';

import 'tuple_generator.dart';

Builder mergeGeneratorBuilder(BuilderOptions options) =>
    LibraryBuilder(MergeGenerator(), generatedExtension: '.merge.dart');

class MergeGenerator extends Generator {
  final emitter = DartEmitter();

  String generate(LibraryReader _, __) {
    final buffer = StringBuffer();

    buffer.write('''
import 'formz.tuple.dart';
import 'src/functional/either/either.dart';
    ''');

    for (int i = 2; i <= 9; i++) {
      buffer.writeln(mergeRight(i).accept(emitter));
      buffer.writeln(mergeLeft(i).accept(emitter));
    }

    return buffer.toString();
  }

  Method mergeRight(int i) {
    final method = Method((builder) {
      builder.name = 'mergeRight${TupleGenerator.suffixes[i - 2]}';
      builder.returns = refer('Either<T, ${TupleGenerator.getTupleName(i)}>');
      builder.types.add(refer('T'));

      for (int k = 0; k < i; k++) {
        builder.types.add(refer(TupleGenerator.generics[k]));

        builder.optionalParameters.add(Parameter((builder) => builder
          ..name = TupleGenerator.fields[k]
          ..named = true
          ..required = true
          ..type = FunctionType((builder) => builder.returnType = refer('Either<T, ${TupleGenerator.generics[k]}>'))));
      }

      builder.body = Code('return ${buildMergeRight(0, i)};');
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

  Method mergeLeft(int i) {
    final method = Method((builder) {
      builder.name = 'mergeLeft${TupleGenerator.suffixes[i - 2]}';
      builder.returns = refer('Either<${TupleGenerator.getTupleName(i)}, T>');
      builder.types.add(refer('T'));

      for (int k = 0; k < i; k++) {
        builder.types.add(refer(TupleGenerator.generics[k]));

        builder.optionalParameters.add(Parameter((builder) => builder
          ..name = TupleGenerator.fields[k]
          ..named = true
          ..required = true
          ..type = FunctionType((builder) => builder.returnType = refer('Either<${TupleGenerator.generics[k]}, T>'))));
      }

      builder.body = Code('return ${buildMergeLeft(0, i)};');
    });

    return method;
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
