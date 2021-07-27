import 'dart:async';

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart' hide LibraryBuilder;
import 'package:source_gen/source_gen.dart';

import 'tuple_generator.dart';

Builder mergeGeneratorBuilder(BuilderOptions options) =>
    LibraryBuilder(MergeGenerator(), generatedExtension: '.merge.dart');

class MergeGenerator extends Generator {
  final emitter = DartEmitter();

  @override
  Future<String> generate(LibraryReader _, __) async {
    final buf = StringBuffer();

    for (int i = 2; i <= 9; i++) {
      buf.writeln(createMergeConsumable(i, false, false));
      buf.writeln(createMergeConsumable(i, true, false));

      buf.writeln(createMergeConsumable(i, false, true));
      buf.writeln(createMergeConsumable(i, true, true));
    }

    buf.writeln(createMergeExtension(true));
    buf.writeln(createMergeExtension(false));

    buf.writeln(createAsyncMergeExtension(true));
    buf.writeln(createAsyncMergeExtension(false));

    return '''
import 'dart:async';

import 'formz.tuple.dart';
import 'src/utils/consumable.dart';
import 'src/utils/failure.dart';

${buf.toString()}
''';
  }

  String getTypeName(int count, bool async, bool joining) {
    final buf = StringBuffer();

    buf.write('_MergeConsumable');
    if (async) buf.write('Async');
    if (joining) buf.write('Joining');
    buf.write('${TupleGenerator.suffixes[count - 2]}<');

    for (int i = 0; i < count; i++) {
      buf.write(TupleGenerator.generics[i]);

      if (i + 1 < count) buf.write(', ');
    }

    buf.write('>');

    return buf.toString();
  }

  String getFunctionType(int k, bool async, bool joining) {
    final String joiningParam;
    if (k <= 0 || !joining)
      joiningParam = '';
    else if (k == 1)
      joiningParam = '${TupleGenerator.generics[0]} previous';
    else
      joiningParam = '${TupleGenerator.getTupleName(k)} previous';

    if (async)
      return 'FutureOr<ConsumableAsync<${TupleGenerator.generics[k]}>> Function($joiningParam)';
    else
      return 'Consumable<${TupleGenerator.generics[k]}> Function($joiningParam)';
  }

  String buildFiledAccess(int count, bool async, bool joining) {
    final buf = StringBuffer();
    final requiresInvocation = count > 1;

    if (async && requiresInvocation) buf.write('(await ');
    buf.write(TupleGenerator.fields[count - 1]);

    if (requiresInvocation) {
      buf.write('(');
      if (joining && count >= 2) {
        if (count == 2) {
          buf.write('${TupleGenerator.fields[0]}Value');
        } else {
          buf.write('${TupleGenerator.getTupleName(count - 1)}(');

          for (int i = 0; i < count - 1; i++)
            buf.write('${TupleGenerator.fields[i]}: ${TupleGenerator.fields[i]}Value, ');

          buf.write(')');
        }
      }
      buf.write(')');

      if (async) buf.write(')');
    }

    return buf.toString();
  }

  String buildConsumeBody(int count, int max, bool async, bool joining) {
    final fieldName = '${TupleGenerator.fields[count - 1]}';
    final field = buildFiledAccess(count, async, joining);

    if (count == max) {
      final tupleBuf = StringBuffer();
      tupleBuf.write('${TupleGenerator.getTupleName(count)}(');

      for (int i = 0; i < count; i++) {
        final name = TupleGenerator.fields[i];
        tupleBuf.write('$name: ${name}Value,');
      }

      tupleBuf.write(')');

      return '''
$field.consume(
  onSuccess: (${fieldName}Value) => onSuccess(${tupleBuf.toString()}),
  onError: onError,
)
      ''';
    } else {
      return '''
$field.consume(
  onSuccess: (${fieldName}Value) ${async ? 'async' : ''} => ${buildConsumeBody(count + 1, max, async, joining)},
  onError: onError,
)
      ''';
    }
  }

  String createMergeConsumable(int count, bool async, bool joining) {
    final asyncName = async ? 'Async' : '';
    final nameSuffix = asyncName + (joining ? 'Joining' : '');

    final mergeClass = Class((builder) {
      builder.name = '_MergeConsumable$nameSuffix${TupleGenerator.suffixes[count - 2]}';
      builder.mixins.add(refer('Consumable${asyncName}Mixin<${TupleGenerator.getTupleName(count)}>'));

      for (int k = 0; k < count; k++) builder.types.add(refer(TupleGenerator.generics[k]));

      for (int k = 0; k < count; k++) {
        final type;
        if (k == 0)
          type = 'Consumable$asyncName<${TupleGenerator.generics[k]}>';
        else
          type = getFunctionType(k, async, joining);

        builder.fields.add(Field((fBuilder) => fBuilder
          ..name = TupleGenerator.fields[k]
          ..modifier = FieldModifier.final$
          ..type = refer(type)));
      }

      builder.constructors.add(Constructor((cBuilder) {
        for (int k = 0; k < count; k++) {
          cBuilder.optionalParameters.add(Parameter((pBuilder) => pBuilder
            ..name = TupleGenerator.fields[k]
            ..required = true
            ..named = true
            ..toThis = true));
        }
      }));

      builder.methods.add(Method((mBuilder) {
        final type = async ? 'FutureOr<T>' : 'T';

        mBuilder.name = 'consume';
        mBuilder.returns = refer(async ? 'Future<T>' : 'T');
        mBuilder.types.add(refer('T'));
        mBuilder.annotations.add(refer('override'));
        mBuilder.optionalParameters.add(Parameter((pBuilder) => pBuilder
          ..name = 'onSuccess'
          ..type = refer('$type Function(${TupleGenerator.getTupleName(count)} value)')
          ..required = true
          ..named = true));
        mBuilder.optionalParameters.add(Parameter((pBuilder) => pBuilder
          ..name = 'onError'
          ..type = refer('$type Function(Failure failure)')
          ..required = true
          ..named = true));
        mBuilder.lambda = true;
        if (async) mBuilder.modifier = MethodModifier.async;

        mBuilder.body = Code(buildConsumeBody(1, count, async, joining));
      }));
    });

    return '${mergeClass.accept(emitter)}';
  }

  void createMergeExtensionFunc(MethodBuilder builder, int count, bool async, bool future, bool joining) {
    final asyncName = async ? 'Async' : '';
    final joiningName = joining ? 'Joining' : '';

    final String type;
    if (future)
      type = 'Future<Consumable$asyncName<${TupleGenerator.getTupleName(count)}>>';
    else
      type = 'Consumable$asyncName<${TupleGenerator.getTupleName(count)}>';

    builder.name = 'merge$asyncName$joiningName${TupleGenerator.suffixes[count - 2]}';
    builder.returns = refer(type);
    builder.lambda = true;
    if (future) builder.modifier = MethodModifier.async;

    for (int i = 1; i < count; i++) builder.types.add(refer(TupleGenerator.generics[i]));

    for (int i = 1; i < count; i++) {
      builder.optionalParameters.add(Parameter((pBuilder) => pBuilder
        ..name = TupleGenerator.fields[i]
        ..type = refer(getFunctionType(i, async, joining))
        ..named = true
        ..required = true));
    }

    final bodyBuf = StringBuffer();
    bodyBuf.write('${getTypeName(count, async, joining)}(');

    if (async)
      bodyBuf.write('first: ${future ? '(await this).' : ''}toConsumableAsync(),');
    else
      bodyBuf.write('first: ${future ? 'await' : ''} this,');

    for (int i = 1; i < count; i++) {
      final name = TupleGenerator.fields[i];
      bodyBuf.write('$name: $name,');
    }

    bodyBuf.write(')');

    builder.body = Code(bodyBuf.toString());
  }

  String createMergeExtension(bool future) {
    final extension = Extension((builder) {
      if (future) {
        builder.name = 'FutureMergeConsumableExtension<A>';
        builder.on = refer('Future<Consumable<A>>');
      } else {
        builder.name = 'MergeConsumableExtension<A>';
        builder.on = refer('Consumable<A>');
      }

      for (int i = 2; i <= 9; i++) {
        builder.methods.add(Method((mBuilder) => createMergeExtensionFunc(mBuilder, i, false, future, false)));
        builder.methods.add(Method((mBuilder) => createMergeExtensionFunc(mBuilder, i, true, future, false)));
        builder.methods.add(Method((mBuilder) => createMergeExtensionFunc(mBuilder, i, false, future, true)));
        builder.methods.add(Method((mBuilder) => createMergeExtensionFunc(mBuilder, i, true, future, true)));
      }
    });

    return '${extension.accept(emitter)}';
  }

  void createAsyncMergeExtensionFunc(MethodBuilder builder, int count, bool sync, bool future, bool joining) {
    final syncName = sync ? 'Sync' : '';
    final joiningName = joining ? 'Joining' : '';

    final String type;
    if (future)
      type = 'Future<ConsumableAsync<${TupleGenerator.getTupleName(count)}>>';
    else
      type = 'ConsumableAsync<${TupleGenerator.getTupleName(count)}>';

    builder.name = 'merge$syncName$joiningName${TupleGenerator.suffixes[count - 2]}';
    builder.returns = refer(type);
    builder.lambda = true;
    if (future) builder.modifier = MethodModifier.async;

    for (int i = 1; i < count; i++) builder.types.add(refer(TupleGenerator.generics[i]));

    for (int i = 1; i < count; i++) {
      final String type;
      final String joiningParam;
      if (i <= 0 || !joining)
        joiningParam = '';
      else if (i == 1)
        joiningParam = '${TupleGenerator.generics[0]} previous';
      else
        joiningParam = '${TupleGenerator.getTupleName(i)} previous';

      if (sync)
        type = 'FutureOr<Consumable<${TupleGenerator.generics[i]}>> Function($joiningParam)';
      else
        type = 'FutureOr<ConsumableAsync<${TupleGenerator.generics[i]}>> Function($joiningParam)';

      builder.optionalParameters.add(Parameter((pBuilder) => pBuilder
        ..name = TupleGenerator.fields[i]
        ..type = refer(type)
        ..named = true
        ..required = true));
    }

    final bodyBuf = StringBuffer();
    bodyBuf.write('${getTypeName(count, true, joining)}(');
    bodyBuf.write('first: ${future ? 'await' : ''} this,');

    for (int i = 1; i < count; i++) {
      final name = TupleGenerator.fields[i];
      if (sync) {
        final joiningParam = joining ? 'previous' : '';

        bodyBuf.write('$name: ($joiningParam) async => (await $name($joiningParam)).toConsumableAsync(),');
      } else
        bodyBuf.write('$name: $name,');
    }

    bodyBuf.write(')');

    builder.body = Code(bodyBuf.toString());
  }

  String createAsyncMergeExtension(bool future) {
    final extension = Extension((builder) {
      if (future) {
        builder.name = 'FutureMergeConsumableAsyncExtension<A>';
        builder.on = refer('Future<ConsumableAsync<A>>');
      } else {
        builder.name = 'MergeConsumableAsyncExtension<A>';
        builder.on = refer('ConsumableAsync<A>');
      }

      for (int i = 2; i <= 9; i++) {
        builder.methods.add(Method((mBuilder) => createAsyncMergeExtensionFunc(mBuilder, i, false, future, false)));
        builder.methods.add(Method((mBuilder) => createAsyncMergeExtensionFunc(mBuilder, i, true, future, false)));
        builder.methods.add(Method((mBuilder) => createAsyncMergeExtensionFunc(mBuilder, i, false, future, true)));
        builder.methods.add(Method((mBuilder) => createAsyncMergeExtensionFunc(mBuilder, i, true, future, true)));
      }
    });

    return '${extension.accept(emitter)}';
  }
}
