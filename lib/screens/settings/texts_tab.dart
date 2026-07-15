import 'package:flutter/material.dart';
import 'package:flutterbooth/l10n/app_localizations.dart';
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
          AppLocalizations.of(context)!.fontFamily,
          config.texts.fontFamilyName,
          (v) => onChanged(config.copyWith(texts: config.texts.copyWith(fontFamilyName: v))),
          fonts,
        ),
        buildColorField(
          context,
          AppLocalizations.of(context)!.textColor,
          config.textColor,
          config.texts.textColorHex,
          (v) => onChanged(config.copyWith(texts: config.texts.copyWith(textColorHex: v))),
        ),
        buildTextField(
          AppLocalizations.of(context)!.captureTextLabel,
          config.texts.captureText,
          (v) => onChanged(config.copyWith(texts: config.texts.copyWith(captureText: v))),
        ),
        buildTextField(
          AppLocalizations.of(context)!.countdownFontSize,
          config.texts.countdownFontSize.toInt().toString(),
          (v) {
            final size = double.tryParse(v);
            if (size != null) {
              onChanged(config.copyWith(texts: config.texts.copyWith(countdownFontSize: size)));
            }
          },
        ),
        buildTextField(
          AppLocalizations.of(context)!.homeScreenFontSize,
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
