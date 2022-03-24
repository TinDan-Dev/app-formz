import 'package:flutter/material.dart' hide Path;
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/src/nav/path.dart';
import 'package:formz/src/nav/router_delegate.dart';

Matcher stackMatches(List<String> stack) => StackMatcher(stack);

class StackMatcher extends Matcher {
  final List<String> stack;

  const StackMatcher(this.stack);

  @override
  Description describe(Description description) {
    description.add('expected stack: $stack');

    return description;
  }

  @override
  bool matches(item, Map matchState) {
    if (item is FormzRouterDelegate) {
      final actualStack = item.pages.map((e) => e.name).toList();
      if (actualStack.length != stack.length) return false;

      for (var i = 0; i < actualStack.length; i++) {
        if (actualStack[i] != stack[i]) return false;
      }

      return true;
    }

    return false;
  }
}

class ChangeNotifierTest {
  final int count;
  final ChangeNotifier notifier;

  int _counter = 0;

  ChangeNotifierTest({
    this.count = 1,
    required this.notifier,
  }) {
    notifier.addListener(_increment);
  }

  void _increment() => _counter++;

  void verify() {
    assert(
      _counter == count,
      'expected $count invokes, but was invoked $_counter',
    );
  }
}

void main() {
  late FormzRouterDelegate delegate;

  final Map<Path, WidgetBuilder> routes = {
    Path('/'): (_) => const SizedBox.shrink(),
    Path('/route1'): (_) => const SizedBox.shrink(),
    Path('/route2'): (_) => const SizedBox.shrink(),
    Path('/route3'): (_) => const SizedBox.shrink(),
  };

  setUp(() {
    delegate = FormzRouterDelegate(routes: routes);
  });

  group('constructor', () {
    test(
      'should throw an error if the initial route is not defined',
      () {
        // ignore: prefer_function_declarations_over_variables
        final test = () => FormzRouterDelegate(
              routes: routes,
              initialPath: Path('/notDefined'),
            );

        expect(test, throwsA(anything));
      },
    );

    test(
      'should set the initial route and create the stack with the initial route',
      () {
        final result = FormzRouterDelegate(
          routes: routes,
          initialPath: Path('/route1'),
        );

        expect(result.currentPath.toString(), equals('/route1'));
        expect(result, stackMatches(['/route1']));
      },
    );

    test(
      'should set the initial route to \'/\' and create the stack with the initial route when no initialRoute is passed in',
      () {
        final result = FormzRouterDelegate(routes: routes);

        expect(result.currentPath.toString(), equals('/'));
        expect(result, stackMatches(['/']));
      },
    );
  });

  group('push', () {
    test(
      'should throw an error when one route is not defined',
      () {
        // ignore: prefer_function_declarations_over_variables
        final test = () => delegate.pushNamed(['/notDefined']);

        expect(test, throwsA(anything));
      },
    );

    test(
      'should not notify listeners when not successful',
      () {
        final test = ChangeNotifierTest(count: 0, notifier: delegate);

        try {
          delegate.pushNamed(['/notDefined']);
        } catch (_) {}
        test.verify();
      },
    );

    test(
      'should add the route at the top of the stack when one route is passed in',
      () {
        delegate.pushNamed(['/route1']);

        expect(delegate.currentPath.toString(), equals('/route1'));
        expect(delegate, stackMatches(['/', '/route1']));
      },
    );

    test(
      'should add the all routes in order at the top of the stack when multiple routes are passed in',
      () {
        delegate.pushNamed(['/route1', '/route2']);

        expect(delegate.currentPath.toString(), equals('/route2'));
        expect(delegate, stackMatches(['/', '/route1', '/route2']));
      },
    );

    test(
      'should notify listeners when successful',
      () {
        final test = ChangeNotifierTest(notifier: delegate);

        delegate.pushNamed(['/route1']);

        test.verify();
      },
    );
  });

  group('replace', () {
    test(
      'should throw an error when one route is not defined',
      () {
        final test = () => delegate.replaceNamed(['/notDefined']);

        expect(test, throwsA(anything));
      },
    );

    test(
      'should not notify listeners when not successful',
      () {
        final test = ChangeNotifierTest(count: 0, notifier: delegate);

        try {
          delegate.replaceNamed(['/notDefined']);
        } catch (_) {}

        test.verify();
      },
    );

    test(
      'should replace the current page stack with the route when one route is passed in',
      () {
        delegate.replaceNamed(['/route1']);

        expect(delegate.currentPath.toString(), equals('/route1'));
        expect(delegate, stackMatches(['/route1']));
      },
    );

    test(
      'should replace the current page stack with the routes when multiple routes are passed in',
      () {
        delegate.replaceNamed(['/route1', '/route2']);

        expect(delegate.currentPath.toString(), equals('/route2'));
        expect(delegate, stackMatches(['/route1', '/route2']));
      },
    );

    test(
      'should notify listeners when successful',
      () {
        final test = ChangeNotifierTest(notifier: delegate);

        delegate.replaceNamed(['/route1']);

        test.verify();
      },
    );
  });

  group('pop', () {
    test(
      'should return false when only one route is left, but should not clear the stack',
      () {
        final result = delegate.pop();

        expect(result, isFalse);
        expect(delegate.currentPath.toString(), equals('/'));
        expect(delegate, stackMatches(['/']));
      },
    );

    test(
      'should not notify listeners when only one route is left',
      () {
        final test = ChangeNotifierTest(count: 0, notifier: delegate);

        delegate.pop();
        test.verify();
      },
    );

    test(
      'should return true and remove the top route when multiple routes are left',
      () {
        delegate.pushNamed(['/route1', '/route2', '/route3']);
        final result = delegate.pop();

        expect(result, isTrue);
        expect(delegate.currentPath.toString(), equals('/route2'));
        expect(delegate, stackMatches(['/', '/route1', '/route2']));
      },
    );

    test(
      'should notify listeners when multiple routes are left',
      () {
        delegate.pushNamed(['/route1', '/route2', '/route3']);

        final test = ChangeNotifierTest(notifier: delegate);

        delegate.pop();

        test.verify();
      },
    );
  });

  group('popTill', () {
    test(
      'should return true when the current route matches',
      () {
        final result = delegate.popTillNamed('/');

        expect(result, isTrue);
        expect(delegate.currentPath.toString(), equals('/'));
        expect(delegate, stackMatches(['/']));
      },
    );

    test(
      'should not notify listeners when the current route matches',
      () {
        final test = ChangeNotifierTest(count: 0, notifier: delegate);

        delegate.popTillNamed('/');

        test.verify();
      },
    );

    test(
      'should return false when only one route is left, but should not clear the stack',
      () {
        final result = delegate.popTillNamed('/this/route/does/not/exist');

        expect(result, isFalse);
        expect(delegate.currentPath.toString(), equals('/'));
        expect(delegate, stackMatches(['/']));
      },
    );

    test(
      'should not notify listeners when only one route is left',
      () {
        final test = ChangeNotifierTest(count: 0, notifier: delegate);

        delegate.popTillNamed('/this/route/does/not/exist');

        test.verify();
      },
    );

    test(
      'should return true and remove the route that do not match when multiple routes are present',
      () {
        delegate.pushNamed(['/route1', '/route2', '/route3']);
        final result = delegate.popTillNamed('/route2');

        expect(result, isTrue);
        expect(delegate.currentPath.toString(), equals('/route2'));
        expect(delegate, stackMatches(['/', '/route1', '/route2']));
      },
    );

    test(
      'should return true and remove the route that do not match when multiple routes are present',
      () {
        delegate.pushNamed(['/route1', '/route2', '/route3']);
        final result = delegate.popTillNamed('/route1');

        expect(result, isTrue);
        expect(delegate.currentPath.toString(), equals('/route1'));
        expect(delegate, stackMatches(['/', '/route1']));
      },
    );

    test(
      'should notify listeners when the stack changed',
      () {
        delegate.pushNamed(['/route1', '/route2', '/route3']);

        final test = ChangeNotifierTest(notifier: delegate);

        delegate.popTillNamed('/route1');

        test.verify();
      },
    );

    test(
      'should pop till the rout route when no route matches',
      () {
        delegate.pushNamed(['/route1', '/route2', '/route3']);

        delegate.popTillNamed('x');

        expect(delegate.currentPath.toString(), equals('/'));
        expect(delegate, stackMatches(['/']));
      },
    );
  });
}
