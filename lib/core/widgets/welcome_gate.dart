import 'package:flutter/widgets.dart';

/// Tells descendants whether the welcome (terminal) overlay is still visible,
/// so entrance animations can wait until the page is actually seen.
class WelcomeGate extends InheritedWidget {
  const WelcomeGate({super.key, required this.active, required super.child});

  final bool active;

  static bool isActive(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<WelcomeGate>()?.active ??
      false;

  @override
  bool updateShouldNotify(WelcomeGate oldWidget) => oldWidget.active != active;
}
