import 'dart:io';

import 'package:logging/logging.dart';

import 'log_formatter.dart';
import 'log_output.dart';

class FileLogOutput implements LogOutput {
  final String logDirectory;
  final String baseFileName;
  final int maxFileSize;
  final int maxBackupFiles;

  FileLogOutput({
    required this.logDirectory,
    this.baseFileName = 'app.log',
    this.maxFileSize = 5 * 1024 * 1024,
    this.maxBackupFiles = 3,
  }) {
    Directory(logDirectory).createSync(recursive: true);
  }

  @override
  void output(LogRecord record) {
    final line = LogFormatter.format(record);
    _writeSync(line);
  }

  void _writeSync(String line) {
    try {
      final file = File('$logDirectory/$baseFileName');
      final exists = file.existsSync();

      if (exists && file.lengthSync() > maxFileSize) {
        _rotateSync();
      }

      file.writeAsStringSync('$line\n', mode: FileMode.append);
    } catch (e) {
      stderr.writeln('FileLogOutput write error: $e');
    }
  }

  void _rotateSync() {
    final oldest =
        File('$logDirectory/$baseFileName.$maxBackupFiles');
    if (oldest.existsSync()) oldest.deleteSync();

    for (int i = maxBackupFiles - 1; i >= 1; i--) {
      final f = File('$logDirectory/$baseFileName.$i');
      if (f.existsSync()) {
        f.renameSync('$logDirectory/$baseFileName.${i + 1}');
      }
    }

    final current = File('$logDirectory/$baseFileName');
    if (current.existsSync()) {
      current.renameSync('$logDirectory/$baseFileName.1');
    }
  }
}
