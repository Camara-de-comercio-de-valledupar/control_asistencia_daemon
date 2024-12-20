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
}
