import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Flutterbooth',
      builder: (context, child) {
        return FbKeyboardListener(child: child ?? SizedBox.shrink());
      },
      home: HomeScreen(),
    );
  }
}