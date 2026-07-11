import 'package:flutter/material.dart';
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
          "File save path",
          config.settings.fileSavePath,
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(fileSavePath: v))),
        ),
        buildImageField(
          "Event Logo",
          config.eventLogo(width: 80, height: 80),
          config.settings.eventLogoPath,
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(eventLogoPath: v))),
        ),
        buildTextField(
          "Home text",
          config.settings.homeText,
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(homeText: v))),
        ),
        buildColorField(
          context,
          "Main color",
          config.mainColor,
          config.settings.mainColorHex,
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(mainColorHex: v))),
        ),
        buildColorField(
          context,
          "Accent color",
          config.accentColor,
          config.settings.accentColorHex,
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(accentColorHex: v))),
        ),
        buildPasswordField(
          controller: passwordController,
          hasPassword: config.settings.adminPassword?.isNotEmpty == true,
          onModified: () => onPasswordModified(true),
        ),
        buildTextField(
          "Gphoto2 port",
          config.settings.gphotoPort ?? "",
          (v) => onChanged(config.copyWith(settings: config.settings.copyWith(gphotoPort: v))),
        ),
      ],
    );
  }
}
