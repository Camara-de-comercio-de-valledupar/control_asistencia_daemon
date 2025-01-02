import 'dart:typed_data';

import 'package:dio/dio.dart';

Future<Uint8List?> networkToUint8List(String? url) {
  if (url == null) return Future.value(null);
  final encodedUrl = Uri.encodeFull(url);
  Dio dio = Dio();

  dio
    ..options = BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    )
    ..httpClientAdapter = HttpClientAdapter();
  return dio
      .get<Uint8List>(encodedUrl,
          options: Options(responseType: ResponseType.bytes))
      .then((response) => response.data)
      .catchError((error) => null);
}
