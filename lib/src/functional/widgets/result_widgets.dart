import '../result/result.dart';
import 'either_builder.dart';

typedef ResultBuilder<T> = EitherBuilder<Failure, T>;
