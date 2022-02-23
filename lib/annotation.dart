typedef SupplyFunc<T> = T Function();

class WithCopy {
  const WithCopy._();
}

const withCopy = WithCopy._();

class AssetClass {
  const AssetClass._();
}

const assetClass = AssetClass._();

class GenAsset {
  final String location;

  const GenAsset({required this.location});
}
