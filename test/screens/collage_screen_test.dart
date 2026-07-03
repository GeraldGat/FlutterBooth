import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/models/four_collage.dart';
import 'package:flutterbooth/models/two_collage.dart';
import 'package:flutterbooth/models/two_plus_one_collage.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/screens/collage_screen.dart';
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
    child: MaterialApp(
      home: CollageScreen(
        collages: [TwoCollage(), TwoPlusOneCollage(), FourCollage()],
      ),
    ),
  );
}

void main() {
  group('CollageScreen', () {
    testWidgets('renders without crashing', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(CollageScreen), findsOneWidget);
    });

    testWidgets('displays GridView for collage selection', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
