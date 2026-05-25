import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Log Level
enum Level {
  /// No logs.
  none,

  /// Logs request and response lines.
  ///
  /// Example:
  ///  ```
  ///  --> POST /greeting
  ///
  ///  <-- 200 OK
  ///  ```
  basic,

  /// Logs request and response lines and their respective headers.
  ///
  ///  Example:
  /// ```
  /// --> POST /greeting
  /// Host: example.com
  /// Content-Type: plain/text
  /// Content-Length: 3
  /// --> END POST
  ///
  /// <-- 200 OK
  /// Content-Type: plain/text
  /// Content-Length: 6
  /// <-- END HTTP
  /// ```
  headers,

  /// Logs request and response lines and their respective headers and bodies (if present).
  ///
  /// Example:
  /// ```
  /// --> POST /greeting
  /// Host: example.com
  /// Content-Type: plain/text
  /// Content-Length: 3
  ///
  /// Hi?
  /// --> END POST
  ///
  /// <-- 200 OK
  /// Content-Type: plain/text
  /// Content-Length: 6
  ///
  /// Hello!
  /// <-- END HTTP
  /// ```
  body,
}

/// Lightweight Dio logger. Defaults to [LogLevel.body] in debug and
/// [LogLevel.none] in release. Switch level when wiring into [DioClient].
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor({
    Level? level,
    this.compact = false,
    void Function(String?)? logPrint,
  }) : level = level ?? (kDebugMode ? Level.body : Level.none),
       logPrint = logPrint ?? debugPrint;

  final Level level;
  final bool compact;
  final void Function(String?) logPrint;
  static const _encoder = JsonEncoder.withIndent('  ');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (level == Level.none) return handler.next(options);
    logPrint('--> ${options.method} ${options.uri}');
    if (level == Level.basic) return handler.next(options);

    options.headers.forEach((k, v) => logPrint('$k: $v'));
    if (level == Level.headers) return handler.next(options);

    if (options.data != null) _logPayload(options.data);
    logPrint('--> END ${options.method}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (level == Level.none) return handler.next(response);
    logPrint(
      '<-- ${response.statusCode} ${response.statusMessage ?? ''} ${response.requestOptions.uri}',
    );
    if (level == Level.basic) return handler.next(response);

    response.headers.forEach((k, v) => logPrint('$k: ${v.join(',')}'));
    if (level == Level.headers) return handler.next(response);

    if (response.data != null) _logPayload(response.data);
    logPrint('<-- END HTTP');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (level == Level.none) return handler.next(err);
    logPrint('<-- HTTP FAILED: ${err.message}');
    handler.next(err);
  }

  void _logPayload(dynamic data) {
    if (data is Map) {
      if (compact) {
        logPrint('$data');
      } else {
        _encoder.convert(data).split('\n').forEach(logPrint);
      }
    } else if (data is! FormData) {
      logPrint(data.toString());
    }
  }
}
