import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:izlogging/log_service.dart';
import 'package:izlogging/printter/my_printer.dart';
import 'package:izlogging/printter/network_printter.dart';
import 'package:logger/logger.dart';
import 'package:logger/web.dart';

class IzLogProvider extends Log {
  final String sessionId;
  final networkLogger = Logger(printer: NetworkErrorPrinter());
  final logg = Logger(printer: MyPrintter());
  PrettyPrinter printer = PrettyPrinter();

  IzLogProvider(this.sessionId);

  @override
  Future<void> setup() async {
    unawaited(setCustomKey('sessionId', sessionId));
    log('CrashlyticsLogProvider setup', Level.info);
  }

  @override
  Future<void> setUserKey(String userId) async {
    log('CrashlyticsLogProvider setUserKey: $userId', Level.info);
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    log('CrashlyticsLogProvider setCustomKey: $key, $value', Level.info);
  }

  @override
  Future<void> onFlutterError(FlutterErrorDetails details) async {
    log('CrashlyticsLogProvider onFlutterError: ${details.exception}', Level.error);
  }

  @override
  Future<void> setCurrentScreen(String currentPage) async {
    await setCustomKey('current-page', currentPage);
  }

  @override
  void logNetworkError({
    required String url,
    required Map<String, Object?>? bodyRequest,
    required Map<String, Object?>? bodyResponse,
    required int statusCode,
    required String method,
    required Map<String, Object?> headers,
    Object? error,
  }) {
    if (kDebugMode) {
      String responsebody = '';
      if (bodyResponse
          case {
            "message": String message,
          }) {
        responsebody = message.replaceAll("\n", " ");
      } else {
        responsebody = jsonEncode(bodyResponse);
      }
      final details = {
        'url': url,
        'method': method,
        'headers': headers,
        'statusCode': statusCode,
        'bodyRequest': bodyRequest,
        'bodyResponse': responsebody,
      };

      networkLogger.e(details, error: error);
    }
  }

  @override
  void logNetworkResponse({
    required String url,
    required Map<String, Object?>? bodyRequest,
    required dynamic bodyResponse,
    required int statusCode,
    required String method,
    required Map<String, Object?> headers,
    required bool testMode,
  }) {
    if (kDebugMode && !testMode) {
      String responsebody = '';
      if (bodyResponse
          case {
            "message": String message,
          }) {
        responsebody = message;
      } else {
        responsebody = jsonEncode(bodyResponse);
      }
      final details = {
        'url': url,
        'method': method,
        'headers': headers,
        'statusCode': statusCode,
        'bodyRequest': bodyRequest,
        'bodyResponse': responsebody,
      };

      networkLogger.i(details);
    }
  }

  @override
  void d(message, {DateTime? time, Object? exception, StackTrace? stackTrace}) {
    log(message, time: time, error: exception, stackTrace: stackTrace, Level.debug);
  }

  @override
  void e(message, {DateTime? time, Object? exception, StackTrace? stackTrace}) {
    log(message, time: time, error: exception, stackTrace: stackTrace, name: 'ERROR', Level.error);
  }

  @override
  void f(message, {DateTime? time, Object? exception, StackTrace? stackTrace}) {
    log(message, time: time, error: exception, stackTrace: stackTrace, name: 'FATAL', Level.fatal);
  }

  @override
  void i(message, {DateTime? time, Object? exception, StackTrace? stackTrace}) {
    log(message, time: time, error: exception, stackTrace: stackTrace, name: 'INFO', Level.info);
  }

  @override
  void t(message, {DateTime? time, Object? exception, StackTrace? stackTrace}) {
    log(message, time: time, error: exception, stackTrace: stackTrace, name: 'TRACE', Level.trace);
  }

  @override
  void w(message, {DateTime? time, Object? exception, StackTrace? stackTrace}) {
    log(message, time: time, error: exception, stackTrace: stackTrace, name: 'WARNING', Level.warning);
  }

  String formatCurlCommand(String method, Map<String, dynamic> headers, Map<String, dynamic>? bodyRequest, String url) {
    // Convertendo os cabeçalhos para a string de cabeçalhos do CURL
    String headersString = headers.entries.map((entry) => '-H "${entry.key}: ${entry.value}"').join(' ');
    String? bodyString;
    // Convertendo o bodyRequest para JSON
    if (bodyRequest != null) {
      bodyString = jsonEncode(bodyRequest);
    }

    // Construindo o comando CURL
    String curlCommand = 'curl -X $method $headersString -d ${bodyString != null ? '\'$bodyString\'' : ''} $url';

    return curlCommand;
  }

  void log(message, Level level, {DateTime? time, Object? error, StackTrace? stackTrace, String? name}) {
    if (kDebugMode) {
      logg.log(level, message, time: time, error: error, stackTrace: stackTrace);
    }
  }
}
