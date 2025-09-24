import 'package:flutter/material.dart';
import 'package:flutterbooth/models/extensions/app_config_colors.dart';
import 'package:flutterbooth/screens/home_screen.dart';
import 'services/config_service.dart';
import 'models/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final loadedConfig = await ConfigService().loadConfig();
  final config = loadedConfig ?? AppConfig();

  runApp(App(config: config));
}

class App extends StatelessWidget {
  final AppConfig config;

  const App({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutterbooth',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: config.mainColor),
      ),
      home: HomeScreen(config: config),
    );
  }
}