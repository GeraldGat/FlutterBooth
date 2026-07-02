import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigatePreviousIntent extends Intent {
  const NavigatePreviousIntent();
}

class NavigateNextIntent extends Intent {
  const NavigateNextIntent();
}

class ConfirmIntent extends Intent {
  const ConfirmIntent();
}

class SettingsIntent extends Intent {
  const SettingsIntent();
}

class FullscreenIntent extends Intent {
  const FullscreenIntent();
}

class ExitFullscreenIntent extends Intent {
  const ExitFullscreenIntent();
}

class FbKeyboardListener extends StatelessWidget {
  final Widget child;
  final Map<ShortcutActivator, Intent> shortcuts;

  const FbKeyboardListener({
    super.key,
    required this.child,
    required this.shortcuts,
  });

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        ...shortcuts,
        SingleActivator(LogicalKeyboardKey.f11): const FullscreenIntent(),
        SingleActivator(LogicalKeyboardKey.escape): const ExitFullscreenIntent(),
      },
      child: child,
    );
  }
}
