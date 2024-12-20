import 'dart:async';

import 'package:control_asistencia_daemon/lib.dart';

class AuthenticationAppCCValleduparService {
  final HttpClientAppCCvalledupar _client;
  static AuthenticationAppCCValleduparService? _instance;

  AuthenticationAppCCValleduparService(this._client);

  static AuthenticationAppCCValleduparService getInstance() {
    _instance ??= AuthenticationAppCCValleduparService(
      HttpClientAppCCvalledupar.getInstance(),
    );
    return _instance!;
  }

  Future<MemberAppCCvalledupar> signInWithEmailAndPassword(
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

    return MemberAppCCvalledupar.fromJson(data);
  }
}
