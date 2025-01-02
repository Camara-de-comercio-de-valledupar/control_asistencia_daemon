import 'package:control_asistencia_daemon/lib.dart';

/// Servicio de Autenticación
///
/// Proporciona métodos para la autenticación de usuarios y la obtención de permisos.
class AuthenticationService {
  /// Cliente HTTP utilizado para realizar solicitudes.
  final HttpClient _client;

  /// Instancia única de AuthenticationService.
  static AuthenticationService? _instance;

  /// Constructor privado para inicializar el servicio de autenticación con un cliente HTTP.
  AuthenticationService(this._client);

  /// Obtiene la instancia única de AuthenticationService.
  ///
  /// Si la instancia no existe, se crea una nueva utilizando un cliente HTTP.
  static AuthenticationService getInstance() {
    _instance ??= AuthenticationService(
      HttpClient.getInstance(),
    );
    return _instance!;
  }

  /// Inicia sesión con correo electrónico y contraseña.
  ///
  /// Realiza una solicitud POST a la ruta "/autenticar" con el correo electrónico y la contraseña proporcionados.
  /// Luego, obtiene información adicional del miembro autenticado desde la ruta "/hojasdevidas/{id}".
  /// Si el miembro tiene una foto, se agrega la URL completa de la foto a los datos del miembro.
  ///
  /// Retorna una instancia de [Member] con los datos del miembro autenticado.
  ///
  /// Parámetros:
  /// - [email]: Correo electrónico del usuario.
  /// - [password]: Contraseña del usuario.
  Future<Member> signInWithEmailAndPassword(
      String email, String password) async {
    final response = await _client.post(
      "/autenticar",
      {
        "username": email,
        "pass": password,
      },
    );

    final infoResp =
        await _client.get("/hojasdevidas/${response["data"]["id"]}");

    String? photo =
        infoResp[0].containsKey("foto") ? infoResp[0]["foto"] : null;

    if (photo != null) {
      photo =
          "https://appccvalledupar.co/timeittemporal/img/fotoshojadevida/$photo";
    }

    Map<String, dynamic> data = {
      ...response["data"],
      "foto": photo,
    };

    return Member.fromJson(data);
  }

  /// Obtiene los permisos de un miembro.
  ///
  /// Realiza una solicitud GET a la ruta "/GetMenuFuncionario/empleados_id/{memberId}" para obtener los permisos del miembro con el ID proporcionado.
  ///
  /// Retorna una lista de instancias de [Permission] con los permisos del miembro.
  ///
  /// Parámetros:
  /// - [memberId]: ID del miembro.
  Future<List<Permission>> getPermissions(int memberId) async {
    final response =
        await _client.get("/GetMenuFuncionario/empleados_id/$memberId");
    return permissionFromJson(response["datos"]);
  }
}
