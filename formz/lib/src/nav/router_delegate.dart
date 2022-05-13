import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Path;

import '../utils/extensions.dart';
import 'path.dart';
import 'router_arguments.dart';
import 'router_dialog.dart';

typedef OnPathBuilder = Widget Function(BuildContext context, Widget child);

/// A named page, used by the [FormzRouterDelegate].
/// ignore: must_be_immutable
class FormzRouterPage<T> extends Page<T> {
  /// Stores a reference to the current route.
  Route<T>? route;

  /// Builds the [Widget] for this page.
  final WidgetBuilder builder;

  /// The path of the current route.
  final Path path;

  /// The arguments for this page.
  ///
  /// This just casts the default arguments attribute.
  Arguments get pageArguments => arguments as Arguments;

  FormzRouterPage({
    required this.path,
    required this.builder,
    Arguments? arguments,
  }) : super(
          name: path.toString(),
          arguments: arguments ?? Arguments.empty,
          key: ValueKey(path),
        );

  @override
  Route<T> createRoute(BuildContext context) {
    route = MaterialPageRoute(
      builder: builder,
      settings: this,
    );

    return route!;
  }
}

class FormzRouterDelegate with ChangeNotifier {
  /// The current state of the router.
  final List<FormzRouterPage> _pages;
  final List<NavigatorObserver> _observer;

  /// Keeps track of the scheduled action.
  ///
  /// There can only every be on action scheduled at once.
  void Function(FormzRouterDelegate delegate)? _scheduledAction;

  /// Flags for the router state.
  bool _navigationBlocked;
  bool _transactionInProgress;
  bool _transactionDirty;

  /// The global key to access the [NavigatorState] of the [Navigator] that is
  /// currently using this delegate.
  final GlobalKey<NavigatorState> navigatorKey;

  /// A map of all possible routes and the associated builder function.
  final Map<Path, WidgetBuilder> routes;

  /// Widgets that are build on a specific path.
  final List<Map<Path, OnPathBuilder>> onPaths;

  /// The current page stack.
  List<FormzRouterPage> get pages => List.unmodifiable(_pages);

  /// The name of the current route.
  Path get currentPath => _pages.last.path;

  /// The [Route] attached  current to the page.
  FormzRouterPage get currentPage => _pages.last;

  FormzRouterDelegate({
    required this.routes,
    this.onPaths = const [],
    Path initialPath = Path.root,
  })  : _pages = [],
        _observer = [],
        _navigationBlocked = false,
        _transactionInProgress = false,
        _transactionDirty = false,
        navigatorKey = GlobalKey(debugLabel: 'router_navigator') {
    _pages.add(_pageFromRoute(initialPath));
  }

  /// Whether the navigation is currently blocked.
  ///
  /// The navigation can be blocked and unblocked with [blockNavigation].
  bool get isNavigationBlocked => _navigationBlocked;

  /// Blocks or unblocks the navigation.
  ///
  /// If the navigation is block all navigation functions will return false and
  /// do nothing until the navigation is unblocked again.
  set blockNavigation(bool value) {
    assert(!_transactionInProgress || !value, 'Cannot block navigation during a transaction');

    _navigationBlocked = value;
  }

  /// Helper function to create a page from a route.
  FormzRouterPage _pageFromRoute(Path path, {Arguments? arguments}) {
    assert(routes.containsKey(path), '$path is not a known route');

    return FormzRouterPage(
      path: path,
      builder: (context) => routes[path]!(context),
      arguments: arguments,
    );
  }

  /// Helper function that checks the transaction state before deciding whether
  /// to call notifyListeners.
  void _transactionSafeNotify() {
    if (_transactionInProgress) {
      _transactionDirty = true;
    } else {
      notifyListeners();
    }
  }

  /// Helper function that determines whether it is necessary to pop the entire
  /// app or not. Returns whether there are no pages left to pop, when there are
  /// no pages left, the entire app should be popped.
  Future<bool> shouldPopApp() async {
    if (_navigationBlocked) return false;

    final shouldPopNav = currentPage.route.fold(
      () => false,
      (some) => !some.isCurrent,
    );

    if (shouldPopNav) {
      return false;
    }
    if (_pages.length == 1) {
      final result = await _pages[0].route?.willPop() ?? RoutePopDisposition.bubble;
      return result != RoutePopDisposition.doNotPop;
    }

    return false;
  }

  /// Pops the current page from the page stack.
  ///
  /// If the current page is not at the top of the current route, the navigator
  /// assumes that another route is on top of it. Thus the pop call is forwarded
  /// to the standard navigator. If only one page is left, the call is ignored and
  /// false is returned. Returns true if the pop was successful.
  ///
  /// If the navigation is currently block, the call is ignored and returns false.
  bool pop() {
    if (_navigationBlocked) return false;

    final shouldPopNav = currentPage.route.fold(
      () => false,
      (some) => !some.isCurrent,
    );

    if (shouldPopNav) {
      return navigatorKey.currentState.fold(() => false, (some) {
        some.pop();
        return true;
      });
    }

    if (_pages.length <= 1) return false;

    _pages.removeLast();
    _transactionSafeNotify();

    return true;
  }

  ///{@macro nav_popTill}
  bool popTillNamed(String path) => popTill(Path(path));

  /// {@template nav_popTill}
  /// Pops the current page till a page with the [path] was found or only one
  /// page is left.
  ///
  /// If anything was pushed to the standard navigator it will be ignored and
  /// will be removed as well. Returns true if a page with the name was found.
  ///
  /// If the navigation is currently block, the call is ignored and returns false.
  /// {@endtemplate}
  bool popTill(Path path) {
    if (_navigationBlocked) return false;

    final previousStackSize = _pages.length;

    while (_pages.length > 1 && _pages.last.path != path) {
      _pages.removeLast();
    }

    if (previousStackSize != _pages.length) {
      _transactionSafeNotify();
    }

    return _pages.last.path == path;
  }

  /// {@macro nav_push}
  bool pushNamed(List<String> stack, {Arguments? argument, List<Arguments>? arguments}) =>
      push(stack.map((e) => Path(e)).toList(), argument: argument, arguments: arguments);

  /// {@template nav_push}
  /// Pushes a page stack on top of the current page stack.
  ///
  /// An [argument] for the top most page can be supplied or [arguments] for
  /// all pages. But the [arguments] list needs to have the same length as the
  /// pages [stack] and either [argument] or [arguments] needs to be null.
  ///
  /// Returns true when the request could be executed successfully. If the
  /// navigation is currently block, the call is ignored and returns false.
  /// {@endtemplate}
  bool push(List<Path> stack, {Arguments? argument, List<Arguments>? arguments}) {
    if (_navigationBlocked) return false;

    assert(argument == null || arguments == null, 'argument and arguments can not both be not null');
    assert(arguments == null || arguments.length == stack.length, 'arguments and stack have to be the same length');

    if (argument != null) {
      for (int i = 0; i < stack.length - 1; i++) {
        _pages.add(_pageFromRoute(stack[i]));
      }

      _pages.add(_pageFromRoute(stack.last, arguments: argument));
    } else if (arguments != null) {
      for (int i = 0; i < stack.length; i++) {
        _pages.add(_pageFromRoute(stack[i], arguments: arguments[i]));
      }
    } else {
      for (int i = 0; i < stack.length; i++) {
        _pages.add(_pageFromRoute(stack[i]));
      }
    }

    _transactionSafeNotify();

    return true;
  }

  /// {@macro nav_replace}
  bool replaceNamed(List<String> stack, {Arguments? argument, List<Arguments>? arguments}) =>
      replace(stack.map((e) => Path(e)).toList(), argument: argument, arguments: arguments);

  /// {@template nav_replace}
  /// Replaces the current page stack with a new [stack]. The arguments are
  /// forwarded to [push].
  ///
  /// If the navigation is currently block, the call is ignored and returns false.
  /// {@endtemplate}
  bool replace(List<Path> stack, {Arguments? argument, List<Arguments>? arguments}) {
    if (_navigationBlocked) return false;

    _pages.clear();
    return push(stack, argument: argument, arguments: arguments);
  }

  /// Starts a transaction.
  ///
  /// Changes during the transaction won't be commit until the transaction
  /// ends. If the transaction returns false, all changes will be discarded. If
  /// the navigation is disabled the [transaction] callback won't be called.
  void transaction(bool transaction()) {
    if (_navigationBlocked) return;

    assert(!_transactionInProgress, 'Nested transactions are not supported');
    _transactionInProgress = true;
    _transactionDirty = false;

    final oldPages = List<FormzRouterPage>.from(_pages);
    final result = transaction();

    if (result) {
      if (_transactionDirty) {
        notifyListeners();
      }
    } else {
      _pages.clear();
      _pages.addAll(oldPages);
    }

    _transactionInProgress = false;
  }

  /// Pushes a route on top of the current rout as a dialog and the return value
  /// can be set with the [DialogReturnScope].
  ///
  /// Dialogs are not support within transaction and if the navigation is
  /// currently block, the call is ignored and returns false.
  Future<T?> pushDialog<T>(WidgetBuilder builder, {Arguments? arguments}) async {
    assert(!_transactionInProgress, 'A dialog cannot be pushed during a transaction');

    if (_navigationBlocked) return null;

    final route = RouterDialogRoute<T>(
      parentRoutePath: _pages.last.path,
      arguments: arguments,
      builder: builder,
    );

    return navigatorKey.currentState.let<Future<T?>>((some) => some.push<T>(route));
  }

  /// Schedules a navigation action to be by executed later manually.
  ///
  /// Execute the navigation in side of the function, there is no granite that
  /// this action will be execute and it could be replaced before it gets executed.
  void scheduleNavigation(void action(FormzRouterDelegate delegate)) {
    _scheduledAction = action;
  }

  /// Executes the scheduled action.
  ///
  /// Actions can be scheduled with [scheduleNavigation]. Returns whether an
  /// action was executed or not.
  bool executeSchedule() {
    if (_navigationBlocked) return false;

    return _scheduledAction.fold(() => false, (some) {
      some(this);

      _scheduledAction = null;
      return true;
    });
  }

  /// Adds an observer to the navigator.
  void addObserver(NavigatorObserver observer) {
    assert(!_observer.contains(observer), 'This observer was already added');
    _observer.add(observer);
  }

  /// Removes an observer from the navigator.
  void removeObserver(NavigatorObserver observer) {
    assert(_observer.contains(observer), 'This observer was not added');
    _observer.remove(observer);
  }

  Widget _getWidgetsOnPath(BuildContext context, Widget child) {
    final builders = onPaths
        .map(
            (e) => e.entries.where((e) => e.key <= currentPath).sortedBy<num>((e) => -e.key.length).map((e) => e.value))
        .flattened;

    for (final builder in builders) {
      child = builder(context, child);
    }

    return child;
  }

  Widget build(BuildContext context) {
    final nav = Navigator(
      key: navigatorKey,
      observers: _observer,
      pages: List.unmodifiable(_pages),
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        pop();
        return true;
      },
    );

    return _getWidgetsOnPath(context, nav);
  }
}
