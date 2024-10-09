import 'dart:async';

import 'package:control_asistencia_daemon/lib.dart';

class AuthenticationService {
  static final AuthenticationService instance =
      AuthenticationService._internal();

  AuthenticationService._internal();

  Future<Member> signInWithEmailAndPassword(
      String email, String password) async {
    return Member.empty();
  }

  FutureOr<Member?> get loggedInMember {
    return Member.empty();
  }

  Stream<Member?> get memberChanges {
    return Stream<Member?>.periodic(
      const Duration(seconds: 4),
      (int index) => Member.empty(),
    );
  }

  Future<void> signOut() async {
    // TODO: Implement authentication
    throw UnimplementedError();
  }
}
