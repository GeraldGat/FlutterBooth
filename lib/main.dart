import 'package:flutter/material.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterbooth/widgets/fb_keyboard_listener.dart';

void main() async {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncConfig = ref.watch(configProvider);

    return asyncConfig.when(
      data: (config) => MaterialApp(
        title: 'Flutterbooth',
        builder: (context, child) {
          return FbKeyboardListener(child: child ?? SizedBox.shrink());
        },
        home: HomeScreen(config: config),
      ),
      loading: () => const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error loading config: $error')),
        ),
      ),
    );
  }
}