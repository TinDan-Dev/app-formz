import 'dart:collection';

import 'package:analyzer/dart/element/element.dart' as analyzer;
import 'package:analyzer/dart/element/type.dart' as analyzer;
import 'package:analyzer/dart/element/type_system.dart' as analyzer;
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';

class TypeResolver {
  static Future<TypeResolver> create(BuildStep step) async {
    final libraries = await step.resolver.libraries.toList();
    final library = await step.inputLibrary;

    return TypeResolver._(library.typeSystem, libraries);
  }

  final analyzer.TypeSystem typeSystem;
  final Iterable<analyzer.LibraryElement> inputLibraries;

  TypeResolver._(this.typeSystem, this.inputLibraries);

  Reference call(analyzer.DartType type, {bool forceNullable = false, bool genericTypes = true}) =>
      resolve(type, forceNullable: forceNullable, genericTypes: genericTypes);

  /// Create a reference for [type], properly referencing all attached types.
  ///
  /// If the type needs to be nullable, rather than matching the nullability of
  /// [type], use [forceNullable].
  ///
  /// This creates proper references for:
  /// * InterfaceTypes (classes, generic classes),
  /// * FunctionType parameters (like `void callback(int i)`),
  /// * type aliases (typedefs), both new- and old-style,
  /// * enums,
  /// * type variables.
  Reference resolve(analyzer.DartType type, {bool forceNullable = false, bool genericTypes = true}) {
    if (type is analyzer.InterfaceType) {
      return TypeReference((b) {
        b.symbol = type.element.name;
        b.isNullable = forceNullable || typeSystem.isPotentiallyNullable(type);
        b.url = _typeImport(type.element);
        if (genericTypes) {
          b.types.addAll(type.typeArguments.map(resolve));
        }
      });
    } else if (type is analyzer.FunctionType) {
      final alias = type.alias;
      if (alias == null || alias.element.isPrivate) {
        // [type] does not refer to a type alias, or it refers to a private type
        // alias; we must instead write out its signature.
        return FunctionType((b) {
          b
            ..isNullable = forceNullable || typeSystem.isPotentiallyNullable(type)
            ..returnType = resolve(type.returnType)
            ..requiredParameters.addAll(type.normalParameterTypes.map(resolve))
            ..optionalParameters.addAll(type.optionalParameterTypes.map(resolve));
          for (var parameter in type.namedParameterTypes.entries) {
            b.namedParameters[parameter.key] = resolve(parameter.value);
          }
          b.types.addAll(type.typeFormals.map(_typeParameterReference));
        });
      }
      return TypeReference((b) {
        b
          ..symbol = alias.element.name
          ..url = _typeImport(alias.element)
          ..isNullable = forceNullable || typeSystem.isNullable(type);
        for (var typeArgument in alias.typeArguments) {
          b.types.add(resolve(typeArgument));
        }
      });
    } else if (type is analyzer.TypeParameterType) {
      return TypeReference((b) {
        b
          ..symbol = type.element.name
          ..isNullable = forceNullable || typeSystem.isNullable(type);
      });
    } else {
      return Reference(type.getDisplayString(withNullability: false), _typeImport(type.element));
    }
  }

  /// Create a reference for [typeParameter], properly referencing all types
  /// in bounds.
  TypeReference _typeParameterReference(analyzer.TypeParameterElement typeParameter) {
    return TypeReference((b) {
      b.symbol = typeParameter.name;
      if (typeParameter.bound != null) {
        b.bound = resolve(typeParameter.bound!);
      }
    });
  }

  /// Returns the import URL for [element].
  ///
  /// For some types, like `dynamic` and type variables, this may return null.
  String? _typeImport(analyzer.Element? element) {
    if (element == null) return null;

    // For type variables, no import needed.
    if (element is analyzer.TypeParameterElement) return null;

    final elementLibrary = element.library;

    // For types like `dynamic`, return null; no import needed.
    if (elementLibrary == null) return null;

    if (elementLibrary.isInSdk && !elementLibrary.name.startsWith('dart._')) {
      // For public SDK libraries, just use the source URI.
      return elementLibrary.source.uri.toString();
    }
    return _findExportOf(element).source.uri.toString();
  }

  /// Returns a library which exports [element], selecting from the imports of
  /// [inputLibraries] (and all exported libraries).
  ///
  /// If [element] is not exported by any libraries in this set, then
  /// [element]'s declaring library is returned.
  analyzer.LibraryElement _findExportOf(analyzer.Element element) {
    final elementName = element.name;
    if (elementName == null) {
      return element.library!;
    }

    final libraries = Queue.of([
      for (final library in inputLibraries) ...library.importedLibraries,
    ]);

    for (final library in libraries) {
      if (library.exportNamespace.get(elementName) == element) {
        return library;
      }
    }
    return element.library!;
  }
}
