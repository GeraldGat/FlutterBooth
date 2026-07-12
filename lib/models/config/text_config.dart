import 'package:flutterbooth/models/config/abstract_config.dart';

class TextConfig implements Config {
  final String fontFamilyName;
  final String textColorHex;
  final String captureText;
  final double countdownFontSize;
  final double homeFontSize;

  const TextConfig({
    this.fontFamilyName = "Lemonada",
    this.textColorHex = "FF1F1F1F",
    this.captureText = "Smile",
    this.countdownFontSize = 100,
    this.homeFontSize = 40,
  });

  @override
  TextConfig copyWith({
    String? fontFamilyName,
    String? textColorHex,
    String? captureText,
    double? countdownFontSize,
    double? homeFontSize,
  }) {
    return TextConfig(
      fontFamilyName: fontFamilyName ?? this.fontFamilyName,
      textColorHex: textColorHex ?? this.textColorHex,
      captureText: captureText ?? this.captureText,
      countdownFontSize: countdownFontSize ?? this.countdownFontSize,
      homeFontSize: homeFontSize ?? this.homeFontSize,
    );
  }

  factory TextConfig.fromJson(Map<String, dynamic> json) => TextConfig(
    fontFamilyName: json["fontFamilyName"] ?? "Lemonada",
    textColorHex: json["textColorHex"] ?? "1F1F1F",
    captureText: json["captureText"] ?? "Smile",
    countdownFontSize: (json["countdownFontSize"] ?? 100).toDouble(),
    homeFontSize: (json["homeFontSize"] ?? 40).toDouble(),
  );

  @override
  Map<String, dynamic> toJson() => {
    "fontFamilyName": fontFamilyName,
    "textColorHex": textColorHex,
    "captureText": captureText,
    "countdownFontSize": countdownFontSize,
    "homeFontSize": homeFontSize,
  };
}