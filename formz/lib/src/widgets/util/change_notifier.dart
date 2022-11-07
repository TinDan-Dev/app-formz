import 'package:flutter/material.dart';

bool _defaultUnsubscribe(_) => true;

class ChangeNotifierWidget<T extends ChangeNotifier> extends StatefulWidget {
  final T notifier;
  final Widget Function(BuildContext context) builder;
  final bool Function(T notifier) unsubscribe;

  ChangeNotifierWidget({
    required this.notifier,
    required this.builder,
    this.unsubscribe = _defaultUnsubscribe,
  }) : super(key: ObjectKey(notifier));

  @override
  _ChangeNotifierWidgetState createState() => _ChangeNotifierWidgetState<T>();
}

class _ChangeNotifierWidgetState<T extends ChangeNotifier> extends State<ChangeNotifierWidget<T>> {
  T? notifier;

  void _onNotify() => setState(() {});

  void _subscribe() {
    widget.notifier.addListener(_onNotify);
    notifier = widget.notifier;
  }

  void _unsubscribe() {
    final notifier = this.notifier;

    if (notifier != null && widget.unsubscribe(notifier)) {
      notifier.removeListener(_onNotify);
    }

    this.notifier = null;
  }

  @override
  void initState() {
    _subscribe();

    super.initState();
  }

  @override
  void didUpdateWidget(covariant ChangeNotifierWidget<T> oldWidget) {
    if (notifier != oldWidget.notifier) {
      _unsubscribe();
      _subscribe();
      _onNotify();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  @override
  void dispose() {
    _unsubscribe();

    super.dispose();
  }
}
