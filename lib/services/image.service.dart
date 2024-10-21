import 'dart:typed_data';

import 'package:control_asistencia_daemon/lib.dart';

class ImageService {
  static ImageService? _instance;
  final HttpClient httpClient;

  ImageService._(this.httpClient);

  static ImageService getInstance() {
    _instance ??= ImageService._(HttpClient.getInstance());
    return _instance!;
  }

  Future<Uint8List> getImage(String url) async {
    final response = await httpClient.get("/viewer", {
      "url": url,
    });
    return response.bodyBytes;
  }
}
