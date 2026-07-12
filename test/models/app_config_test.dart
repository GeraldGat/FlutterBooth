import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/models/config/settings_config.dart';
import 'package:flutterbooth/models/config/wallpaper_config.dart';
import 'package:flutterbooth/models/config/icon_config.dart';
import 'package:flutterbooth/models/config/text_config.dart';
import 'package:flutterbooth/models/config/shortcut_config.dart';

void main() {
  group('SettingsConfig', () {
    test('defaults are correct', () {
      const config = SettingsConfig();
      expect(config.fileSavePath, 'saved/');
      expect(config.eventLogoPath, 'assets/images/photobooth_logo.png');
      expect(config.homeText, 'Use the button below');
      expect(config.mainColorHex, 'FF4E4E7B');
      expect(config.accentColorHex, '994E4E7B');
      expect(config.adminPassword, isNull);
      expect(config.gphotoPort, isNull);
    });

    test('fromJson parses correctly', () {
      final json = {
        'fileSavePath': '/custom/path/',
        'eventLogoPath': '/custom/logo.png',
        'homeText': 'Welcome!',
        'mainColorHex': 'FF000000',
        'accentColorHex': '99FFFFFF',
        'adminPassword': 'hashed_pw',
        'gphotoPort': 'usb:001,002',
      };
      final config = SettingsConfig.fromJson(json);
      expect(config.fileSavePath, '/custom/path/');
      expect(config.eventLogoPath, '/custom/logo.png');
      expect(config.homeText, 'Welcome!');
      expect(config.mainColorHex, 'FF000000');
      expect(config.accentColorHex, '99FFFFFF');
      expect(config.adminPassword, 'hashed_pw');
      expect(config.gphotoPort, 'usb:001,002');
    });

    test('fromJson uses defaults for missing keys', () {
      final config = SettingsConfig.fromJson({});
      expect(config.fileSavePath, 'saved/');
      expect(config.homeText, 'Use the button below');
      expect(config.adminPassword, isNull);
    });

    test('toJson produces correct map', () {
      final config = SettingsConfig(
        fileSavePath: '/test/',
        homeText: 'Hello',
        adminPassword: 'pw',
      );
      final json = config.toJson();
      expect(json['fileSavePath'], '/test/');
      expect(json['homeText'], 'Hello');
      expect(json['adminPassword'], 'pw');
    });

    test('copyWith overrides specified fields', () {
      const config = SettingsConfig();
      final copy = config.copyWith(fileSavePath: '/new/', homeText: 'New text');
      expect(copy.fileSavePath, '/new/');
      expect(copy.homeText, 'New text');
      expect(copy.mainColorHex, 'FF4E4E7B');
    });

    test('copyWith preserves unspecified fields', () {
      const config = SettingsConfig(fileSavePath: '/custom/');
      final copy = config.copyWith(homeText: 'Hi');
      expect(copy.fileSavePath, '/custom/');
      expect(copy.homeText, 'Hi');
    });
  });

  group('WallpaperConfig', () {
    test('defaults are correct', () {
      const config = WallpaperConfig();
      expect(config.mainWallpaperPath, 'assets/images/photobooth_background.png');
      expect(config.countdown3Path, isNull);
      expect(config.countdown2Path, isNull);
      expect(config.countdown1Path, isNull);
      expect(config.capturePath, isNull);
      expect(config.resultPath, isNull);
      expect(config.galleryPath, isNull);
      expect(config.collagePath, isNull);
    });

    test('fromJson roundtrip', () {
      final json = {
        'mainWallpaperPath': '/custom/bg.png',
        'countdown3Path': '/custom/3.png',
        'capturePath': '/custom/cap.png',
      };
      final config = WallpaperConfig.fromJson(json);
      expect(config.mainWallpaperPath, '/custom/bg.png');
      expect(config.countdown3Path, '/custom/3.png');
      expect(config.capturePath, '/custom/cap.png');
      final output = config.toJson();
      expect(output['countdown3Path'], '/custom/3.png');
      expect(output['capturePath'], '/custom/cap.png');
    });

    test('copyWith works correctly', () {
      const config = WallpaperConfig();
      final copy = config.copyWith(mainWallpaperPath: '/new/bg.png');
      expect(copy.mainWallpaperPath, '/new/bg.png');
      expect(copy.collagePath, isNull);
    });
  });

  group('IconConfig', () {
    test('defaults contain expected paths', () {
      const config = IconConfig();
      expect(config.photoIconPath, 'assets/icons/camera-solid-full.svg');
      expect(config.galleryIconPath, 'assets/icons/images-solid-full.svg');
      expect(config.collageIconPath, 'assets/icons/table-cells-large-solid-full.svg');
      expect(config.backIconPath, 'assets/icons/back.svg');
      expect(config.printIconPath, 'assets/icons/print-solid-full.svg');
      expect(config.removeIconPath, 'assets/icons/trash-solid-full.svg');
      expect(config.closeIconPath, 'assets/icons/xmark-solid-full.svg');
      expect(config.prevIconPath, 'assets/icons/caret-left-solid-full.svg');
      expect(config.nextIconPath, 'assets/icons/caret-right-solid-full.svg');
    });

    test('fromJson parses all fields', () {
      final json = {
        'photoIconPath': '/icons/photo.svg',
        'galleryIconPath': '/icons/gallery.svg',
        'collageIconPath': '/icons/collage.svg',
        'backIconPath': '/icons/back.svg',
        'printIconPath': '/icons/print.svg',
        'removeIconPath': '/icons/remove.svg',
        'closeIconPath': '/icons/close.svg',
        'prevIconPath': '/icons/prev.svg',
        'nextIconPath': '/icons/next.svg',
      };
      final config = IconConfig.fromJson(json);
      expect(config.photoIconPath, '/icons/photo.svg');
      expect(config.nextIconPath, '/icons/next.svg');
    });

    test('toJson roundtrip', () {
      const config = IconConfig(photoIconPath: '/test/photo.svg');
      final json = config.toJson();
      expect(json['photoIconPath'], '/test/photo.svg');
    });
  });

  group('TextConfig', () {
    test('defaults are correct', () {
      const config = TextConfig();
      expect(config.fontFamilyName, 'Lemonada');
      expect(config.textColorHex, 'FF1F1F1F');
      expect(config.captureText, 'Smile');
      expect(config.countdownFontSize, 100);
      expect(config.homeFontSize, 40);
    });

    test('fromJson and toJson roundtrip', () {
      final config = TextConfig.fromJson({
        'fontFamilyName': 'Roboto',
        'captureText': 'Cheese',
        'countdownFontSize': 120,
        'homeFontSize': 48,
      });
      expect(config.fontFamilyName, 'Roboto');
      expect(config.captureText, 'Cheese');
      expect(config.countdownFontSize, 120);
      expect(config.homeFontSize, 48);
      final json = config.toJson();
      expect(json['fontFamilyName'], 'Roboto');
      expect(json['captureText'], 'Cheese');
      expect(json['countdownFontSize'], 120);
      expect(json['homeFontSize'], 48);
    });
  });

  group('ShortcutConfig', () {
    test('defaults are correct', () {
      const config = ShortcutConfig();
      expect(config.settings, 0x0010000080c);
      expect(config.prev, 0x00000000070);
      expect(config.next, 0x0000000006e);
      expect(config.enter, 0x0010000000d);
    });

    test('fromJson parses custom values', () {
      final json = {'settings': 1, 'prev': 2, 'next': 3, 'enter': 4};
      final config = ShortcutConfig.fromJson(json);
      expect(config.settings, 1);
      expect(config.prev, 2);
      expect(config.next, 3);
      expect(config.enter, 4);
    });
  });

  group('AppConfig', () {
    test('default constructor uses sub-config defaults', () {
      const config = AppConfig();
      expect(config.settings.fileSavePath, 'saved/');
      expect(config.wallpaper.mainWallpaperPath, 'assets/images/photobooth_background.png');
      expect(config.icons.photoIconPath, 'assets/icons/camera-solid-full.svg');
      expect(config.texts.fontFamilyName, 'Lemonada');
      expect(config.shortcuts.settings, 0x0010000080c);
    });

    test('fromJson parses all sub-configs', () {
      final json = {
        'settings': {'fileSavePath': '/data/', 'homeText': 'Hi'},
        'wallpaper': {'mainWallpaperPath': '/bg.png'},
        'icons': {'photoIconPath': '/photo.svg'},
        'texts': {'fontFamilyName': 'Arial'},
        'shortcuts': {'enter': 13},
      };
      final config = AppConfig.fromJson(json);
      expect(config.settings.fileSavePath, '/data/');
      expect(config.settings.homeText, 'Hi');
      expect(config.wallpaper.mainWallpaperPath, '/bg.png');
      expect(config.icons.photoIconPath, '/photo.svg');
      expect(config.texts.fontFamilyName, 'Arial');
      expect(config.shortcuts.enter, 13);
    });

    test('fromJson uses defaults for missing sub-configs', () {
      final config = AppConfig.fromJson({});
      expect(config.settings.fileSavePath, 'saved/');
      expect(config.wallpaper.mainWallpaperPath, 'assets/images/photobooth_background.png');
    });

    test('toJson produces correct nested structure', () {
      const config = AppConfig();
      final json = config.toJson();
      expect(json['settings'], isA<Map>());
      expect(json['wallpaper'], isA<Map>());
      expect(json['icons'], isA<Map>());
      expect(json['texts'], isA<Map>());
      expect(json['shortcuts'], isA<Map>());
      expect((json['settings'] as Map)['fileSavePath'], 'saved/');
    });

    test('copyWith overrides specified configs', () {
      const config = AppConfig();
      final newSettings = SettingsConfig(fileSavePath: '/override/');
      final copy = config.copyWith(settings: newSettings);
      expect(copy.settings.fileSavePath, '/override/');
      expect(copy.wallpaper.mainWallpaperPath, 'assets/images/photobooth_background.png');
    });
  });
}
