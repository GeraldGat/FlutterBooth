import 'package:flutter/material.dart';
import 'package:flutterbooth/models/app_config.dart';

extension AppConfigColors on AppConfig {
  Color get mainColor {
    return Color(int.parse("0xFF$mainColorHex"));
  }

  Color get accentColor {
    return Color(int.parse("0xFF$accentColorHex"));
  }Color get textColor {
    return Color(int.parse("0xFF$textColorHex"));
  }
}