import 'package:flutterbooth/models/config/abstract_config.dart';

class ShortcutConfig implements Config {
  final int settings;
  final int prev;
  final int next;
  final int enter;

  const ShortcutConfig({
    this.settings = 0x0010000080c, // F12
    this.prev = 0x00000000070, // P
    this.next = 0x0000000006e, // N
    this.enter = 0x0010000000d, // Enter
  });

  @override
  ShortcutConfig copyWith({
    int? settings,
    int? prev,
    int? next,
    int? enter,
  }) {
    return ShortcutConfig(
      settings: settings ?? this.settings,
      prev: prev ?? this.prev,
      next: next ?? this.next,
      enter: enter ?? this.enter,
    );
  }

  factory ShortcutConfig.fromJson(Map<String, dynamic> json) => ShortcutConfig(
    settings: json["settings"] ?? 0x0010000080c,
    prev: json["prev"] ?? 0x00000000070,
    next: json["next"] ?? 0x0000000006e,
    enter: json["enter"] ?? 0x0010000000d,
  );

  @override
  Map<String, dynamic> toJson() => {
    "settings": settings,
    "prev": prev,
    "next": next,
    "enter": enter,
  };
}