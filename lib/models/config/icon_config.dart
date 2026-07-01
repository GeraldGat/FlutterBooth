import 'package:flutterbooth/models/config/abstract_config.dart';

class IconConfig implements Config {
  final String photoIconPath;
  final String galleryIconPath;
  final String collageIconPath;
  final String backIconPath;
  final String printIconPath;
  final String removeIconPath;
  final String closeIconPath;
  final String prevIconPath;
  final String nextIconPath;

  const IconConfig({
    this.photoIconPath = "assets/icons/camera-solid-full.svg",
    this.galleryIconPath = "assets/icons/images-solid-full.svg",
    this.collageIconPath = "assets/icons/table-cells-large-solid-full.svg",
    this.backIconPath = "assets/icons/back.svg",
    this.printIconPath = "assets/icons/print-solid-full.svg",
    this.removeIconPath = "assets/icons/trash-solid-full.svg",
    this.closeIconPath = "assets/icons/xmark-solid-full.svg",
    this.prevIconPath = "assets/icons/caret-left-solid-full.svg",
    this.nextIconPath = "assets/icons/caret-right-solid-full.svg",
  });

  @override
  IconConfig copyWith({
    String? photoIconPath,
    String? galleryIconPath,
    String? collageIconPath,
    String? backIconPath,
    String? printIconPath,
    String? removeIconPath,
    String? closeIconPath,
    String? prevIconPath,
    String? nextIconPath,
  }) {
    return IconConfig(
      photoIconPath: photoIconPath ?? this.photoIconPath,
      galleryIconPath: galleryIconPath ?? this.galleryIconPath,
      collageIconPath: collageIconPath ?? this.collageIconPath,
      backIconPath: backIconPath ?? this.backIconPath,
      printIconPath: printIconPath ?? this.printIconPath,
      removeIconPath: removeIconPath ?? this.removeIconPath,
      closeIconPath: closeIconPath ?? this.closeIconPath,
      prevIconPath: prevIconPath ?? this.prevIconPath,
      nextIconPath: nextIconPath ?? this.nextIconPath,
    );
  }

  factory IconConfig.fromJson(Map<String, dynamic> json) => IconConfig(
    photoIconPath: json["photoIconPath"] ?? "assets/icons/camera-solid-full.svg",
    galleryIconPath: json["galleryIconPath"] ?? "assets/icons/images-solid-full.svg",
    collageIconPath: json["collageIconPath"] ?? "assets/icons/table-cells-large-solid-full.svg",
    backIconPath: json["backIconPath"] ?? "assets/icons/back.svg",
    printIconPath: json["printIconPath"] ?? "assets/icons/print-solid-full.svg",
    removeIconPath: json["removeIconPath"] ?? "assets/icons/trash-solid-full.svg",
    closeIconPath: json["closeIconPath"] ?? "assets/icons/xmark-solid-full.svg",
    prevIconPath: json["prevIconPath"] ?? "assets/icons/caret-left-solid-full.svg",
    nextIconPath: json["nextIconPath"] ?? "assets/icons/caret-right-solid-full.svg",
  );

  @override
  Map<String, dynamic> toJson() => {
    "photoIconPath": photoIconPath,
    "galleryIconPath": galleryIconPath,
    "collageIconPath": collageIconPath,
    "backIconPath": backIconPath,
    "printIconPath": printIconPath,
    "removeIconPath": removeIconPath,
    "closeIconPath": closeIconPath,
    "prevIconPath": prevIconPath,
    "nextIconPath": nextIconPath,
  };
}