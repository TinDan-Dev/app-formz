class GenGenericInput {
  const GenGenericInput._();
}

const genGenericInput = GenGenericInput._();

class OptionalInput {
  final bool generateOnlyOptional;

  const OptionalInput._(this.generateOnlyOptional);
}

const optionalInput = OptionalInput._(true);

const withOptionalInput = OptionalInput._(false);

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
