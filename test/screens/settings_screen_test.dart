import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/screens/settings_screen.dart';
import 'package:flutterbooth/services/config_service.dart';
import 'package:mocktail/mocktail.dart';

class MockConfigService extends Mock implements ConfigService {}

Widget createTestWidget() {
  final mockService = MockConfigService();
  when(() => mockService.getConfig()).thenAnswer((_) async => AppConfig());

  return ProviderScope(
    overrides: [
      configServiceProvider.overrideWithValue(mockService),
    ],
    child: const MaterialApp(home: SettingsScreen()),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(AppConfig());
  });

  group('SettingsScreen', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('shows settings tabs', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Wallpapers'), findsOneWidget);
      expect(find.text('Icons'), findsOneWidget);
      expect(find.text('Texts'), findsOneWidget);
      expect(find.text('Shortcuts'), findsOneWidget);
    });

    testWidgets('shows save button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.save), findsOneWidget);
    });
  });
}
