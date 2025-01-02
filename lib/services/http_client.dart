import 'package:dio/dio.dart';

/// Interceptor que agrega el token de autorización a las solicitudes.
///
/// Este interceptor se encarga de agregar el token de autorización a las
/// cabeceras de las solicitudes HTTP si el token está disponible en el
/// servicio de caché.
class TokenInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // ...
  }
}

/// URL base de la aplicación.
const appUrl = "https://appccvalledupar.co/timeit/laravel/public/api/";

/// Instancia global de Dio.
late Dio dioInstance;

/// Configura la instancia global de Dio con las opciones base y los
/// interceptores necesarios.
void configureDio() {
  // ...
}

/// Cliente HTTP para realizar solicitudes HTTP.
///
/// Esta clase proporciona métodos para realizar solicitudes HTTP de tipo
/// POST, GET, PUT, DELETE y PATCH. Utiliza una instancia global de Dio
/// configurada previamente.
class HttpClient {
  static HttpClient? _instance;

  HttpClient._();

  /// Obtiene la instancia única de [HttpClient].
  ///
  /// Si la instancia no existe, se crea una nueva.
  static HttpClient getInstance() {
    _instance ??= HttpClient._();
    return _instance!;
  }

  /// Realiza una solicitud HTTP de tipo POST.
  ///
  /// [url] es la URL a la que se enviará la solicitud.
  /// [body] es el cuerpo de la solicitud.
  ///
  /// Retorna la respuesta de la solicitud.
  Future<T> post<T>(String url, Object? body) async {
    final response = await dioInstance.post(url, data: body);
    return response.data ?? {};
  }

  /// Realiza una solicitud HTTP de tipo GET.
  ///
  /// [url] es la URL a la que se enviará la solicitud.
  /// [params] son los parámetros de la consulta.
  ///
  /// Retorna la respuesta de la solicitud.
  Future<T> get<T>(String url, [Map<String, dynamic>? params]) async {
    final response = await dioInstance.get(url, queryParameters: params);
    return response.data;
  }

  /// Realiza una solicitud HTTP de tipo PUT.
  ///
  /// [url] es la URL a la que se enviará la solicitud.
  /// [body] es el cuerpo de la solicitud.
  ///
  /// Retorna la respuesta de la solicitud.
  Future<T> put<T>(String url, Map<String, dynamic> body) async {
    final response = await dioInstance.put(url, data: body);
    return response.data;
  }

  /// Realiza una solicitud HTTP de tipo DELETE.
  ///
  /// [url] es la URL a la que se enviará la solicitud.
  ///
  /// Retorna la respuesta de la solicitud.
  Future<T> delete<T>(String url) async {
    final response = await dioInstance.delete(url);
    return response.data;
  }

  /// Realiza una solicitud HTTP de tipo PATCH.
  ///
  /// [url] es la URL a la que se enviará la solicitud.
  /// [body] es el cuerpo de la solicitud.
  ///
  /// Retorna la respuesta de la solicitud.
  Future<T> patch<T>(String url, Map<String, dynamic> body) async {
    final response = await dioInstance.patch(url, data: body);
    return response.data;
  }
}
