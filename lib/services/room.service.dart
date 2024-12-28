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

  Future<String> createRoom({
    required String roomName,
    required String roomDescription,
    required int roomCapacity,
    required int roomPricePerDay,
    required int roomPricePerMidday,
    required String roomLocation,
  }) async {
    final response = await _client.post(
      "/salosdeevento",
      {
        "nombresalon": roomName,
        "descripcion": roomDescription,
        "capacidad": roomCapacity,
        "valordia": roomPricePerDay,
        "valormediodia": roomPricePerMidday,
        "ubicacion": roomLocation,
      },
    );

    if (response["error"]) {
      throw Exception(response["mensaje"]);
    }

    return response["mensaje"];
  }

  Future<void> disableRoom(int roomId) async {
    final response = await _client.delete("/salosdeevento/$roomId");

    if (response["error"]) {
      throw Exception(response["mensaje"]);
    }
  }

  Future<void> enableRoom(int id) {
    return _client.post("/salosdeevento/$id/habilitar", {});
  }

  Future<String> updateRoom(
      {required int roomId,
      required String roomName,
      required String roomDescription,
      required int roomCapacity,
      required int roomPricePerDay,
      required int roomPricePerMidday,
      required String roomLocation,
      required String roomState}) async {
    final response = await _client.post("/salosdeevento/update", {
      'id': roomId,
      "nombresalon": roomName,
      "descripcion": roomDescription,
      "capacidad": roomCapacity,
      "valordia": roomPricePerDay,
      "valormediodia": roomPricePerMidday,
      "ubicacion": roomLocation,
      "estado": roomState,
    });
    if (response["error"]) {
      throw Exception(response["mensaje"]);
    }
    return response["mensaje"];
  }
}
