class AppConfig {
  // Settings
  String fileSavePath;
  String eventLogoPath;
  String homeText;
  String mainColorHex;
  String accentColorHex;
  String? adminPassword;

  // Wallpapers
  String mainWallpaperPath;
  String? countdown3Path;
  String? countdown2Path;
  String? countdown1Path;
  String? capturePath;
  String? resultPath;
  String? galleryPath;
  String? collagePath;

  // Icons
  String photoIconPath;
  String galleryIconPath;
  String collageIconPath;
  String backIconPath;
  String printIconPath;
  String removeIconPath;
  String closeIconPath;
  String prevIconPath;
  String nextIconPath;

  // Texts
  String fontFamilyName;
  String textColorHex;
  String captureText;

  // Shortcuts
  int shortcutSettingsLogicalKeyId;
  int shortcutPrevLogicalKeyId;
  int shortcutNextLogicalKeyId;
  int shortcutEnterLogicalKeyId;

  AppConfig({
    this.fileSavePath = "saved/",
    this.eventLogoPath = "assets/images/photobooth_logo.png",
    this.homeText = "Use the button below",
    this.mainColorHex = "FF4E4E7B",
    this.accentColorHex = "994E4E7B",
    this.adminPassword,
    this.mainWallpaperPath = "assets/images/photobooth_background.png",
    this.countdown3Path,
    this.countdown2Path,
    this.countdown1Path,
    this.capturePath,
    this.resultPath,
    this.galleryPath,
    this.collagePath,
    this.photoIconPath = "assets/icons/camera-solid-full.svg",
    this.galleryIconPath = "assets/icons/images-solid-full.svg",
    this.collageIconPath = "assets/icons/table-cells-large-solid-full.svg",
    this.backIconPath = "assets/icons/back.svg",
    this.printIconPath = "assets/icons/print-solid-full.svg",
    this.removeIconPath = "assets/icons/trash-solid-full.svg",
    this.closeIconPath = "assets/icons/xmark-solid-full.svg",
    this.prevIconPath = "assets/icons/caret-left-solid-full.svg",
    this.nextIconPath = "assets/icons/caret-right-solid-full.svg",
    this.fontFamilyName = "Lemonada",
    this.textColorHex = "1F1F1F",
    this.captureText = "Smile",
    this.shortcutSettingsLogicalKeyId = 0x0010000080c, // F12
    this.shortcutPrevLogicalKeyId = 0x00000000070, // P
    this.shortcutNextLogicalKeyId = 0x0000000006e, // N
    this.shortcutEnterLogicalKeyId = 0x0010000000d, // Enter
  });

  AppConfig copyWith({
    String? fileSavePath,
    String? eventLogoPath,
    String? homeText,
    String? mainColorHex,
    String? accentColorHex,
    String? adminPassword,
    String? mainWallpaperPath,
    String? countdown3Path,
    String? countdown2Path,
    String? countdown1Path,
    String? capturePath,
    String? resultPath,
    String? galleryPath,
    String? collagePath,
    String? photoIconPath,
    String? galleryIconPath,
    String? collageIconPath,
    String? backIconPath,
    String? printIconPath,
    String? removeIconPath,
    String? closeIconPath,
    String? prevIconPath,
    String? nextIconPath,
    String? fontFamilyName,
    String? textColorHex,
    String? captureText,
    int? shortcutSettingsLogicalKeyId,
    int? shortcutPrevLogicalKeyId,
    int? shortcutNextLogicalKeyId,
    int? shortcutEnterLogicalKeyId,
  }) {
    return AppConfig(
      fileSavePath: fileSavePath ?? this.fileSavePath,
      eventLogoPath: eventLogoPath ?? this.eventLogoPath,
      homeText: homeText ?? this.homeText,
      mainColorHex: mainColorHex ?? this.mainColorHex,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      adminPassword: adminPassword ?? this.adminPassword,
      mainWallpaperPath: mainWallpaperPath ?? this.mainWallpaperPath,
      countdown3Path: countdown3Path ?? this.countdown3Path,
      countdown2Path: countdown2Path ?? this.countdown2Path,
      countdown1Path: countdown1Path ?? this.countdown1Path,
      capturePath: capturePath ?? this.capturePath,
      resultPath: resultPath ?? this.resultPath,
      galleryPath: galleryPath ?? this.galleryPath,
      collagePath: collagePath ?? this.collagePath,
      photoIconPath: photoIconPath ?? this.photoIconPath,
      galleryIconPath: galleryIconPath ?? this.galleryIconPath,
      collageIconPath: collageIconPath ?? this.collageIconPath,
      backIconPath: backIconPath ?? this.backIconPath,
      printIconPath: printIconPath ?? this.printIconPath,
      removeIconPath: removeIconPath ?? this.removeIconPath,
      closeIconPath: closeIconPath ?? this.closeIconPath,
      prevIconPath: prevIconPath ?? this.prevIconPath,
      nextIconPath: nextIconPath ?? this.nextIconPath,
      fontFamilyName: fontFamilyName ?? this.fontFamilyName,
      textColorHex: textColorHex ?? this.textColorHex,
      captureText: captureText ?? this.captureText,
      shortcutSettingsLogicalKeyId: shortcutSettingsLogicalKeyId ?? this.shortcutSettingsLogicalKeyId,
      shortcutPrevLogicalKeyId: shortcutPrevLogicalKeyId ?? this.shortcutPrevLogicalKeyId,
      shortcutNextLogicalKeyId: shortcutNextLogicalKeyId ?? this.shortcutNextLogicalKeyId,
      shortcutEnterLogicalKeyId: shortcutEnterLogicalKeyId ?? this.shortcutEnterLogicalKeyId,
    );
  }

  Map<String, dynamic> toJson() => {
        "fileSavePath": fileSavePath,
        "eventLogoPath": eventLogoPath,
        "homeText": homeText,
        "mainColorHex": mainColorHex,
        "accentColorHex": accentColorHex,
        "adminPassword": adminPassword,
        "mainWallpaperPath": mainWallpaperPath,
        "countdown3Path": countdown3Path,
        "countdown2Path": countdown2Path,
        "countdown1Path": countdown1Path,
        "capturePath": capturePath,
        "resultPath": resultPath,
        "galleryPath": galleryPath,
        "collagePath": collagePath,
        "photoIconPath": photoIconPath,
        "galleryIconPath": galleryIconPath,
        "collageIconPath": collageIconPath,
        "backIconPath": backIconPath,
        "printIconPath": printIconPath,
        "removeIconPath": removeIconPath,
        "closeIconPath": closeIconPath,
        "prevIconPath": prevIconPath,
        "nextIconPath": nextIconPath,
        "fontFamilyName": fontFamilyName,
        "textColorHex": textColorHex,
        "captureText": captureText,
        "shortcutSettingsLogicalKeyId": shortcutSettingsLogicalKeyId,
        "shortcutPrevLogicalKeyId": shortcutPrevLogicalKeyId,
        "shortcutNextLogicalKeyId": shortcutNextLogicalKeyId,
        "shortcutEnterLogicalKeyId": shortcutEnterLogicalKeyId,
      };

  factory AppConfig.fromJson(Map<String, dynamic> json) => AppConfig(
        fileSavePath: json["fileSavePath"] ?? "saved/",
        eventLogoPath: json["eventLogoPath"] ?? "assets/images/photobooth_logo.png",
        homeText: json["homeText"] ?? "Use the button below",
        mainColorHex: json["mainColorHex"] ?? "FF4E4E7B",
        accentColorHex: json["accentColorHex"] ?? "994E4E7B",
        adminPassword: json["adminPassword"],
        mainWallpaperPath: json["mainWallpaperPath"] ?? "assets/images/photobooth_background.png",
        countdown3Path: json["countdown3Path"],
        countdown2Path: json["countdown2Path"],
        countdown1Path: json["countdown1Path"],
        capturePath: json["capturePath"],
        resultPath: json["resultPath"],
        galleryPath: json["galleryPath"],
        collagePath: json["collagePath"],
        photoIconPath: json["photoIconPath"] ?? "assets/icons/camera-solid-full.svg",
        galleryIconPath: json["galleryIconPath"] ?? "assets/icons/images-solid-full.svg",
        collageIconPath: json["collageIconPath"] ?? "assets/icons/table-cells-large-solid-full.svg",
        backIconPath: json["backIconPath"] ?? "assets/icons/back.svg",
        printIconPath: json["printIconPath"] ?? "assets/icons/print-solid-full.svg",
        removeIconPath: json["removeIconPath"] ?? "assets/icons/trash-solid-full.svg",
        closeIconPath: json["closeIconPath"] ?? "assets/icons/xmark-solid-full.svg",
        prevIconPath: json["prevIconPath"] ?? "assets/icons/caret-left-solid-full.svg",
        nextIconPath: json["nextIconPath"] ?? "assets/icons/caret-right-solid-full.svg",
        fontFamilyName: json["fontFamilyName"] ?? "Lemonada",
        textColorHex: json["textColorHex"] ?? "1F1F1F",
        captureText: json["captureText"] ?? "Smile",
        shortcutSettingsLogicalKeyId: json["shortcutSettingsLogicalKeyId"] ?? 0x0010000080c,
        shortcutPrevLogicalKeyId: json["shortcutPrevLogicalKeyId"] ?? 0x00000000070,
        shortcutNextLogicalKeyId: json["shortcutNextLogicalKeyId"] ?? 0x0000000006e,
        shortcutEnterLogicalKeyId: json["shortcutEnterLogicalKeyId"] ?? 0x0010000000d,
      );
}
