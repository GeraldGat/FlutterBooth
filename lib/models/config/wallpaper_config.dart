import 'package:flutterbooth/models/config/abstract_config.dart';

class WallpaperConfig implements Config {
  final String mainWallpaperPath;
  final String? countdown3Path;
  final String? countdown2Path;
  final String? countdown1Path;
  final String? capturePath;
  final String? resultPath;
  final String? galleryPath;
  final String? collagePath;

  const WallpaperConfig({
    this.mainWallpaperPath = "assets/images/photobooth_background.png",
    this.countdown3Path,
    this.countdown2Path,
    this.countdown1Path,
    this.capturePath,
    this.resultPath,
    this.galleryPath,
    this.collagePath,
  });

  @override
  WallpaperConfig copyWith({
    String? mainWallpaperPath,
    String? countdown3Path,
    String? countdown2Path,
    String? countdown1Path,
    String? capturePath,
    String? resultPath,
    String? galleryPath,
    String? collagePath,
  }) {
    return WallpaperConfig(
      mainWallpaperPath: mainWallpaperPath ?? this.mainWallpaperPath,
      countdown3Path: countdown3Path ?? this.countdown3Path,
      countdown2Path: countdown2Path ?? this.countdown2Path,
      countdown1Path: countdown1Path ?? this.countdown1Path,
      capturePath: capturePath ?? this.capturePath,
      resultPath: resultPath ?? this.resultPath,
      galleryPath: galleryPath ?? this.galleryPath,
      collagePath: collagePath ?? this.collagePath,
    );
  }

  factory WallpaperConfig.fromJson(Map<String, dynamic> json) => WallpaperConfig(
    mainWallpaperPath: json["mainWallpaperPath"] ?? "assets/images/photobooth_background.png",
    countdown3Path: json["countdown3Path"],
    countdown2Path: json["countdown2Path"],
    countdown1Path: json["countdown1Path"],
    capturePath: json["capturePath"],
    resultPath: json["resultPath"],
    galleryPath: json["galleryPath"],
    collagePath: json["collagePath"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "mainWallpaperPath": mainWallpaperPath,
    "countdown3Path": countdown3Path,
    "countdown2Path": countdown2Path,
    "countdown1Path": countdown1Path,
    "capturePath": capturePath,
    "resultPath": resultPath,
    "galleryPath": galleryPath,
    "collagePath": collagePath,
  };
}