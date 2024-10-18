import 'package:control_asistencia_daemon/lib.dart';

class UserService {
  final HttpClient _client;
  static UserService? _instance;

  UserService(this._client);

  static UserService getInstance() {
    _instance ??= UserService(HttpClient.getInstance());
    return _instance!;
  }

  Future<List<User>> getUsers() async {
    final response = await _client.get<List>("/users/");
    return response.map((e) => User.fromJson(e)).toList();
  }

  Future<User> createUser(User user) async {
    final res = await _client.post("/users/", user.toJson());
    return User.fromJson(res);
  }

  Future<User> updateUser(User user) async {
    final res = await _client.put("/users/${user.id}", user.toJson());
    return User.fromJson(res);
  }

  Future<void> deleteUser(User user) async {
    await _client.delete("/users/${user.id}");
  }
}
