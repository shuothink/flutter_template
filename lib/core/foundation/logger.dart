import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AppLogger {
  AppLogger._();

  static const String _defaultTag = 'app';

  static void d(String message, {String tag = _defaultTag}) {
    if (!kDebugMode) return;
    debugPrint('[$tag][D] $message');
  }

  static void i(String message, {String tag = _defaultTag}) {
    debugPrint('[$tag][I] $message');
  }

  static void w(String message, {String tag = _defaultTag}) {
    debugPrint('[$tag][W] $message');
  }

  static void e(
    String message, {
    String tag = _defaultTag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    debugPrint('[$tag][E] $message');
    if (error != null) {
      debugPrint('[$tag][E] Error: $error');
    }
    if (stackTrace != null) {
      debugPrint('[$tag][E] StackTrace:\n$stackTrace');
    }
  }

  static Interceptor dioLogger({
    bool requestHeader = false,
    bool requestBody = true,
    bool responseBody = true,
    bool responseHeader = false,
    bool error = true,
    bool compact = true,
    int maxWidth = 120,
  }) {
    return PrettyDioLogger(
      requestHeader: requestHeader,
      requestBody: requestBody,
      responseBody: responseBody,
      responseHeader: responseHeader,
      error: error,
      compact: compact,
      maxWidth: maxWidth,
    );
  }
}
