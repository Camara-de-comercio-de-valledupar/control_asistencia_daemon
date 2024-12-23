import 'dart:typed_data';

import 'package:dio/dio.dart';

Future<Uint8List?> networkToUint8List(String? url) {
  if (url == null) return Future.value(null);
  final encodedUrl = Uri.encodeFull(url);
  Dio dio = Dio();

  dio
    ..options = BaseOptions(
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    )
    ..httpClientAdapter = HttpClientAdapter()
    ..interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
      requestHeader: true,
      responseHeader: true,
      error: true,
    ));
  return dio
      .get<Uint8List>(encodedUrl,
          options: Options(responseType: ResponseType.bytes))
      .then((response) => response.data)
      .catchError((error) => null);
}
