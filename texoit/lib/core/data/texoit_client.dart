import 'package:dio/dio.dart';
import 'package:texoit/core/data/interceptors/log_interceptor.dart';

class TexoItClient {
  late Dio dio;

  TexoItClient({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://tools.texoit.com',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            ) {
    this.dio.interceptors.add(LoggInterceptor());
  }

  factory TexoItClient.mocked(Dio dio) {
    return TexoItClient(dio: dio);
  }
}
