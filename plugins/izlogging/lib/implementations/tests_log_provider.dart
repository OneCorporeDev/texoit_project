// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:izlogging/log_service.dart';
import 'package:izlogging/printter/my_printer.dart';
import 'package:izlogging/printter/network_printter.dart';
import 'package:logger/logger.dart';

class TestsLogProvider extends Log {
  final String sessionId;
  final logg = Logger(printer: MyPrintter());
  final networkLogger = Logger(printer: NetworkErrorPrinter(colored: true));

  TestsLogProvider(
    this.sessionId,
  );

  @override
  Future<void> setup() async {
    unawaited(setCustomKey('sessionId', sessionId));
    log('TestsLogProvider setup', Level.info);
  }

  @override
  Future<void> setUserKey(String userId) async {
    log('TestsLogProvider setUserKey: $userId', Level.info);
  }

  @override
  Future<void> setCustomKey(String key, Object value) async {
    log('TestsLogProvider setCustomKey: $key, $value', Level.info);
  }

  @override
  Future<void> onFlutterError(FlutterErrorDetails details) async {
    log('TestsLogProvider onFlutterError: ${details.exception}', Level.error, stackTrace: details.stack);
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

  @override
  void logNetworkResponse(
      {required String url,
      required Map<String, Object?>? bodyRequest,
      required dynamic bodyResponse,
      required int statusCode,
      required String method,
      required Map<String, Object?> headers,
      required bool testMode}) {
    if (kDebugMode || testMode) {
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
    log(message, Level.debug, time: time, error: exception, stackTrace: stackTrace);
  }

  @override
  void e(message, {DateTime? time, Object? exception, StackTrace? stackTrace}) {
    log(message, Level.error, time: time, error: exception, stackTrace: stackTrace);
  }

  @override
  void f(message, {DateTime? time, Object? exception, StackTrace? stackTrace}) {
    log(message, Level.fatal, time: time, error: exception, stackTrace: stackTrace);
  }

  @override
  void i(message, {DateTime? time, Object? exception, StackTrace? stackTrace}) {
    log(message, Level.info, time: time, error: exception, stackTrace: stackTrace);
  }

  @override
  void t(message, {DateTime? time, Object? exception, StackTrace? stackTrace}) {
    log(message, Level.trace, time: time, error: exception, stackTrace: stackTrace);
  }

  @override
  void w(message, {DateTime? time, Object? exception, StackTrace? stackTrace}) {
    log(message, Level.warning, time: time, error: exception, stackTrace: stackTrace);
  }

  void log(message, Level level, {DateTime? time, Object? error, StackTrace? stackTrace, String? name}) {
    if (kDebugMode) {
      logg.log(level, message, time: time, error: error, stackTrace: stackTrace);
    }
  }
}
