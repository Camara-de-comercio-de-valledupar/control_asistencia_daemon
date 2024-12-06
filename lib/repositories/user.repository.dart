import 'package:control_asistencia_daemon/lib.dart';

class UserRepository {
  static final UserRepository instance = UserRepository._internal();

  UserRepository._internal();

  Future<MemberAppCCvalledupar?> getMember(String id) async {
    return null;
  }

  Future<List<MemberAppCCvalledupar>> getMembers() async {
    return [];
  }
}
