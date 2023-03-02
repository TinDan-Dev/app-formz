import 'package:flutter/material.dart';

mixin DelegatingChangeNotifier implements ChangeNotifier {
  @protected
  ChangeNotifier get notifier;

  @override
  void addListener(VoidCallback listener) => notifier.addListener(listener);

  @override
  void dispose() => notifier.dispose();

  @override
  bool get hasListeners => notifier.hasListeners;

  @override
  void notifyListeners() => notifier.notifyListeners();

  @override
  void removeListener(VoidCallback listener) => notifier.removeListener(listener);
}
