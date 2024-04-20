import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:texoit/app/data/interceptors/log_interceptor.dart';

class TexoItClient {
  late Dio dio;

  TexoItClient({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://api.themoviedb.org/3',
                connectTimeout: const Duration(seconds: kDebugMode ? 30 : 10),
                receiveTimeout: const Duration(seconds: kDebugMode ? 30 : 10),
              ),
            ) {
    this.dio.interceptors.add(LoggInterceptor());
  }
}
