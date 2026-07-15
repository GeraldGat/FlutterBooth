import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// Label for the photo capture menu item on home screen
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get homeMenuPhoto;

  /// Label for the gallery menu item on home screen
  ///
  /// In en, this message translates to:
  /// **'View gallery'**
  String get homeMenuGallery;

  /// Label for the collage menu item on home screen
  ///
  /// In en, this message translates to:
  /// **'Create collage'**
  String get homeMenuCollage;

  /// Snackbar message when image capture fails
  ///
  /// In en, this message translates to:
  /// **'An error occured while capturing image.'**
  String get captureError;

  /// Snackbar message when printing is in progress
  ///
  /// In en, this message translates to:
  /// **'Printing...'**
  String get printing;

  /// Snackbar message when printing fails
  ///
  /// In en, this message translates to:
  /// **'An error occured during printing.'**
  String get printError;

  /// Snackbar message for unexpected errors
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unexpectedError;

  /// Title of the settings screen
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get settingsTitle;

  /// Label for the Settings tab in settings screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTabSettings;

  /// Label for the Wallpapers tab in settings screen
  ///
  /// In en, this message translates to:
  /// **'Wallpapers'**
  String get settingsTabWallpapers;

  /// Label for the Icons tab in settings screen
  ///
  /// In en, this message translates to:
  /// **'Icons'**
  String get settingsTabIcons;

  /// Label for the Texts tab in settings screen
  ///
  /// In en, this message translates to:
  /// **'Texts'**
  String get settingsTabTexts;

  /// Label for the Shortcuts tab in settings screen
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get settingsTabShortcuts;

  /// Label for the admin password field in settings
  ///
  /// In en, this message translates to:
  /// **'Admin panel password'**
  String get adminPassword;

  /// Helper text below admin password field
  ///
  /// In en, this message translates to:
  /// **'Clear the field and save to remove the password'**
  String get adminPasswordHelper;

  /// Title of the color picker dialog
  ///
  /// In en, this message translates to:
  /// **'Pick a color for {label}'**
  String pickColorTitle(String label);

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Select button label in color picker
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// Label for file save path field in settings
  ///
  /// In en, this message translates to:
  /// **'File save path'**
  String get fileSavePath;

  /// Label for event logo field in settings
  ///
  /// In en, this message translates to:
  /// **'Event Logo'**
  String get eventLogo;

  /// Label for home text field in settings
  ///
  /// In en, this message translates to:
  /// **'Home text'**
  String get homeText;

  /// Label for home right text field in settings
  ///
  /// In en, this message translates to:
  /// **'Home right text'**
  String get homeRightText;

  /// Label for main color field in settings
  ///
  /// In en, this message translates to:
  /// **'Main color'**
  String get mainColor;

  /// Label for accent color field in settings
  ///
  /// In en, this message translates to:
  /// **'Accent color'**
  String get accentColor;

  /// Label for Gphoto2 port field in settings
  ///
  /// In en, this message translates to:
  /// **'Gphoto2 port'**
  String get gphotoPort;

  /// Label for font family field in settings
  ///
  /// In en, this message translates to:
  /// **'Font family'**
  String get fontFamily;

  /// Label for text color field in settings
  ///
  /// In en, this message translates to:
  /// **'Text color'**
  String get textColor;

  /// Label for capture text field in settings
  ///
  /// In en, this message translates to:
  /// **'Capture text'**
  String get captureTextLabel;

  /// Label for countdown font size field in settings
  ///
  /// In en, this message translates to:
  /// **'Countdown font size'**
  String get countdownFontSize;

  /// Label for home screen font size field in settings
  ///
  /// In en, this message translates to:
  /// **'Home screen font size'**
  String get homeScreenFontSize;

  /// Label for main wallpaper field in settings
  ///
  /// In en, this message translates to:
  /// **'Main wallpaper'**
  String get mainWallpaper;

  /// Label for countdown 3 wallpaper field in settings
  ///
  /// In en, this message translates to:
  /// **'Countdown 3'**
  String get countdown3;

  /// Label for countdown 2 wallpaper field in settings
  ///
  /// In en, this message translates to:
  /// **'Countdown 2'**
  String get countdown2;

  /// Label for countdown 1 wallpaper field in settings
  ///
  /// In en, this message translates to:
  /// **'Countdown 1'**
  String get countdown1;

  /// Label for capture wallpaper field in settings
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get captureWallpaper;

  /// Label for result wallpaper field in settings
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get resultWallpaper;

  /// Label for gallery wallpaper field in settings
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryWallpaper;

  /// Label for collage wallpaper field in settings
  ///
  /// In en, this message translates to:
  /// **'Collage'**
  String get collageWallpaper;

  /// Label for photo icon field in settings
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get iconPhoto;

  /// Label for gallery icon field in settings
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get iconGallery;

  /// Label for collage icon field in settings
  ///
  /// In en, this message translates to:
  /// **'Collage'**
  String get iconCollage;

  /// Label for back icon field in settings
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get iconBack;

  /// Label for print icon field in settings
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get iconPrint;

  /// Label for remove icon field in settings
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get iconRemove;

  /// Label for close icon field in settings
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get iconClose;

  /// Label for previous icon field in settings
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get iconPrevious;

  /// Label for next icon field in settings
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get iconNext;

  /// Label for open settings shortcut field
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get shortcutOpenSettings;

  /// Label for previous shortcut field
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get shortcutPrevious;

  /// Label for next shortcut field
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get shortcutNext;

  /// Label for enter shortcut field
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get shortcutEnter;

  /// Title of the admin password dialog
  ///
  /// In en, this message translates to:
  /// **'Password required'**
  String get passwordRequired;

  /// Label for password field in access dialog
  ///
  /// In en, this message translates to:
  /// **'Admin password'**
  String get adminPasswordField;

  /// Confirm button label in password dialog
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Countdown number 3
  ///
  /// In en, this message translates to:
  /// **'3'**
  String get countdownNum3;

  /// Countdown number 2
  ///
  /// In en, this message translates to:
  /// **'2'**
  String get countdownNum2;

  /// Countdown number 1
  ///
  /// In en, this message translates to:
  /// **'1'**
  String get countdownNum1;

  /// Label for the language dropdown in settings
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
