import 'package:flutter/material.dart';
import 'package:flutterbooth/l10n/app_localizations.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/models/config/extensions/app_config_icon_widgets.dart';
import 'package:flutterbooth/screens/settings/settings_fields.dart';

class IconsTab extends StatelessWidget {
  final AppConfig config;
  final ValueChanged<AppConfig> onChanged;

  const IconsTab({super.key, required this.config, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        buildSvgField(
          AppLocalizations.of(context)!.iconPhoto,
          config.photoIcon(width: 40, height: 40),
          config.icons.photoIconPath,
          (v) => onChanged(config.copyWith(icons: config.icons.copyWith(photoIconPath: v))),
        ),
        buildSvgField(
          AppLocalizations.of(context)!.iconGallery,
          config.galleryIcon(width: 40, height: 40),
          config.icons.galleryIconPath,
          (v) => onChanged(config.copyWith(icons: config.icons.copyWith(galleryIconPath: v))),
        ),
        buildSvgField(
          AppLocalizations.of(context)!.iconCollage,
          config.collageIcon(width: 40, height: 40),
          config.icons.collageIconPath,
          (v) => onChanged(config.copyWith(icons: config.icons.copyWith(collageIconPath: v))),
        ),
        buildSvgField(
          AppLocalizations.of(context)!.iconBack,
          config.backIcon(width: 40, height: 40),
          config.icons.backIconPath,
          (v) => onChanged(config.copyWith(icons: config.icons.copyWith(backIconPath: v))),
        ),
        buildSvgField(
          AppLocalizations.of(context)!.iconPrint,
          config.printIcon(width: 40, height: 40),
          config.icons.printIconPath,
          (v) => onChanged(config.copyWith(icons: config.icons.copyWith(printIconPath: v))),
        ),
        buildSvgField(
          AppLocalizations.of(context)!.iconRemove,
          config.removeIcon(width: 40, height: 40),
          config.icons.removeIconPath,
          (v) => onChanged(config.copyWith(icons: config.icons.copyWith(removeIconPath: v))),
        ),
        buildSvgField(
          AppLocalizations.of(context)!.iconClose,
          config.closeIcon(width: 40, height: 40),
          config.icons.closeIconPath,
          (v) => onChanged(config.copyWith(icons: config.icons.copyWith(closeIconPath: v))),
        ),
        buildSvgField(
          AppLocalizations.of(context)!.iconPrevious,
          config.prevIcon(width: 40, height: 40),
          config.icons.prevIconPath,
          (v) => onChanged(config.copyWith(icons: config.icons.copyWith(prevIconPath: v))),
        ),
        buildSvgField(
          AppLocalizations.of(context)!.iconNext,
          config.nextIcon(width: 40, height: 40),
          config.icons.nextIconPath,
          (v) => onChanged(config.copyWith(icons: config.icons.copyWith(nextIconPath: v))),
        ),
      ],
    );
  }
}
