import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/screens/result_screen.dart';
import 'package:flutterbooth/services/config_service.dart';
import 'package:flutterbooth/widgets/rotating_menu.dart';
import 'package:mocktail/mocktail.dart';

class MockConfigService extends Mock implements ConfigService {}

Widget createTestWidget({required Image image}) {
  final mockService = MockConfigService();
  when(() => mockService.getConfig()).thenAnswer((_) async => AppConfig());

  return ProviderScope(
    overrides: [
      configServiceProvider.overrideWithValue(mockService),
    ],
    child: MaterialApp(home: ResultScreen(image: image)),
  );
}

void main() {
  group('ResultScreen', () {
    testWidgets('shows rotating menu with 3 actions', (tester) async {
      const image = Image(image: AssetImage('assets/images/photobooth_logo.png'));
      await tester.pumpWidget(createTestWidget(image: image));
      await tester.pumpAndSettle();

      expect(find.byType(RotatingMenu), findsOneWidget);
    });

    testWidgets('shows at least 3 IconButtons in the menu', (tester) async {
      const image = Image(image: AssetImage('assets/images/photobooth_logo.png'));
      await tester.pumpWidget(createTestWidget(image: image));
      await tester.pumpAndSettle();

      expect(find.byType(IconButton), findsAtLeast(3));
    });
  });
}
