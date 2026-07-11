import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbooth/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/services/logger/app_logger.dart';
import 'package:flutterbooth/services/logger/console_log_output.dart';
import 'package:flutterbooth/services/logger/file_log_output.dart';
import 'package:flutterbooth/widgets/fb_keyboard_listener.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDir = await getApplicationSupportDirectory();
  await AppLogger.init(
    outputs: [
      FileLogOutput(logDirectory: '${appDir.path}/logs'),
      ConsoleLogOutput(),
    ],
  );

  FlutterError.onError = (details) {
    AppLogger.e(
      '${details.exception.runtimeType}: ${details.exception}',
      details.exception,
      details.stack,
    );
    FlutterError.presentError(details);
  };

  ui.PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.e('${error.runtimeType}: $error', error, stack);
    return true;
  };

  await windowManager.ensureInitialized();

  final startFullscreen = Platform.environment.containsKey('FULLSCREEN');

  await windowManager.waitUntilReadyToShow(
    const WindowOptions(size: Size(1280, 720), center: true),
    () async {
      if (startFullscreen) {
        await windowManager.setFullScreen(true);
      }
      await windowManager.show();
      await windowManager.focus();
    },
  );

  runZonedGuarded(
    () => runApp(const ProviderScope(child: App())),
    (error, stack) {
      AppLogger.e('${error.runtimeType}: $error', error, stack);
    },
  );
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