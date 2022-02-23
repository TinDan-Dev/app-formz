part of 'input.dart';

class InputIdentifier<T> extends Equatable {
  final Object _identifier;

  const InputIdentifier(this._identifier);

  const InputIdentifier.named(String name) : this(name);

  bool checkType(dynamic value) => value is T;

  @override
  List<Object?> get props => [_identifier];

  @override
  String toString() => 'Input[$T] id: $_identifier';
}
