part of 'generic_input.dart';

typedef ErrorLocalFunc = String Function(BuildContext context);

class GenericInputError extends Equatable {
  static String Function(BuildContext context)? defaultLocalization;

  final List<Object> keys;
  final LocalFunc? _localize;

  const GenericInputError({
    required this.keys,
    LocalFunc? localize,
  }) : _localize = localize;

  String localize(BuildContext context) => _localize.fold(
        () => defaultLocalization?.call(context) ?? 'Could not localize error',
        (some) => some(context),
      );

  @override
  List<Object?> get props => [...keys, _localize];
}
