import 'dart:io';
import 'package:logging/logging.dart';

/// Initializes the logging system.
///
/// Sets the root logger level based on [verbose] and attaches a listener
/// that writes formatted logs to [stdout] or [stderr].
void initLogging({bool verbose = false}) {
  // Use hierarchical logging to allow fine-grained control if needed.
  Logger.root.level = verbose ? Level.ALL : Level.INFO;

  Logger.root.onRecord.listen((record) {
    final message = _formatLogRecord(record);

    if (record.level >= Level.WARNING) {
      stderr.writeln(message);
    } else {
      stdout.writeln(message);
    }
  });
}

String _formatLogRecord(LogRecord record) {
  final timestamp = record.time.toIso8601String();
  final level = record.level.name.padRight(7);
  final loggerName = record.loggerName.isNotEmpty
      ? '[${record.loggerName}] '
      : '';

  var message = '$timestamp $level $loggerName${record.message}';

  if (record.error != null) {
    message += '\nError: ${record.error}';
  }

  if (record.stackTrace != null) {
    message += '\nStackTrace:\n${record.stackTrace}';
  }

  return message;
}
