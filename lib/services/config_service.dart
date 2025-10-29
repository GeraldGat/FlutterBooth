import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import '../models/app_config.dart';

class ConfigService {
  static const String _fileName = "flutterbooth_config.json";

  Future<File> _getConfigFile() async {
    final dir = await getApplicationCacheDirectory();
    return File("${dir.path}/$_fileName");
  }

  Future<AppConfig?> loadConfig() async {
    final file = await _getConfigFile();
    if (await file.exists()) {
      final content = await file.readAsString();
      final data = jsonDecode(content);
      return AppConfig.fromJson(data);
    }
    return null;
  }

  Future<AppConfig> getConfig() async {
    return await loadConfig() ?? AppConfig();
  }

  Future<void> saveConfig(AppConfig config) async {
    final file = await _getConfigFile();
    await file.writeAsString(jsonEncode(config.toJson()));
  }
}
