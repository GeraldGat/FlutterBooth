import 'package:flutterbooth/models/config/abstract_config.dart';

class TextConfig implements Config {
  final String fontFamilyName;
  final String textColorHex;
  final String captureText;

  const TextConfig({
    this.fontFamilyName = "Lemonada",
    this.textColorHex = "FF1F1F1F",
    this.captureText = "Smile",
  });

  @override
  TextConfig copyWith({
    String? fontFamilyName,
    String? textColorHex,
    String? captureText,
  }) {
    return TextConfig(
      fontFamilyName: fontFamilyName ?? this.fontFamilyName,
      textColorHex: textColorHex ?? this.textColorHex,
      captureText: captureText ?? this.captureText,
    );
  }

  factory TextConfig.fromJson(Map<String, dynamic> json) => TextConfig(
    fontFamilyName: json["fontFamilyName"] ?? "Lemonada",
    textColorHex: json["textColorHex"] ?? "1F1F1F",
    captureText: json["captureText"] ?? "Smile",
  );

  @override
  Map<String, dynamic> toJson() => {
    "fontFamilyName": fontFamilyName,
    "textColorHex": textColorHex,
    "captureText": captureText,
  };
}