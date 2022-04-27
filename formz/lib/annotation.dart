typedef SupplyFunc<T> = T Function();

class AssetClass {
  const AssetClass._();
}

const assetClass = AssetClass._();

class GenAsset {
  final String location;

  const GenAsset({required this.location});
}

class GenerateAllAny {
  final List<Type> classes;

  const GenerateAllAny(this.classes);
}
