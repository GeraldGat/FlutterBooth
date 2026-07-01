import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterbooth/models/config/app_config.dart';

extension AppConfigImageWidgets on AppConfig {
  Widget eventLogo({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(settings.eventLogoPath, width: width, height: height, fit: fit);
  }

  Widget mainWallpaper({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(wallpaper.mainWallpaperPath, width: width, height: height, fit: fit);
  }

  Widget countdown3({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(wallpaper.countdown3Path ?? wallpaper.mainWallpaperPath, width: width, height: height, fit: fit);
  }

  Widget countdown2({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(wallpaper.countdown2Path ?? wallpaper.mainWallpaperPath, width: width, height: height, fit: fit);
  }

  Widget countdown1({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(wallpaper.countdown1Path ?? wallpaper.mainWallpaperPath, width: width, height: height, fit: fit);
  }

  Widget capture({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(wallpaper.capturePath ?? wallpaper.mainWallpaperPath, width: width, height: height, fit: fit);
  }

  Widget result({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(wallpaper.resultPath ?? wallpaper.mainWallpaperPath, width: width, height: height, fit: fit);
  }

  Widget gallery({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(wallpaper.galleryPath ?? wallpaper.mainWallpaperPath, width: width, height: height, fit: fit);
  }

  Widget collage({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(wallpaper.collagePath ?? wallpaper.mainWallpaperPath, width: width, height: height, fit: fit);
  }

  Widget _buildImage(String? path, {double? width, double? height, BoxFit fit = BoxFit.contain}) {
    if (path == null || path.isEmpty) return const Text("No image");
    if (path.startsWith("assets/")) {
      return Image.asset(path, width: width, height: height, fit: fit);
    }
    return Image.file(File(path), width: width, height: height, fit: fit);
  }
}