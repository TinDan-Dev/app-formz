part of 'input.dart';

class InputIdentifier<T> extends Equatable {
  final Object _identifier;

  final bool ignoreMemory;

  const InputIdentifier(this._identifier, {this.ignoreMemory = false});

  const InputIdentifier.named(String name, {bool ignoreMemory = false}) : this(name, ignoreMemory: ignoreMemory);

  bool checkType(dynamic value) => value is T;

  @override
  List<Object?> get props => [_identifier];

  @override
  String toString() => 'Input[$T]: $_identifier';
}
