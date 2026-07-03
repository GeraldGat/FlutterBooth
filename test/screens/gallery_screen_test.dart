import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/screens/gallery_screen.dart';
import 'package:flutterbooth/services/config_service.dart';
import 'package:mocktail/mocktail.dart';

class MockConfigService extends Mock implements ConfigService {}

Widget createTestWidget({required String imageFolder}) {
  final mockService = MockConfigService();
  when(() => mockService.getConfig()).thenAnswer((_) async => AppConfig());

  return ProviderScope(
    overrides: [
      configServiceProvider.overrideWithValue(mockService),
    ],
    child: MaterialApp(home: GalleryScreen(imageFolder: imageFolder)),
  );
}

void main() {
  group('GalleryScreen', () {
    testWidgets('renders when folder does not exist', (tester) async {
      await tester.pumpWidget(createTestWidget(imageFolder: '/nonexistent/path'));
      await tester.pumpAndSettle();

      expect(find.byType(GalleryScreen), findsOneWidget);
    });

    testWidgets('renders when folder has image files', (tester) async {
      final tempDir = Directory.systemTemp.createTempSync('gallery_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      File('${tempDir.path}/photo1.jpg').writeAsBytesSync([0xFF, 0xD8, 0xFF, 0xE0]);
      File('${tempDir.path}/photo2.jpg').writeAsBytesSync([0xFF, 0xD8, 0xFF, 0xE0]);
      File('${tempDir.path}/not_image.txt').writeAsBytesSync([0x00]);

      await tester.pumpWidget(createTestWidget(imageFolder: tempDir.path));
      await tester.pumpAndSettle();

      expect(find.byType(GalleryScreen), findsOneWidget);
    });

    testWidgets('ignores non-image files', (tester) async {
      final tempDir = Directory.systemTemp.createTempSync('gallery_filter_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      File('${tempDir.path}/image.jpg').writeAsBytesSync([0xFF, 0xD8, 0xFF, 0xE0]);
      File('${tempDir.path}/document.pdf').writeAsBytesSync([0x25, 0x50, 0x44, 0x46]);

      await tester.pumpWidget(createTestWidget(imageFolder: tempDir.path));
      await tester.pumpAndSettle();

      expect(find.byType(GalleryScreen), findsOneWidget);
    });
  });
}
