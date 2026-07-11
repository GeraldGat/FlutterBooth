import 'package:logging/logging.dart';

import 'log_output.dart';

class AppLogger {
  static final Logger _logger = Logger('Flutterbooth');
  static bool _initialized = false;

  static Future<void> init({
    required List<LogOutput> outputs,
    Level level = Level.ALL,
  }) async {
    if (_initialized) return;
    _initialized = true;

    Logger.root.level = level;

    Logger.root.onRecord.listen((record) {
      for (final output in outputs) {
        output.output(record);
      }
    });
  }

  static void testReset() {
    Logger.root.clearListeners();
    _initialized = false;
  }

  static void d(String message) => _logger.fine(message);

  static void i(String message) => _logger.info(message);

  static void w(String message) => _logger.warning(message);

  static void e(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) =>
      _logger.severe(message, error, stackTrace);
}
