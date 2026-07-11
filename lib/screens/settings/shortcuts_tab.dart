import 'package:flutter/material.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/screens/settings/settings_fields.dart';

class ShortcutsTab extends StatelessWidget {
  final AppConfig config;
  final ValueChanged<AppConfig> onChanged;

  const ShortcutsTab({super.key, required this.config, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        buildShortcutField(
          "Open Settings",
          config.shortcuts.settings,
          (v) => onChanged(config.copyWith(shortcuts: config.shortcuts.copyWith(settings: v))),
        ),
        buildShortcutField(
          "Previous",
          config.shortcuts.prev,
          (v) => onChanged(config.copyWith(shortcuts: config.shortcuts.copyWith(prev: v))),
        ),
        buildShortcutField(
          "Next",
          config.shortcuts.next,
          (v) => onChanged(config.copyWith(shortcuts: config.shortcuts.copyWith(next: v))),
        ),
        buildShortcutField(
          "Enter",
          config.shortcuts.enter,
          (v) => onChanged(config.copyWith(shortcuts: config.shortcuts.copyWith(enter: v))),
        ),
      ],
    );
  }
}
