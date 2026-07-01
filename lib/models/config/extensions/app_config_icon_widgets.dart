import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbooth/models/config/app_config.dart';

extension AppConfigIconWidgets on AppConfig {
  Widget photoIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(icons.photoIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget galleryIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(icons.galleryIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget collageIcon({double? width, double? height,  ColorFilter? colorFilter}) {
    return _buildSvg(icons.collageIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget backIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(icons.backIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget printIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(icons.printIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget removeIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(icons.removeIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget closeIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(icons.closeIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget prevIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(icons.prevIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget nextIcon({double? width, double? height, ColorFilter? colorFilter}) {
    return _buildSvg(icons.nextIconPath, width: width, height: height, colorFilter: colorFilter);
  }

  Widget _buildSvg(String? path, {double? width, double? height, ColorFilter? colorFilter}) {
    if (path == null || path.isEmpty) return const Text("No icon");
    if (path.startsWith("assets/")) {
      return SvgPicture.asset(path, width: width, height: height, colorFilter: colorFilter);
    }
    return SvgPicture.file(File(path), width: width, height: height, colorFilter: colorFilter);
  }
}