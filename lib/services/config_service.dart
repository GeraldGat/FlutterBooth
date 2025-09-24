import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import '../models/app_config.dart';

class ConfigService {
  AppConfig? currentConfig;
  static const String _fileName = "config.json";

  static final ConfigService _instance = ConfigService._internal();

  factory ConfigService() {
    return _instance;
  }
  ConfigService._internal();

  Future<File> _getConfigFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/$_fileName");
  }

  Future<AppConfig?> loadConfig({bool forceReload = false}) async {
    if (currentConfig != null && forceReload == false) {
      return currentConfig;
    }

    final file = await _getConfigFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      final data = jsonDecode(content);
      currentConfig = AppConfig.fromJson(data);
      return currentConfig;
    }
    return null;
  }

  Future<void> saveConfig(AppConfig config) async {
    currentConfig = config;
    final file = await _getConfigFile();
    await file.writeAsString(jsonEncode(config.toJson()));
  }
}
