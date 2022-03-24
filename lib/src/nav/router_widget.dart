import 'package:flutter/material.dart';

import '../utils/extensions.dart';
import 'router_delegate.dart';

/// Adds a navigator to the tree that is controlled by the [delegate].
///
/// All navigation actions should be executed using the delegate.
class FormzRouterWidget extends StatefulWidget {
  /// The delegate that handles the navigation.
  final FormzRouterDelegate delegate;

  const FormzRouterWidget({required this.delegate, Key? key}) : super(key: key);

  @override
  State<FormzRouterWidget> createState() => _FormzRouterWidgetState();
}

class _FormzRouterWidgetState extends State<FormzRouterWidget> {
  void _onChangedCallback() {
    // rebuild the widget on route change
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.delegate.addListener(_onChangedCallback);
  }

  @override
  void dispose() {
    super.dispose();
    widget.delegate.removeListener(_onChangedCallback);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.delegate.isNavigationBlocked) return false;
        if (await widget.delegate.shouldPopApp()) return true;

        final shouldPopNav = widget.delegate.currentRoute.fold(
          () => false,
          (some) => !some.isCurrent,
        );

        if (shouldPopNav) {
          await widget.delegate.navigatorKey.currentState?.maybePop();
        } else {
          widget.delegate.pop();
        }

        return false;
      },
      child: widget.delegate.build(context),
    );
  }
}
