import 'package:flutter/material.dart';

abstract class Log {
  Future<void> setup();
  Future<void> setCustomKey(String key, Object value);
  Future<void> setUserKey(String userId);
  Future<void> onFlutterError(FlutterErrorDetails details);
  Future<void> setCurrentScreen(String currentPage);
  void logNetworkError({
    required String url,
    required Map<String, Object?>? bodyRequest,
    required Map<String, Object?>? bodyResponse,
    required int statusCode,
    required String method,
    required Map<String, Object?> headers,
    Object? error,
  });
  void logNetworkResponse({
    required String url,
    required Map<String, Object?>? bodyRequest,
    required Map<String, Object?>? bodyResponse,
    required int statusCode,
    required String method,
    required Map<String, Object?> headers,
    required bool testMode,
  });
  void d(message, {DateTime? time, Object? exception, StackTrace? stackTrace});

  void e(message, {DateTime? time, Object? exception, StackTrace? stackTrace});
  void f(message, {DateTime? time, Object? exception, StackTrace? stackTrace});

  void i(message, {DateTime? time, Object? exception, StackTrace? stackTrace});

  void t(message, {DateTime? time, Object? exception, StackTrace? stackTrace});

  void w(message, {DateTime? time, Object? exception, StackTrace? stackTrace});
}

late Log log;
