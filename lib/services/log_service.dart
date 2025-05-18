import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

class LogService {
  static bool _initialized = false;

  // Remove color codes for environments that don't support them

  static void init() {
    // Prevent multiple initialization
    if (_initialized) return;
    _initialized = true;

    // Only show logs in debug mode
    if (kDebugMode) {
      Logger.root.level = Level.INFO;

      Logger.root.onRecord.listen((record) {
        final emoji = _getEmoji(record.level);
        final level = record.level.name.padRight(7); // Align levels

        // Simple, clean format without color codes
        final message =
            '[$level] $emoji ${record.loggerName}: ${record.message}';
        debugPrint(message);

        // Log error and stack trace if present
        if (record.error != null) {
          debugPrint('  └─ Error: ${record.error}');
        }
        if (record.stackTrace != null) {
          debugPrint('  └─ Stack: ${record.stackTrace}');
        }
      });
    }
  }

  static String _getEmoji(Level level) {
    switch (level) {
      case Level.FINEST:
        return '🔍';
      case Level.FINER:
        return '🔧';
      case Level.FINE:
        return '📝';
      case Level.INFO:
        return 'ℹ️ ';
      case Level.WARNING:
        return '⚠️ ';
      case Level.SEVERE:
        return '🚨';
      case Level.SHOUT:
        return '💥';
      default:
        return ' ';
    }
  }

  // Convenience methods with specific loggers for better context
  static void debug(String message, [Object? error, StackTrace? stackTrace]) {
    Logger('Debug').fine(message, error, stackTrace);
  }

  static void info(String message, [Object? error, StackTrace? stackTrace]) {
    Logger('System').info(message, error, stackTrace);
  }

  static void warning(String message, [Object? error, StackTrace? stackTrace]) {
    Logger('Warning').warning(message, error, stackTrace);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    Logger('Error').severe(message, error, stackTrace);
  }

  // Add specific loggers for different parts of the app
  static void network(String message, [Object? error, StackTrace? stackTrace]) {
    Logger('Network').info(message, error, stackTrace);
  }

  static void sync(String message, [Object? error, StackTrace? stackTrace]) {
    Logger('Sync').info(message, error, stackTrace);
  }

  static void database(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    Logger('Database').info(message, error, stackTrace);
  }
}
