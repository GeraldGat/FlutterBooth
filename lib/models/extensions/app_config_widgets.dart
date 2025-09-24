import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbooth/models/app_config.dart';

extension AppConfigWidgets on AppConfig {
  Widget eventLogo({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(eventLogoPath, width: width, height: height, fit: fit);
  }

  Widget mainWallpaper({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(mainWallpaperPath, width: width, height: height, fit: fit);
  }

  Widget countdown3({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(countdown3Path, width: width, height: height, fit: fit);
  }

  Widget countdown2({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(countdown2Path, width: width, height: height, fit: fit);
  }

  Widget countdown1({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(countdown1Path, width: width, height: height, fit: fit);
  }

  Widget capture({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(capturePath, width: width, height: height, fit: fit);
  }

  Widget result({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(resultPath, width: width, height: height, fit: fit);
  }

  Widget gallery({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(galleryPath, width: width, height: height, fit: fit);
  }

  Widget collage({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return _buildImage(collagePath, width: width, height: height, fit: fit);
  }

  Widget photoIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(photoIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget galleryIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(galleryIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget collageIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(collageIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget backIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(backIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget printIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(printIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget removeIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(removeIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget closeIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(closeIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget prevIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(prevIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget nextIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(nextIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget _buildImage(String? path, {double? width, double? height, BoxFit fit = BoxFit.contain}) {
    if (path == null || path.isEmpty) return const Text("No image");
    if (path.startsWith("assets/")) {
      return Image.asset(path, width: width, height: height, fit: fit);
    }
    return Image.file(File(path), width: width, height: height, fit: fit);
  }

  Widget _buildSvg(String? path, {double? width, double? height, ColorFilter? colorFilter}) {
    if (path == null || path.isEmpty) return const Text("No icon");
    if (path.startsWith("assets/")) {
      return SvgPicture.asset(path, width: width, height: height, colorFilter: colorFilter);
    }
    return SvgPicture.file(File(path), width: width, height: height, colorFilter: colorFilter);
  }
}