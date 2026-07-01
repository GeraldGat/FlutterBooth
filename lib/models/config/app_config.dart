import 'package:flutterbooth/models/config/abstract_config.dart';
import 'package:flutterbooth/models/config/icon_config.dart';
import 'package:flutterbooth/models/config/settings_config.dart';
import 'package:flutterbooth/models/config/shortcut_config.dart';
import 'package:flutterbooth/models/config/text_config.dart';
import 'package:flutterbooth/models/config/wallpaper_config.dart';

class AppConfig implements Config {
  final SettingsConfig settings;
  final WallpaperConfig wallpaper;
  final IconConfig icons;
  final TextConfig texts;
  final ShortcutConfig shortcuts;

  const AppConfig({
    this.settings = const SettingsConfig(),
    this.wallpaper = const WallpaperConfig(),
    this.icons = const IconConfig(),
    this.texts = const TextConfig(),
    this.shortcuts = const ShortcutConfig(),
  });

  @override
  AppConfig copyWith({
    SettingsConfig? settings,
    WallpaperConfig? wallpaper,
    IconConfig? icons,
    TextConfig? texts,
    ShortcutConfig? shortcuts,
  }) {
    return AppConfig(
      settings: settings ?? this.settings,
      wallpaper: wallpaper ?? this.wallpaper,
      icons: icons ?? this.icons,
      texts: texts ?? this.texts,
      shortcuts: shortcuts ?? this.shortcuts,
    );
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
    settings: SettingsConfig.fromJson(json["settings"] ?? {}),
    wallpaper: WallpaperConfig.fromJson(json["wallpaper"] ?? {}),
    icons: IconConfig.fromJson(json["icons"] ?? {}),
    texts: TextConfig.fromJson(json["texts"] ?? {}),
    shortcuts: ShortcutConfig.fromJson(json["shortcuts"] ?? {}),
  );

  @override
  Map<String, Map<String, dynamic>> toJson() => {
    "settings": settings.toJson(),
    "wallpaper": wallpaper.toJson(),
    "icons": icons.toJson(),
    "texts": texts.toJson(),
    "shortcuts": shortcuts.toJson(),
  };
}