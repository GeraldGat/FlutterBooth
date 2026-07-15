// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeMenuPhoto => 'Take a photo';

  @override
  String get homeMenuGallery => 'View gallery';

  @override
  String get homeMenuCollage => 'Create collage';

  @override
  String get captureError => 'An error occured while capturing image.';

  @override
  String get printing => 'Printing...';

  @override
  String get printError => 'An error occured during printing.';

  @override
  String get unexpectedError => 'An unexpected error occurred.';

  @override
  String get settingsTitle => 'Configuration';

  @override
  String get settingsTabSettings => 'Settings';

  @override
  String get settingsTabWallpapers => 'Wallpapers';

  @override
  String get settingsTabIcons => 'Icons';

  @override
  String get settingsTabTexts => 'Texts';

  @override
  String get settingsTabShortcuts => 'Shortcuts';

  @override
  String get adminPassword => 'Admin panel password';

  @override
  String get adminPasswordHelper =>
      'Clear the field and save to remove the password';

  @override
  String pickColorTitle(String label) {
    return 'Pick a color for $label';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get select => 'Select';

  @override
  String get fileSavePath => 'File save path';

  @override
  String get eventLogo => 'Event Logo';

  @override
  String get homeText => 'Home text';

  @override
  String get homeRightText => 'Home right text';

  @override
  String get mainColor => 'Main color';

  @override
  String get accentColor => 'Accent color';

  @override
  String get gphotoPort => 'Gphoto2 port';

  @override
  String get fontFamily => 'Font family';

  @override
  String get textColor => 'Text color';

  @override
  String get captureTextLabel => 'Capture text';

  @override
  String get countdownFontSize => 'Countdown font size';

  @override
  String get homeScreenFontSize => 'Home screen font size';

  @override
  String get mainWallpaper => 'Main wallpaper';

  @override
  String get countdown3 => 'Countdown 3';

  @override
  String get countdown2 => 'Countdown 2';

  @override
  String get countdown1 => 'Countdown 1';

  @override
  String get captureWallpaper => 'Capture';

  @override
  String get resultWallpaper => 'Result';

  @override
  String get galleryWallpaper => 'Gallery';

  @override
  String get collageWallpaper => 'Collage';

  @override
  String get iconPhoto => 'Photo';

  @override
  String get iconGallery => 'Gallery';

  @override
  String get iconCollage => 'Collage';

  @override
  String get iconBack => 'Back';

  @override
  String get iconPrint => 'Print';

  @override
  String get iconRemove => 'Remove';

  @override
  String get iconClose => 'Close';

  @override
  String get iconPrevious => 'Previous';

  @override
  String get iconNext => 'Next';

  @override
  String get shortcutOpenSettings => 'Open Settings';

  @override
  String get shortcutPrevious => 'Previous';

  @override
  String get shortcutNext => 'Next';

  @override
  String get shortcutEnter => 'Enter';

  @override
  String get passwordRequired => 'Password required';

  @override
  String get adminPasswordField => 'Admin password';

  @override
  String get ok => 'OK';

  @override
  String get countdownNum3 => '3';

  @override
  String get countdownNum2 => '2';

  @override
  String get countdownNum1 => '1';

  @override
  String get language => 'Language';
}
