import 'dart:async';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:formz/annotation.dart';
import 'package:source_gen/source_gen.dart';

Builder builder(BuilderOptions options) => SharedPartBuilder([AssetGenerator()], 'asset');

class AssetGenerator extends GeneratorForAnnotation<AssetClass> {
  String getCodeName(String fileName) {
    final buf = StringBuffer();
    var nextUpper = true;
    for (int i = 0; i < fileName.length; i++) {
      var char = fileName.substring(i, i + 1);

      if (char == '_') {
        nextUpper = true;
        continue;
      }

      if (char == '.') break;

      if (nextUpper) {
        nextUpper = false;
        char = char.toUpperCase();
      }

      buf.write(char);
    }

    return buf.toString();
  }

  @override
  FutureOr<String> generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) async {
    final visitor = _ModelVisitor();
    element.visitChildren(visitor);

    final fieldsBuf = StringBuffer();

    for (final asset in visitor.assets) {
      final file = File(asset.location);

      fieldsBuf.write('const _\$${asset.fieldName} = ');

      switch (asset.type) {
        case _AssetType.string:
          fieldsBuf.write("r'''\n");
          fieldsBuf.write(await file.readAsString());
          fieldsBuf.write("''';\n");
          break;
        case _AssetType.bytes:
          fieldsBuf.write('[');

          for (final byte in await file.readAsBytes()) {
            fieldsBuf.write('$byte, ');
          }

          fieldsBuf.write('];\n');
          break;
      }
    }
    return fieldsBuf.toString();
  }
}

enum _AssetType {
  string,
  bytes,
}

class _AssetInfo {
  final String fieldName;
  final String location;
  final _AssetType type;

  _AssetInfo({
    required this.fieldName,
    required this.location,
    required this.type,
  });
}

class _ModelVisitor extends SimpleElementVisitor {
  List<_AssetInfo> assets = [];

  @override
  void visitFieldElement(FieldElement element) {
    final location = element.metadata
        .map((e) => e.computeConstantValue())
        .where((element) => element?.type?.getDisplayString(withNullability: false) == 'GenAsset')
        .map((e) => e?.getField('location')?.toStringValue())
        .where((e) => e != null)
        .firstWhere((e) => true, orElse: () => null);

    if (location == null) return;

    final _AssetType type;
    switch (element.type.getDisplayString(withNullability: false)) {
      case 'String':
        type = _AssetType.string;
        break;
      case 'List<int>':
        type = _AssetType.bytes;
        break;
      default:
        throw UnsupportedError('Unsupported type: ${element.type.getDisplayString(withNullability: false)}');
    }

    assets.add(_AssetInfo(fieldName: element.name, location: location, type: type));
  }
}
