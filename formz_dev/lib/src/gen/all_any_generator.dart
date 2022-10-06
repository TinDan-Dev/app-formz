import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import 'package:source_gen/source_gen.dart';

import 'utils/type_resolver.dart';

const extension = '.any_mocks.dart';
const testUrl = 'package:flutter_test/flutter_test.dart';
const mockitoUrl = 'package:mockito/mockito.dart';

Builder builder(BuilderOptions options) => MockAnyBuilder();

class MockAnyBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => const {
        '.dart': ['.any_mocks.dart']
      };

  String getMockUrl(String path) {
    final file = p.basenameWithoutExtension(path);

    return '$file.mocks.dart';
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    if (!await buildStep.resolver.isLibrary(buildStep.inputId)) return;

    final lib = await buildStep.inputLibrary;
    final mocksUrl = getMockUrl(buildStep.inputId.path);

    final targets = <InterfaceType>[];

    for (final element in lib.topLevelElements) {
      for (final annotation in element.metadata) {
        if (annotation.element is! ConstructorElement) continue;
        final annotationClass = annotation.element!.enclosingElement3!.name;

        if (annotationClass == 'GenerateMocks') {
          final reader = ConstantReader(annotation.computeConstantValue()!);

          targets.addAll(reader.read('classes').listValue.map((e) => e.toTypeValue()).whereType<InterfaceType>());
        }
      }
    }

    if (targets.isEmpty) return;

    final resolver = await TypeResolver.create(buildStep);

    final library = Library((builder) {
      for (final target in targets) {
        final element = (target.element2.declaration as ClassElement);
        final visitor = _ModelVisitor(resolver);

        element.visitChildren(visitor);
        for (final supertype in element.allSupertypes) {
          supertype.element2.visitChildren(visitor);
        }

        final extension = Extension(
          (builder) => builder
            ..name = 'Mock${element.name}AllAnyExtension'
            ..on = refer('Mock${element.name}', mocksUrl)
            ..methods.addAll(visitor.methods),
        );

        builder.body.add(extension);
      }
    });

    final emitter = DartEmitter.scoped(useNullSafetySyntax: true);
    await buildStep.writeAsString(
      buildStep.inputId.changeExtension('.any_mocks.dart'),
      DartFormatter().format(library.accept(emitter).toString()),
    );
  }
}

class _ModelVisitor extends SimpleElementVisitor<void> {
  final TypeResolver resolver;

  final List<Method> methods;

  _ModelVisitor(this.resolver) : methods = [];

  Iterable<Parameter> parameter(MethodElement element) sync* {
    for (final param in element.parameters) {
      yield Parameter(
        (builder) => builder
          ..name = param.name
          ..named = true
          ..type = refer('Matcher', testUrl)
          ..defaultTo = Code.scope((a) => a(refer('anything', testUrl))),
      );
    }
  }

  Code body(MethodElement element) => Code.scope((a) {
        final argThat = a(refer('argThat', mockitoUrl));

        final buf = StringBuffer();
        buf.write('${element.name}(');

        for (final param in element.parameters) {
          if (param.isNamed) {
            buf.write('${param.name}: $argThat(${param.name}, named: \'${param.name}\'),');
          } else {
            buf.write('$argThat(${param.name}),');
          }
        }
        buf.write(')');

        return buf.toString();
      });

  @override
  void visitMethodElement(MethodElement element) {
    if (element.isPrivate ||
        element.isStatic ||
        element.isOperator ||
        element.parameters.isEmpty ||
        element.name == 'noSuchMethod') return;

    final name = '${element.name}AllAny';
    if (methods.any((e) => e.name == name)) return;

    final method = Method(
      (builder) => builder
        ..name = name
        ..returns = resolver(element.returnType, genericTypes: false)
        ..optionalParameters.addAll(parameter(element))
        ..body = body(element)
        ..lambda = true,
    );

    methods.add(method);
  }
}
