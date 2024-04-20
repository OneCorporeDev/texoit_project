import 'package:client/result.dart';
import 'package:dio/dio.dart';

extension DioExtension on Dio {
  Future<Result<DioException, Response>> getSafe(String path,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      final response = await get(path, queryParameters: queryParameters, options: options);
      return Ok(response);
    } on DioException catch (e) {
      return Err(e);
    } catch (e) {
      return Err(DioException(requestOptions: RequestOptions(path: path), error: e, type: DioExceptionType.unknown));
    }
  }

  Future<Result<DioException, Response>> postSafe(String path,
      {Map<String, dynamic>? queryParameters, dynamic data, Options? options}) async {
    try {
      final response = await post(path, queryParameters: queryParameters, data: data, options: options);
      return Ok(response);
    } on DioException catch (e) {
      return Err(e);
    } catch (e) {
      return Err(DioException(requestOptions: RequestOptions(path: path), error: e, type: DioExceptionType.unknown));
    }
  }

  Future<Result<DioException, Response>> putSafe(String path,
      {Map<String, dynamic>? queryParameters, dynamic data, Options? options}) async {
    try {
      final response = await put(path, queryParameters: queryParameters, data: data, options: options);
      return Ok(response);
    } on DioException catch (e) {
      return Err(e);
    } catch (e) {
      return Err(DioException(requestOptions: RequestOptions(path: path), error: e, type: DioExceptionType.unknown));
    }
  }

  Future<Result<DioException, Response>> deleteSafe(String path,
      {Map<String, dynamic>? queryParameters, dynamic data, Options? options}) async {
    try {
      final response = await delete(path, queryParameters: queryParameters, data: data, options: options);
      return Ok(response);
    } on DioException catch (e) {
      return Err(e);
    } catch (e) {
      return Err(DioException(requestOptions: RequestOptions(path: path), error: e, type: DioExceptionType.unknown));
    }
  }

  Future<Result<DioException, Response>> patchSafe(String path,
      {Map<String, dynamic>? queryParameters, dynamic data, Options? options}) async {
    try {
      final response = await patch(path, queryParameters: queryParameters, data: data, options: options);
      return Ok(response);
    } on DioException catch (e) {
      return Err(e);
    } catch (e) {
      return Err(DioException(requestOptions: RequestOptions(path: path), error: e, type: DioExceptionType.unknown));
    }
  }

  Future<Result<DioException, Response>> fetchSafe(RequestOptions requestOptions) async {
    try {
      final response = await fetch(requestOptions);
      return Ok(response);
    } on DioException catch (e) {
      return Err(e);
    } catch (e) {
      return Err(DioException(requestOptions: requestOptions, error: e, type: DioExceptionType.unknown));
    }
  }
}

extension DioErrorExtension on DioException {
  String getResponseError() {
    return '${requestOptions.path} => ${response?.statusCode} ${response?.data is Map ? response?.data['message'] : response?.data.toString()}';
  }
}
