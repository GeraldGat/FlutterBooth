import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:flutterbooth/services/logger/app_logger.dart';
import 'package:flutterbooth/services/logger/console_log_output.dart';
import 'package:flutterbooth/services/logger/file_log_output.dart';

void main() {
  group('AppLogger', () {
    setUp(() {
      AppLogger.testReset();
    });

    test('init routes records to all outputs', () async {
      final tempDir = Directory.systemTemp.createTempSync('app_log_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      await AppLogger.init(
        outputs: [
          FileLogOutput(logDirectory: tempDir.path),
          ConsoleLogOutput(),
        ],
      );
      AppLogger.i('test message');

      await Future<void>.delayed(Duration.zero);

      final content = File('${tempDir.path}/app.log').readAsStringSync();
      expect(content, contains('test message'));
    });

    test('d, i, w, e methods all write to log file', () async {
      final tempDir = Directory.systemTemp.createTempSync('app_log_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      await AppLogger.init(
        outputs: [
          FileLogOutput(logDirectory: tempDir.path),
        ],
      );
      AppLogger.d('debug msg');
      AppLogger.i('info msg');
      AppLogger.w('warning msg');
      AppLogger.e('error msg');

      await Future<void>.delayed(Duration.zero);

      final content = File('${tempDir.path}/app.log').readAsStringSync();
      expect(content, contains('debug msg'));
      expect(content, contains('info msg'));
      expect(content, contains('warning msg'));
      expect(content, contains('error msg'));
    });

    test('e includes error object and stack trace', () async {
      final tempDir = Directory.systemTemp.createTempSync('app_log_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      await AppLogger.init(
        outputs: [
          FileLogOutput(logDirectory: tempDir.path),
        ],
      );
      final error = Exception('something broke');
      final stack = StackTrace.current;
      AppLogger.e('fatal error', error, stack);

      await Future<void>.delayed(Duration.zero);

      final content = File('${tempDir.path}/app.log').readAsStringSync();
      expect(content, contains('fatal error'));
      expect(content, contains('something broke'));
      expect(content, contains('app_logger_test'));
    });

    test('init is idempotent', () async {
      final tempDir = Directory.systemTemp.createTempSync('app_log_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      await AppLogger.init(
        outputs: [
          FileLogOutput(logDirectory: tempDir.path),
        ],
      );
      await AppLogger.init(
        outputs: [
          FileLogOutput(logDirectory: tempDir.path),
        ],
      );

      AppLogger.i('written once');
      await Future<void>.delayed(Duration.zero);

      expect(File('${tempDir.path}/app.log').existsSync(), isTrue);
    });

    test('logger level filters messages below threshold', () async {
      final tempDir = Directory.systemTemp.createTempSync('app_log_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      await AppLogger.init(
        outputs: [
          FileLogOutput(logDirectory: tempDir.path),
        ],
        level: Level.WARNING,
      );
      AppLogger.d('should not appear');
      AppLogger.i('should also not appear');
      AppLogger.w('should appear');

      await Future<void>.delayed(Duration.zero);

      final content = File('${tempDir.path}/app.log').readAsStringSync();
      expect(content, contains('should appear'));
      expect(content, isNot(contains('should not appear')));
      expect(content, isNot(contains('should also not appear')));
    });
  });
}
