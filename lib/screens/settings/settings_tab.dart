import 'package:flutter/material.dart';
import 'package:flutterbooth/l10n/app_localizations.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/models/config/extensions/app_config_colors.dart';
import 'package:flutterbooth/models/config/extensions/app_config_image_widgets.dart';
import 'package:flutterbooth/screens/settings/settings_fields.dart';

class SettingsTab extends StatelessWidget {
  final AppConfig config;
  final ValueChanged<AppConfig> onChanged;
  final TextEditingController passwordController;
  final bool passwordEverModified;
  final ValueChanged<bool> onPasswordModified;

  const SettingsTab({
    super.key,
    required this.config,
    required this.onChanged,
    required this.passwordController,
    required this.passwordEverModified,
    required this.onPasswordModified,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        buildDirectoryField(
          AppLocalizations.of(context)!.fileSavePath,
          config.settings.fileSavePath,
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(fileSavePath: v))),
        ),
        buildImageField(
          AppLocalizations.of(context)!.eventLogo,
          config.eventLogo(width: 80, height: 80),
          config.settings.eventLogoPath,
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(eventLogoPath: v))),
        ),
        buildTextField(
          AppLocalizations.of(context)!.homeText,
          config.settings.homeText,
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(homeText: v))),
        ),
        buildTextField(
          AppLocalizations.of(context)!.homeRightText,
          config.settings.homeRightText,
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(homeRightText: v))),
        ),
        buildColorField(
          context,
          AppLocalizations.of(context)!.mainColor,
          config.mainColor,
          config.settings.mainColorHex,
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(mainColorHex: v))),
        ),
        buildColorField(
          context,
          AppLocalizations.of(context)!.accentColor,
          config.accentColor,
          config.settings.accentColorHex,
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(accentColorHex: v))),
        ),
        buildPasswordField(
          context: context,
          controller: passwordController,
          hasPassword: config.settings.adminPassword?.isNotEmpty == true,
          onModified: () => onPasswordModified(true),
        ),
        buildTextField(
          AppLocalizations.of(context)!.gphotoPort,
          config.settings.gphotoPort ?? "",
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(gphotoPort: v))),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: config.settings.locale,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.language,
            border: const OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: "en", child: Text("English")),
            DropdownMenuItem(value: "fr", child: Text("Français")),
          ],
          onChanged: (v) {
            if (v != null) {
              onChanged(config.copyWith(settings: config.settings.copyWith(locale: v)));
            }
          },
        ),
      ],
    );
  }
}
