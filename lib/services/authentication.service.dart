import 'dart:async';

import 'package:control_asistencia_daemon/lib.dart';

class AuthenticationService {
  static final AuthenticationService instance =
      AuthenticationService._internal();

  AuthenticationService._internal();

  Future<Member> signInWithEmailAndPassword(
      String email, String password) async {
    // TODO: Implement authentication
    throw UnimplementedError();
  }

  FutureOr<Member?> get loggedInMember {
    // TODO: Implement authentication
    throw UnimplementedError();
  }

  Stream<Member?> get memberChanges {
    // TODO Implement authentication
    throw UnimplementedError();
  }

  Future<void> signOut() async {
    // TODO: Implement authentication
    throw UnimplementedError();
  }
}
