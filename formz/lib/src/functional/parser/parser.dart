import '../result/result.dart';

abstract class Parser<Source, Target> {
  const Parser();

  Result<Target> parse(Source source);

  Result<Target> call(Source source) => parse(source);
}
