import 'package:flutterbooth/models/config/abstract_config.dart';

class SettingsConfig implements Config {
  final String fileSavePath;
  final String eventLogoPath;
  final String homeText;
  final String mainColorHex;
  final String accentColorHex;
  final String? adminPassword;
  final String? gphotoPort;

  const SettingsConfig({
    this.fileSavePath = "saved/",
    this.eventLogoPath = "assets/images/photobooth_logo.png",
    this.homeText = "Use the button below",
    this.mainColorHex = "FF4E4E7B",
    this.accentColorHex = "994E4E7B",
    this.adminPassword,
    this.gphotoPort,
  });

  @override
  SettingsConfig copyWith({
    String? fileSavePath,
    String? eventLogoPath,
    String? homeText,
    String? mainColorHex,
    String? accentColorHex,
    String? adminPassword,
    String? gphotoPort,
  }) {
    return SettingsConfig(
      fileSavePath: fileSavePath ?? this.fileSavePath,
      eventLogoPath: eventLogoPath ?? this.eventLogoPath,
      homeText: homeText ?? this.homeText,
      mainColorHex: mainColorHex ?? this.mainColorHex,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      adminPassword: adminPassword ?? this.adminPassword,
      gphotoPort: gphotoPort ?? this.gphotoPort,
    );
  }

  factory SettingsConfig.fromJson(Map<String, dynamic> json) => SettingsConfig(
    fileSavePath: json["fileSavePath"] ?? "saved/",
    eventLogoPath: json["eventLogoPath"] ?? "assets/images/photobooth_logo.png",
    homeText: json["homeText"] ?? "Use the button below",
    mainColorHex: json["mainColorHex"] ?? "FF4E4E7B",
    accentColorHex: json["accentColorHex"] ?? "994E4E7B",
    adminPassword: json["adminPassword"],
    gphotoPort: json["gphotoPort"],
  );

  @override
  Map<String, dynamic> toJson() => {
    "fileSavePath": fileSavePath,
    "eventLogoPath": eventLogoPath,
    "homeText": homeText,
    "mainColorHex": mainColorHex,
    "accentColorHex": accentColorHex,
    "adminPassword": adminPassword,
    "gphotoPort": gphotoPort,
  };
}