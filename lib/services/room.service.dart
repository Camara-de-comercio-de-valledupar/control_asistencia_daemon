import 'package:control_asistencia_daemon/lib.dart';

class RoomService {
  final HttpClient _client;
  static RoomService? _instance;

  RoomService(this._client);

  static RoomService getInstance() {
    _instance ??= RoomService(
      HttpClient.getInstance(),
    );
    return _instance!;
  }

  Future<List<Room>> getRooms() async {
    final response = await _client.get("/salosdeevento");

    return roomFromJson(response["datos"]);
  }
}
