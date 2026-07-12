import 'package:flutter/material.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/models/config/extensions/app_config_colors.dart';
import 'package:flutterbooth/screens/settings/settings_fields.dart';

class TextsTab extends StatelessWidget {
  final AppConfig config;
  final ValueChanged<AppConfig> onChanged;
  final List<String> fonts;

  const TextsTab({
    super.key,
    required this.config,
    required this.onChanged,
    required this.fonts,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        buildFontFamilyField(
          "Font family",
          config.texts.fontFamilyName,
          (v) => onChanged(config.copyWith(texts: config.texts.copyWith(fontFamilyName: v))),
          fonts,
        ),
        buildColorField(
          context,
          "Text color",
          config.textColor,
          config.texts.textColorHex,
          (v) => onChanged(config.copyWith(texts: config.texts.copyWith(textColorHex: v))),
        ),
        buildTextField(
          "Capture text",
          config.texts.captureText,
          (v) => onChanged(config.copyWith(texts: config.texts.copyWith(captureText: v))),
        ),
        buildTextField(
          "Countdown font size",
          config.texts.countdownFontSize.toInt().toString(),
          (v) {
            final size = double.tryParse(v);
            if (size != null) {
              onChanged(config.copyWith(texts: config.texts.copyWith(countdownFontSize: size)));
            }
          },
        ),
        buildTextField(
          "Home screen font size",
          config.texts.homeFontSize.toInt().toString(),
          (v) {
            final size = double.tryParse(v);
            if (size != null) {
              onChanged(config.copyWith(texts: config.texts.copyWith(homeFontSize: size)));
            }
          },
        ),
      ],
    );
  }
}
