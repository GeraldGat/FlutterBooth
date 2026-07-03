import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/models/config/settings_config.dart';
import 'package:flutterbooth/providers/access_checker_provider.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/screens/home_screen.dart';
import 'package:flutterbooth/services/config_service.dart';
import 'package:flutterbooth/widgets/rotating_menu.dart';
import 'package:mocktail/mocktail.dart';

class MockConfigService extends Mock implements ConfigService {}

class MockAccessCheckerService extends Mock implements AccessCheckerService {}

Widget createTestWidget({
  ConfigService? configService,
  AccessCheckerService? accessCheckerService,
}) {
  final mockConfigService = configService ?? MockConfigService();
  final mockAccessChecker = accessCheckerService ?? MockAccessCheckerService();

  return ProviderScope(
    overrides: [
      configServiceProvider.overrideWithValue(mockConfigService),
      accessCheckerProvider.overrideWithValue(mockAccessChecker),
    ],
    child: const MaterialApp(home: HomeScreen()),
  );
}

void main() {
  group('HomeScreen', () {
    testWidgets('shows loading state initially', (tester) async {
      final mockService = MockConfigService();

      when(() => mockService.getConfig()).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return AppConfig();
      });

      await tester.pumpWidget(createTestWidget(configService: mockService));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('shows error state when config fails to load', (tester) async {
      final mockService = MockConfigService();
      when(() => mockService.getConfig()).thenThrow(Exception('Load failed'));

      await tester.pumpWidget(createTestWidget(configService: mockService));
      await tester.pumpAndSettle();

      expect(find.textContaining('Error loading config'), findsOneWidget);
    });

    testWidgets('renders home text from config', (tester) async {
      final mockService = MockConfigService();
      final config = AppConfig(
        settings: const SettingsConfig(homeText: 'Welcome to Photobooth!'),
      );
      when(() => mockService.getConfig()).thenAnswer((_) async => config);

      await tester.pumpWidget(createTestWidget(configService: mockService));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Photobooth!'), findsOneWidget);
    });

    testWidgets('shows rotating menu', (tester) async {
      final mockService = MockConfigService();
      when(() => mockService.getConfig()).thenAnswer((_) async => AppConfig());

      await tester.pumpWidget(createTestWidget(configService: mockService));
      await tester.pumpAndSettle();

      expect(find.byType(RotatingMenu), findsOneWidget);
    });
  });
}
