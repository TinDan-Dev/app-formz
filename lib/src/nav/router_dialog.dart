import 'dart:async';

import 'package:flutter/material.dart' hide Path;

import 'path.dart';

/// Route for dialogs pushed to the navigator.
class RouterDialogRoute<T> extends MaterialPageRoute<T> {
  /// The path that is appended to the parent route path.
  static const _dialogPath = Path.fromParts(['dialog']);

  /// The callback that is invoked when the route is popped.
  FutureOr<T?> Function()? returnCallback;

  RouterDialogRoute({
    required Path parentRoutePath,
    required WidgetBuilder builder,
    Object? arguments,
  }) : super(
          settings: RouteSettings(
            name: (parentRoutePath / _dialogPath).toString(),
            arguments: arguments,
          ),
          builder: builder,
        );

  @override
  Widget buildContent(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(await returnCallback?.call());

        return false;
      },
      child: super.buildContent(context),
    );
  }
}

/// Keeps the `returnCallback` up to date.
class DialogReturnScope<T> extends StatefulWidget {
  final Widget child;

  final FutureOr<T?> Function() onReturn;

  const DialogReturnScope({
    Key? key,
    required this.child,
    required this.onReturn,
  }) : super(key: key);

  @override
  _DialogReturnScopeState<T> createState() => _DialogReturnScopeState<T>();
}

class _DialogReturnScopeState<T> extends State<DialogReturnScope<T>> {
  RouterDialogRoute<T>? _route;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _route?.returnCallback = null;

    final modalRoute = ModalRoute.of(context);
    if (modalRoute is RouterDialogRoute<T>) {
      _route = modalRoute;
    } else {
      _route = null;
    }

    _route?.returnCallback = widget.onReturn;
  }

  @override
  void didUpdateWidget(DialogReturnScope<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(_route == null || _route == ModalRoute.of(context));

    if (_route != null) {
      _route?.returnCallback = widget.onReturn;
    } else {
      _route = null;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
