import 'package:flutter/material.dart';
import 'package:flutterbooth/models/config/app_config.dart';

extension AppConfigColors on AppConfig {
  Color get mainColor {
    return Color(int.parse("0xFF${settings.mainColorHex}"));
  }

  Color get accentColor {
    return Color(int.parse("0xFF${settings.accentColorHex}"));
  } 
  
  Color get textColor {
    return Color(int.parse("0xFF${texts.textColorHex}"));
  }
}