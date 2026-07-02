import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbooth/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/widgets/fb_keyboard_listener.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncConfig = ref.watch(configProvider);

    return MaterialApp(
      title: 'Flutterbooth',
      builder: (context, child) {
        return asyncConfig.when(
          data: (config) => FbKeyboardListener(
            shortcuts: {
              SingleActivator(LogicalKeyboardKey(config.shortcuts.prev)):
                  const NavigatePreviousIntent(),
              SingleActivator(LogicalKeyboardKey(config.shortcuts.next)):
                  const NavigateNextIntent(),
              SingleActivator(LogicalKeyboardKey(config.shortcuts.enter)):
                  const ConfirmIntent(),
              SingleActivator(LogicalKeyboardKey(config.shortcuts.settings)):
                  const SettingsIntent(),
            },
            child: child ?? SizedBox.shrink(),
          ),
          loading: () => child ?? SizedBox.shrink(),
          error: (_, __) => child ?? SizedBox.shrink(),
        );
      },
      home: HomeScreen(),
    );
  }
}