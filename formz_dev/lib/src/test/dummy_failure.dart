import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

class FakeFailure extends Failure with EquatableMixin {
  final int index;
  FakeFailure({
    this.index = 0,
    Object? cause,
    StackTrace? trace,
  }) : super(
          message: 'Test failure${index != 0 ? '' : ': $index'}',
          cause: cause,
          trace: trace,
        );

  @override
  List<Object?> get props => [index];
}
