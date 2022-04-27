import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
// ignore: implementation_imports
import 'package:test_api/src/expect/async_matcher.dart';

import 'utils.dart';

final isRight = _EitherMatcher(true);
final isLeft = _EitherMatcher(false);

Matcher isRightWith(dynamic value) => _EitherMatcher(true, rightMatcher: wrapMatcher(value));
Matcher isLeftWith(dynamic value) => _EitherMatcher(false, leftMatcher: wrapMatcher(value));

class _EitherMatcher extends AsyncMatcher {
  final bool right;
  final Matcher? rightMatcher;
  final Matcher? leftMatcher;

  _EitherMatcher(this.right, {this.rightMatcher, this.leftMatcher});

  @override
  Description describe(Description description) {
    if (right) {
      description.add('Either should be right');

      rightMatcher.let((some) {
        description.add(' and should match ');
        some.describe(description);
      });
    } else {
      description.add('Either should be left');

      leftMatcher.let((some) {
        description.add(' and should match ');
        some.describe(description);
      });
    }

    return description;
  }

  Future<String?> match(dynamic matcher, dynamic value) async {
    String? result;
    if (matcher is AsyncMatcher) {
      result = await matcher.matchAsync(value) as String?;
    } else if (matcher is Matcher) {
      final matchState = {};
      if (matcher.matches(value, matchState)) return null;
      result = matcher.describeMismatch(value, StringDescription(), matchState, false).toString();
    }

    return result;
  }

  FutureOr<String?> _matchEither(Either either) {
    return either.consume(
      onRight: (value) {
        if (!right) return 'was not left ($value)';

        return match(rightMatcher, value);
      },
      onLeft: (value) {
        if (right) return 'was not right ($value)';

        return match(leftMatcher, value);
      },
    );
  }

  FutureOr<String?> _matchEitherFuture(EitherFuture either) {
    return either.consume(
      onRight: (value) {
        if (!right) return 'was not left ($value)';

        return match(rightMatcher, value);
      },
      onLeft: (value) {
        if (right) return 'was not right ($value)';

        return match(leftMatcher, value);
      },
    );
  }

  @override
  dynamic /*FutureOr<String>*/ matchAsync(item) {
    if (item is EitherFuture) return _matchEitherFuture(item);
    if (item is Either) return _matchEither(item);

    if (item is Future) {
      return item.then((item) {
        if (item is EitherFuture) return _matchEitherFuture(item);
        if (item is Either) return _matchEither(item);
      });
    }
  }
}
