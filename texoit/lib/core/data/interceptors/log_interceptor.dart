import 'package:dio/dio.dart';
import 'package:get/route_manager.dart';

import 'package:izlogging/log_service.dart';

class LoggInterceptor implements InterceptorsWrapper {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log.logNetworkError(
      url: err.requestOptions.uri.toString(),
      bodyRequest: err.requestOptions.data ?? err.requestOptions.queryParameters,
      bodyResponse: err.response?.data,
      statusCode: err.response?.statusCode ?? 500,
      method: err.requestOptions.method,
      headers: err.requestOptions.headers,
      error: err,
    );
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.i(
      'Request: ${options.method} ${options.uri}',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!Get.testMode) {
      log.logNetworkResponse(
        url: response.requestOptions.uri.toString(),
        bodyRequest: response.requestOptions.method == 'GET'
            ? response.requestOptions.queryParameters
            : response.requestOptions.data,
        bodyResponse: response.data,
        statusCode: response.statusCode ?? 500,
        method: response.requestOptions.method,
        headers: response.requestOptions.headers,
        testMode: Get.testMode || Get.isLogEnable,
      );
    }
    handler.next(response);
  }
}
