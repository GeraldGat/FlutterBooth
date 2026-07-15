import 'package:flutter/material.dart';
import 'package:flutterbooth/l10n/app_localizations.dart';
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
          AppLocalizations.of(context)!.shortcutOpenSettings,
          config.shortcuts.settings,
          (v) => onChanged(config.copyWith(shortcuts: config.shortcuts.copyWith(settings: v))),
        ),
        buildShortcutField(
          AppLocalizations.of(context)!.shortcutPrevious,
          config.shortcuts.prev,
          (v) => onChanged(config.copyWith(shortcuts: config.shortcuts.copyWith(prev: v))),
        ),
        buildShortcutField(
          AppLocalizations.of(context)!.shortcutNext,
          config.shortcuts.next,
          (v) => onChanged(config.copyWith(shortcuts: config.shortcuts.copyWith(next: v))),
        ),
        buildShortcutField(
          AppLocalizations.of(context)!.shortcutEnter,
          config.shortcuts.enter,
          (v) => onChanged(config.copyWith(shortcuts: config.shortcuts.copyWith(enter: v))),
        ),
      ],
    );
  }
}
