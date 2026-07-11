import 'package:logging/logging.dart';

class LogFormatter {
  static String format(LogRecord record) {
    final time = record.time.toString().split('.').first;
    final level = record.level.name.padRight(7);
    final name = record.loggerName;
    final msg = record.message;
    final error = record.error != null ? ' | ${record.error}' : '';
    final stack =
        record.stackTrace != null ? '\n${record.stackTrace}' : '';
    return '$time [$level] $name: $msg$error$stack';
  }
}
