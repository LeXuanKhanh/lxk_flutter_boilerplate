import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/rest/curl_logger_interceptor.dart';
import 'package:lxk_flutter_boilerplate/api_sdk/rest/dio_smart_retry/retry_interceptor.dart';

class DioResult {
  final dynamic result;
  final DioException? error;
  const DioResult({required this.result, required this.error});
}

abstract class BaseHttpHandler {
  Future<dynamic> get(String url,  {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  });
  Future<dynamic> post(String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });
  Future<dynamic> put(String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  });
  Future<dynamic> delete(String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  });
}

class DioHttpHandler extends BaseHttpHandler {
  DioHttpHandler._() {
    // _dio.interceptors.add(CurlLoggerInterceptor(logPrint: debugPrintLog));
    _dio.interceptors.add(RetryInterceptor(
      dio: _dio,
      logPrint: debugPrintLog,
      retries: 3
    ));
  }
  static final DioHttpHandler _instance = DioHttpHandler._();
  factory DioHttpHandler() => _instance;

  final _dio = Dio();

  @override
  Future<dynamic> delete(String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final Response<dynamic> response = await _dio.delete(
      url,
      data: data,
      queryParameters: queryParameters,
    );
    return response.data;
  }

  @override
  Future<dynamic> get(String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final Response<dynamic> response = await _dio.get(url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return response.data;
  }

  @override
  Future<dynamic> post(String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final Response<dynamic> response = await _dio.post(url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress);
    return response.data;
  }

  @override
  Future<dynamic> put(String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final Response<dynamic> response = await _dio.put(url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress
    );
    return response.data;
  }

  void debugPrintLog(Object object) {
    return log(object.toString());
  }
}
