import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterbooth/models/config/app_config.dart';
import 'package:flutterbooth/providers/config_provider.dart';
import 'package:flutterbooth/screens/countdown_and_capture_screen.dart';
import 'package:flutterbooth/services/config_service.dart';
import 'package:mocktail/mocktail.dart';

class MockConfigService extends Mock implements ConfigService {}

Widget createTestWidget({void Function()? onCapture}) {
  final mockService = MockConfigService();
  when(() => mockService.getConfig()).thenAnswer((_) async => AppConfig());

  return ProviderScope(
    overrides: [
      configServiceProvider.overrideWithValue(mockService),
    ],
    child: MaterialApp(home: CountdownAndCaptureScreen(onCapture: onCapture)),
  );
}

void main() {
  group('CountdownAndCaptureScreen', () {
    testWidgets('shows countdown starting at 3', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('3'), findsOneWidget);

      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('countdown reaches 1 after 2 seconds', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('2'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      expect(find.text('1'), findsOneWidget);

      // Let the timer complete to avoid pending timer assertion
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('calls onCapture when countdown reaches 0', (tester) async {
      bool captured = false;
      await tester.pumpWidget(createTestWidget(onCapture: () { captured = true; }));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 1));

      expect(captured, isTrue);
    });
  });
}
