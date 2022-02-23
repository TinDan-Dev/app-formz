import 'package:build/build.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:code_builder/code_builder.dart' hide LibraryBuilder;
import 'package:source_gen/source_gen.dart';

Builder tupleGeneratorBuilder(BuilderOptions options) =>
    LibraryBuilder(TupleGenerator(), generatedExtension: '.tuple.dart');

extension StringHelper on String {
  String firstToUpper() {
    if (length <= 0) return this;

    final first = this[0];
    return first.toUpperCase() + substring(1);
  }
}

class TupleGenerator extends Generator {
  static const generics = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I'];
  static const fields = ['first', 'second', 'third', 'fourth', 'fifth', 'sixth', 'seventh', 'eighth', 'ninth'];
  static const suffixes = ['', '3', '4', '5', '6', '7', '8', '9'];

  final emitter = DartEmitter();

  static String getTupleName(int count) {
    final buf = StringBuffer();
    buf.write('Tuple${suffixes[count - 2]}<');

    for (int i = 0; i < count; i++) {
      buf.write(generics[i]);

      if (i + 1 < count) buf.write(', ');
    }

    buf.write('>');

    return buf.toString();
  }

  static String getTTupleName(int count, int tPlace) {
    assert(tPlace < count);

    final buf = StringBuffer();
    buf.write('Tuple${suffixes[count - 2]}<');

    for (int i = 0; i < count; i++) {
      if (i == tPlace)
        buf.write('T');
      else
        buf.write(generics[i]);

      if (i + 1 < count) buf.write(', ');
    }

    buf.write('>');

    return buf.toString();
  }

  @override
  String generate(LibraryReader _, __) {
    final classBuf = StringBuffer();

    for (int i = 2; i <= 9; i++) {
      final tupleClass = Class((builder) {
        builder.name = 'Tuple${suffixes[i - 2]}';
        builder.extend = refer('Equatable');

        for (int k = 0; k < i; k++) builder.types.add(refer(generics[k]));

        for (int k = 0; k < i; k++) {
          builder.fields.add(Field((fBuilder) => fBuilder
            ..name = fields[k]
            ..type = refer(generics[k])
            ..modifier = FieldModifier.final$));
        }

        builder.constructors.add(Constructor((cBuilder) {
          cBuilder.constant = true;
          for (int k = 0; k < i; k++) {
            cBuilder.optionalParameters.add(Parameter((pBuilder) => pBuilder
              ..name = fields[k]
              ..required = true
              ..named = true
              ..toThis = true));
          }
        }));

        builder.methods.add(Method((mBuilder) {
          mBuilder.name = 'props';
          mBuilder.type = MethodType.getter;
          mBuilder.annotations.add(refer('override'));
          mBuilder.returns = refer('List<Object?>');
          mBuilder.lambda = true;

          final bodyBuf = StringBuffer();
          bodyBuf.write('[');

          for (int k = 0; k < i; k++) {
            bodyBuf.write(fields[k]);

            if (k + 1 < i) bodyBuf.write(', ');
          }

          bodyBuf.write(']');

          mBuilder.body = Code(bodyBuf.toString());
        }));

        builder.methods.add(Method((mBuilder) {
          mBuilder.name = 'copyWith';
          mBuilder.returns = refer(getTupleName(i));
          mBuilder.lambda = true;

          for (int k = 0; k < i; k++) {
            mBuilder.optionalParameters.add(Parameter((pBuilder) => pBuilder
              ..name = fields[k]
              ..type = refer('SupplyFunc<${generics[k]}>?')
              ..named = true));
          }

          final bodyBuf = StringBuffer();
          bodyBuf.write('${getTupleName(i)}(');

          for (int k = 0; k < i; k++) {
            final name = fields[k];

            bodyBuf.write('$name: $name == null ? this.$name : $name(), ');
          }

          bodyBuf.write(')');
          mBuilder.body = Code(bodyBuf.toString());
        }));

        String getMapperCode(int count, int tPlace, bool async) {
          final buf = StringBuffer();
          buf.write('${getTTupleName(count, tPlace)}(');

          for (int i = 0; i < count; i++) {
            final name = fields[i];

            if (i == tPlace) {
              if (async)
                buf.write('$name: await mapper($name), ');
              else
                buf.write('$name: mapper($name), ');
            } else {
              buf.write('$name: $name, ');
            }
          }

          buf.write(')');
          return buf.toString();
        }

        for (int k = 0; k < i; k++) {
          builder.methods.add(Method((mBuilder) => mBuilder
            ..name = 'map${fields[k].firstToUpper()}'
            ..returns = refer(getTTupleName(i, k))
            ..types.add(refer('T'))
            ..lambda = true
            ..requiredParameters.add(Parameter((pBuilder) => pBuilder
              ..name = 'mapper'
              ..type = refer('T Function(${generics[k]} value)')))
            ..body = Code(getMapperCode(i, k, false))));
        }
        for (int k = 0; k < i; k++) {
          builder.methods.add(Method((mBuilder) => mBuilder
            ..name = 'map${fields[k].firstToUpper()}Async'
            ..returns = refer('Future<${getTTupleName(i, k)}>')
            ..types.add(refer('T'))
            ..lambda = true
            ..modifier = MethodModifier.async
            ..requiredParameters.add(Parameter((pBuilder) => pBuilder
              ..name = 'mapper'
              ..type = refer('Future<T> Function(${generics[k]} value)')))
            ..body = Code(getMapperCode(i, k, true))));
        }
      });

      classBuf.writeln(tupleClass.accept(emitter));
    }

    return '''
import 'annotation.dart';
import 'package:equatable/equatable.dart';

${classBuf.toString()}
''';
  }
}
