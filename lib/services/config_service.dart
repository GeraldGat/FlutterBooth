import 'package:flutterbooth/models/config/app_config.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class ConfigService {
  static const String _fileName = "flutterbooth_config.json";

  Future<File> _getConfigFile() async {
    final dir = await getApplicationSupportDirectory();
    return File("${dir.path}/$_fileName");
  }

  Future<AppConfig> getConfig() async {
    final file = await _getConfigFile();

    if (!await file.exists()) return AppConfig();

    final content = await file.readAsString();
    final data = jsonDecode(content);

    return AppConfig.fromJson(data);
  }

  Future<void> saveConfig(AppConfig config) async {
    final file = await _getConfigFile();
    await file.writeAsString(jsonEncode(config.toJson()));
  }
}
