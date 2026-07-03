import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/models/config/app_config.dart';

void main() {
  group('ConfigService - serialization', () {
    test('saveConfig and loadConfig roundtrip preserves data', () async {
      final tempDir = Directory.systemTemp.createTempSync('config_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final jsonFile = File('${tempDir.path}/flutterbooth_config.json');
      final original = AppConfig(
        settings: const AppConfig().settings.copyWith(
              fileSavePath: '/custom/path/',
              homeText: 'Custom text',
            ),
        wallpaper: const AppConfig().wallpaper.copyWith(
              mainWallpaperPath: '/custom/bg.png',
            ),
      );

      jsonFile.writeAsStringSync(jsonEncode(original.toJson()));
      final content = jsonDecode(jsonFile.readAsStringSync());
      final restored = AppConfig.fromJson(content);

      expect(restored.settings.fileSavePath, '/custom/path/');
      expect(restored.settings.homeText, 'Custom text');
      expect(restored.wallpaper.mainWallpaperPath, '/custom/bg.png');
    });

    test('JSON file is written with correct content', () async {
      final tempDir = Directory.systemTemp.createTempSync('config_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final config = AppConfig(
        settings:
            const AppConfig().settings.copyWith(homeText: 'Write test'),
      );
      final jsonStr = jsonEncode(config.toJson());
      final jsonFile = File('${tempDir.path}/flutterbooth_config.json');
      jsonFile.writeAsStringSync(jsonStr);

      final parsed = jsonDecode(jsonFile.readAsStringSync());
      final loaded = AppConfig.fromJson(parsed);
      expect(loaded.settings.homeText, 'Write test');
    });

    test('default config JSON structure matches expected format', () {
      const config = AppConfig();
      final json = config.toJson();
      final jsonStr = jsonEncode(json);
      final decoded = jsonDecode(jsonStr);
      final restored = AppConfig.fromJson(decoded);

      expect(restored.settings.fileSavePath, config.settings.fileSavePath);
      expect(restored.settings.homeText, config.settings.homeText);
      expect(restored.wallpaper.mainWallpaperPath,
          config.wallpaper.mainWallpaperPath);
      expect(restored.icons.photoIconPath, config.icons.photoIconPath);
      expect(restored.texts.fontFamilyName, config.texts.fontFamilyName);
      expect(restored.shortcuts.enter, config.shortcuts.enter);
    });
  });
}
