import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterbooth/providers/config_provider.dart';

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

class FbKeyboardListener extends ConsumerWidget {
  final Widget child;
  
  const FbKeyboardListener({super.key, required this.child});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncConfig = ref.watch(configProvider);
    
    return asyncConfig.when(
      data: (config) => Shortcuts(
        shortcuts: <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey(config.shortcutPrevLogicalKeyId)): const NavigatePreviousIntent(),
          SingleActivator(LogicalKeyboardKey(config.shortcutNextLogicalKeyId)): const NavigateNextIntent(),
          SingleActivator(LogicalKeyboardKey(config.shortcutEnterLogicalKeyId)): const ConfirmIntent(),
          SingleActivator(LogicalKeyboardKey(config.shortcutSettingsLogicalKeyId)): const SettingsIntent(),
          SingleActivator(LogicalKeyboardKey.f11): const FullscreenIntent(),
          SingleActivator(LogicalKeyboardKey.escape): const ExitFullscreenIntent(),
        },
        child: child,
      ),
      loading: () => child, // Afficher sans shortcuts pendant le chargement
      error: (_, __) => child, // Afficher sans shortcuts en cas d'erreur
    );
  }
}