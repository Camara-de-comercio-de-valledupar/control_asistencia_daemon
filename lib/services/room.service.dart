import 'dart:typed_data';

import 'package:control_asistencia_daemon/lib.dart';
import 'package:dio/dio.dart';

/// Servicio para gestionar las salas de eventos.
///
/// Proporciona métodos para obtener, crear, actualizar, habilitar, deshabilitar y eliminar imágenes de las salas de eventos.
class RoomService {
  /// Instancia única de [RoomService].
  ///
  /// Utiliza un cliente HTTP para realizar las solicitudes.
  static RoomService? _instance;

  /// Cliente HTTP para realizar las solicitudes.
  ///
  /// Utiliza la clase [HttpClient].
  ///
  /// Ver [HttpClient] para más información.
  final HttpClient _client;

  /// Constructor privado para la clase [RoomService].
  ///
  /// Utiliza un cliente HTTP para realizar las solicitudes.
  RoomService(this._client);

  /// Obtiene una instancia única de [RoomService].
  ///
  /// Si no existe una instancia, crea una nueva.
  static RoomService getInstance() {
    _instance ??= RoomService(
      HttpClient.getInstance(),
    );
    return _instance!;
  }

  /// Obtiene una lista de salas de eventos.
  ///
  /// Realiza una solicitud GET a la ruta "/salosdeevento".
  ///
  /// Retorna una lista de objetos [Room].
  Future<List<Room>> getRooms() async {
    final response = await _client.get("/salosdeevento");

    return roomFromJson(response["datos"]);
  }

  /// Crea una nueva sala de eventos.
  ///
  /// Requiere los siguientes parámetros:
  /// - [roomName]: Nombre de la sala.
  /// - [roomDescription]: Descripción de la sala.
  /// - [roomCapacity]: Capacidad de la sala.
  /// - [roomPricePerDay]: Precio por día de la sala.
  /// - [roomPricePerMidday]: Precio por medio día de la sala.
  /// - [roomLocation]: Ubicación de la sala.
  ///
  /// Realiza una solicitud POST a la ruta "/salosdeevento".
  ///
  /// Retorna un mensaje de éxito.
  ///
  /// Lanza una excepción si hay un error en la respuesta.
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

  /// Deshabilita una sala de eventos.
  ///
  /// Requiere el [roomId] de la sala a deshabilitar.
  ///
  /// Realiza una solicitud DELETE a la ruta "/salosdeevento/{roomId}".
  ///
  /// Lanza una excepción si hay un error en la respuesta.
  Future<void> disableRoom(int roomId) async {
    final response = await _client.delete("/salosdeevento/$roomId");

    if (response["error"]) {
      throw Exception(response["mensaje"]);
    }
  }

  /// Habilita una sala de eventos.
  ///
  /// Requiere el [id] de la sala a habilitar.
  ///
  /// Realiza una solicitud POST a la ruta "/salosdeevento/{id}/habilitar".
  Future<void> enableRoom(int id) {
    return _client.post("/salosdeevento/$id/habilitar", {});
  }

  /// Actualiza una sala de eventos.
  ///
  /// Requiere los siguientes parámetros:
  /// - [roomId]: ID de la sala.
  /// - [roomName]: Nombre de la sala.
  /// - [roomDescription]: Descripción de la sala.
  /// - [roomCapacity]: Capacidad de la sala.
  /// - [roomPricePerDay]: Precio por día de la sala.
  /// - [roomPricePerMidday]: Precio por medio día de la sala.
  /// - [roomLocation]: Ubicación de la sala.
  /// - [roomState]: Estado de la sala.
  ///
  /// Realiza una solicitud POST a la ruta "/salosdeevento/update".
  ///
  /// Retorna un mensaje de éxito.
  ///
  /// Lanza una excepción si hay un error en la respuesta.
  Future<String> updateRoom({
    required int roomId,
    required String roomName,
    required String roomDescription,
    required int roomCapacity,
    required int roomPricePerDay,
    required int roomPricePerMidday,
    required String roomLocation,
    required String roomState,
  }) async {
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

  /// Actualiza las imágenes de una sala de eventos.
  ///
  /// Requiere los siguientes parámetros:
  /// - [room]: Objeto [Room] de la sala.
  /// - [images]: Lista de imágenes en formato [Uint8List].
  ///
  /// Realiza una solicitud POST a la ruta "/salosdeevento/imagenes".
  ///
  /// Lanza una excepción si hay un error en la respuesta.
  Future<void> updateRoomImages(Room room, List<Uint8List> images) async {
    final data = FormData();
    data.fields.add(MapEntry("salones_imagenes_id", room.id.toString()));
    data.files.addAll(
      images.map(
        (image) {
          final index = (images.indexOf(image)) + 1;
          return MapEntry(
            "file$index",
            MultipartFile.fromBytes(
              image,
              filename: "image$index.jpg",
            ),
          );
        },
      ).toList(),
    );
    final response = await _client.post("/salosdeevento/imagenes", data);

    if (response["error"]) {
      throw Exception(response["mensaje"]);
    }
  }

  /// Elimina todas las imágenes de una sala de eventos.
  ///
  /// Requiere el [room] de la sala.
  ///
  /// Realiza una solicitud POST a la ruta "/salosdeevento/imagenes/eliminar".
  ///
  /// Lanza una excepción si hay un error en la respuesta.
  Future<void> removeAllRoomImages(Room room) async {
    final response = await _client.post(
      "/salosdeevento/imagenes/eliminar",
      {
        "salones_imagenes_id": room.id,
      },
    );

    if (response["error"]) {
      throw Exception(response["mensaje"]);
    }
  }
}
