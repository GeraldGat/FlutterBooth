import 'package:logging/logging.dart';

import 'log_formatter.dart';
import 'log_output.dart';

class ConsoleLogOutput implements LogOutput {
  @override
  void output(LogRecord record) {
    // ignore: avoid_print
    print(LogFormatter.format(record));
  }
}
