import 'package:logging/logging.dart';

abstract class LogOutput {
  void output(LogRecord record);
}
