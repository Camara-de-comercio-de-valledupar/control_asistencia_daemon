/// Servicio para manejar operaciones relacionadas con imágenes.
///
/// Esta clase sigue el patrón Singleton para asegurar que solo exista una
/// instancia de `ImageService` en toda la aplicación.
///
/// Métodos:
/// - `getInstance`: Obtiene la instancia única de `ImageService`.
/// - `getImage`: Descarga una imagen desde una URL proporcionada.
///
/// Uso:
/// ```dart
/// final imageService = ImageService.getInstance();
/// final imageBytes = await imageService.getImage('https://example.com/image.png');
/// ```
library;

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
