import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:flutterbooth/services/logger/file_log_output.dart';

void main() {
  group('FileLogOutput', () {
    test('writes log record content to file', () {
      final tempDir = Directory.systemTemp.createTempSync('log_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final output = FileLogOutput(logDirectory: tempDir.path);
      output.output(LogRecord(Level.INFO, 'test message', 'TestLogger'));

      final content = File('${tempDir.path}/app.log').readAsStringSync();
      expect(content, contains('test message'));
    });

    test('log line contains level and logger name', () {
      final tempDir = Directory.systemTemp.createTempSync('log_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final output = FileLogOutput(logDirectory: tempDir.path);
      output.output(LogRecord(Level.WARNING, 'warning msg', 'MyLogger'));

      final content = File('${tempDir.path}/app.log').readAsStringSync();
      expect(content, contains('[WARNING]'));
      expect(content, contains('MyLogger: warning msg'));
    });

    test('includes error and stack trace in severe log', () {
      final tempDir = Directory.systemTemp.createTempSync('log_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final output = FileLogOutput(logDirectory: tempDir.path);
      final error = StateError('bad state');
      output.output(LogRecord(Level.SEVERE, 'error msg', 'ErrLogger',
          error, StackTrace.current));

      final content = File('${tempDir.path}/app.log').readAsStringSync();
      expect(content, contains('bad state'));
      expect(content, contains('ErrLogger'));
    });

    test('rotates file when exceeding max file size', () {
      final tempDir = Directory.systemTemp.createTempSync('log_rotate_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final output = FileLogOutput(
        logDirectory: tempDir.path,
        maxFileSize: 100,
        maxBackupFiles: 2,
      );

      for (int i = 0; i < 20; i++) {
        output.output(LogRecord(
          Level.INFO,
          'Long log message to trigger rotation quickly $i',
          'TestLogger',
        ));
      }

      final files = Directory(tempDir.path)
          .listSync()
          .whereType<File>()
          .map((f) => f.uri.pathSegments.last)
          .toSet();

      expect(files, contains('app.log'));
      expect(files, contains('app.log.1'));
      expect(File('${tempDir.path}/app.log').lengthSync(),
          lessThanOrEqualTo(200));
      expect(File('${tempDir.path}/app.log.1').lengthSync(),
          greaterThan(0));
    });

    test('keeps only maxBackupFiles backup copies after rotation', () {
      final tempDir = Directory.systemTemp.createTempSync('log_backup_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final output = FileLogOutput(
        logDirectory: tempDir.path,
        maxFileSize: 50,
        maxBackupFiles: 2,
      );

      for (int i = 0; i < 50; i++) {
        output.output(LogRecord(Level.INFO, 'x' * 30, 'TestLogger'));
      }

      final files = Directory(tempDir.path)
          .listSync()
          .whereType<File>()
          .map((f) => f.uri.pathSegments.last)
          .where((name) => name.startsWith('app.log'))
          .toList();

      expect(files.length, lessThanOrEqualTo(3));
    });

    test('writes to custom base file name', () {
      final tempDir = Directory.systemTemp.createTempSync('log_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final output = FileLogOutput(
        logDirectory: tempDir.path,
        baseFileName: 'custom.log',
      );
      output.output(LogRecord(Level.INFO, 'custom file', 'TestLogger'));

      expect(File('${tempDir.path}/custom.log').existsSync(), isTrue);
      expect(File('${tempDir.path}/app.log').existsSync(), isFalse);
    });

    test('creates log directory if it does not exist', () {
      final tempDir = Directory.systemTemp.createTempSync('log_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final nestedDir = '${tempDir.path}/nested/deep/dir';
      final output = FileLogOutput(logDirectory: nestedDir);
      output.output(LogRecord(Level.INFO, 'nested dir test', 'TestLogger'));

      expect(Directory(nestedDir).existsSync(), isTrue);
      expect(File('$nestedDir/app.log').existsSync(), isTrue);
    });

    test('handles concurrent log lines without error', () {
      final tempDir = Directory.systemTemp.createTempSync('log_test_');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final output = FileLogOutput(logDirectory: tempDir.path);

      for (int i = 0; i < 100; i++) {
        output.output(LogRecord(Level.INFO, 'line $i', 'TestLogger'));
      }

      final content = File('${tempDir.path}/app.log').readAsStringSync();
      final lines = content.split('\n').where((l) => l.isNotEmpty).toList();
      expect(lines.length, 100);
    });
  });
}
