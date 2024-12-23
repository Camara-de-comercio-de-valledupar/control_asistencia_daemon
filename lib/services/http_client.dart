import 'package:control_asistencia_daemon/lib.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final cacheService = CacheService.getInstance();
    final token = cacheService.getString("token");
    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }
    super.onRequest(options, handler);
  }
}

class PushAlertInterceptor extends Interceptor {
  @override
  void onResponse(dynamic response, ResponseInterceptorHandler handler) {
    if (response.data is Map<String, dynamic> &&
        response.data.containsKey("message") &&
        response.data["data"] is List &&
        response.data["data"].isEmpty) {
      if (kDebugMode) {
        print("response.data: ${response.data}");
      }
      Get.find<PushAlertController>().add(PushAlertError(
        title: "Ups! algo salió mal",
        body: response.data["message"],
      ));
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      Get.offAllNamed("/offline");
    }
    if (err.response?.statusCode == 500) {
      if (err.response?.data != null &&
          err.response!.data is Map<String, dynamic>) {
        Get.find<PushAlertController>().add(PushAlertError(
          title: "Ups! algo salió mal",
          body: err.response!.data["message"],
        ));
      } else {
        Get.find<PushAlertController>().add(PushAlertError(
          title: "Ups! algo salió mal",
          body: "Tal vez el servidor no responde",
        ));
      }
    }

    super.onError(err, handler);
  }
}

const appUrl = "https://appccvalledupar.co/timeit/laravel/public/api/";

late Dio dioInstance;

void configureDio() {
  dioInstance = Dio(BaseOptions(
    baseUrl: appUrl,
  ))
    ..interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
    ))
    ..interceptors.add(PushAlertInterceptor());
}

class HttpClient {
  static HttpClient? _instance;

  HttpClient._();

  static HttpClient getInstance() {
    _instance ??= HttpClient._();
    return _instance!;
  }

  Future<T> post<T>(String url, Object? body) async {
    final response = await dioInstance.post(url, data: body);
    return response.data ?? {};
  }

  Future<T> get<T>(String url, [Map<String, dynamic>? params]) async {
    final response = await dioInstance.get(url, queryParameters: params);
    return response.data;
  }

  Future<T> put<T>(String url, Map<String, dynamic> body) async {
    final response = await dioInstance.put(url, data: body);
    return response.data;
  }

  Future<T> delete<T>(String url) async {
    final response = await dioInstance.delete(url);
    return response.data;
  }

  Future<T> patch<T>(String url, Map<String, dynamic> body) async {
    final response = await dioInstance.patch(url, data: body);
    return response.data;
  }
}
