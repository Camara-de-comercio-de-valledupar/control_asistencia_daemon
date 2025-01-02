import 'dart:async';

import 'package:control_asistencia_daemon/lib.dart';

class AuthenticationService {
  final HttpClient _client;
  static AuthenticationService? _instance;

  AuthenticationService(this._client);

  static AuthenticationService getInstance() {
    _instance ??= AuthenticationService(
      HttpClient.getInstance(),
    );
    return _instance!;
  }

  Future<Member> signInWithEmailAndPassword(
      String email, String password) async {
    final response = await _client.post(
      "/autenticar",
      {
        "username": email,
        "pass": password,
      },
    );

    return Member.fromJson(response["data"]);
  }

  Future<List<Permission>> getPermissions(int memberId) async {
    final response =
        await _client.get("/GetMenuFuncionario/empleados_id/$memberId");
    return permissionFromJson(response["datos"]);
  }
}
