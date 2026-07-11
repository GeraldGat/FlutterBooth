import 'package:flutter/material.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/models/config/extensions/app_config_image_widgets.dart';
import 'package:flutterbooth/screens/settings/settings_fields.dart';

class WallpapersTab extends StatelessWidget {
  final AppConfig config;
  final ValueChanged<AppConfig> onChanged;

  const WallpapersTab({super.key, required this.config, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        buildImageField(
          "Main wallpaper",
          config.mainWallpaper(width: 80, height: 80),
          config.wallpaper.mainWallpaperPath,
          (v) => onChanged(config.copyWith(wallpaper: config.wallpaper.copyWith(mainWallpaperPath: v))),
        ),
        buildImageField(
          "Countdown 3",
          config.countdown3(width: 80, height: 80),
          config.wallpaper.countdown3Path,
          (v) => onChanged(config.copyWith(wallpaper: config.wallpaper.copyWith(countdown3Path: v))),
        ),
        buildImageField(
          "Countdown 2",
          config.countdown2(width: 80, height: 80),
          config.wallpaper.countdown2Path,
          (v) => onChanged(config.copyWith(wallpaper: config.wallpaper.copyWith(countdown2Path: v))),
        ),
        buildImageField(
          "Countdown 1",
          config.countdown1(width: 80, height: 80),
          config.wallpaper.countdown1Path,
          (v) => onChanged(config.copyWith(wallpaper: config.wallpaper.copyWith(countdown1Path: v))),
        ),
        buildImageField(
          "Capture",
          config.capture(width: 80, height: 80),
          config.wallpaper.capturePath,
          (v) => onChanged(config.copyWith(wallpaper: config.wallpaper.copyWith(capturePath: v))),
        ),
        buildImageField(
          "Result",
          config.result(width: 80, height: 80),
          config.wallpaper.resultPath,
          (v) => onChanged(config.copyWith(wallpaper: config.wallpaper.copyWith(resultPath: v))),
        ),
        buildImageField(
          "Gallery",
          config.gallery(width: 80, height: 80),
          config.wallpaper.galleryPath,
          (v) => onChanged(config.copyWith(wallpaper: config.wallpaper.copyWith(galleryPath: v))),
        ),
        buildImageField(
          "Collage",
          config.collage(width: 80, height: 80),
          config.wallpaper.collagePath,
          (v) => onChanged(config.copyWith(wallpaper: config.wallpaper.copyWith(collagePath: v))),
        ),
      ],
    );
  }
}
