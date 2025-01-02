import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoomController extends GetxController {
  final RxList<Room> _rooms = <Room>[].obs;
  final RxList<Room> _filteredRooms = <Room>[].obs;

  // =================================================================

  List<Room> get rooms => _rooms;
  List<Room> get filteredRooms => _filteredRooms;

  // =================================================================

  final RxBool _loading = RxBool(false);

  // =================================================================

  bool get loading => _loading.value;

  // =================================================================

  final RoomService roomService = RoomService.getInstance();
  final CacheService cacheService = CacheService.getInstance();

  // =================================================================

  @override
  void onReady() {
    super.onReady();
    ever(_rooms, _saveRoomsOnCache, condition: (_) => !_loading.value);
    _fetchRoomsOnCache();
  }

  // =================================================================

  void _saveRoomsOnCache(List<Room> rooms) async {
    final roomsString = roomToJsonString(rooms);
    await cacheService.setString("cached_rooms", roomsString);
  }

  // =================================================================

  void _fetchRoomsOnCache() async {
    final roomsString = cacheService.getString("cached_rooms");
    if (roomsString != null) {
      final rooms = roomFromJsonString(roomsString);
      _rooms.assignAll(rooms);
      _filteredRooms.assignAll(rooms);
    } else {
      _fetchRooms();
    }
  }

  // =================================================================

  void _fetchRooms() async {
    _loading.value = true;
    final rooms = await roomService.getRooms().catchError(
      (error, stackTrace) {
        _loading.value = false;
        throw error;
      },
    );
    _rooms.assignAll(rooms);
    _filteredRooms.assignAll(rooms);
    _loading.value = false;
  }

  // =================================================================

  void filterRooms(String query) {
    if (query.isEmpty) {
      _filteredRooms.assignAll(_rooms);
      return;
    }
    _filteredRooms.assignAll(
      _rooms.where(
        (room) => room.nombresalon.toLowerCase().contains(query.toLowerCase()),
      ),
    );
  }

  // =================================================================

  void refreshRooms() {
    _fetchRooms();
  }

  // =================================================================

  void openCreateNewRoomDialog() {
    Get.dialog(const CreateNewRoomDialog(), barrierDismissible: false);
  }

  // =================================================================

  void openShowRoomDialog(Room room) async {
    final result = await Get.dialog<Room>(
      ShowRoomDialog(room: room),
      barrierDismissible: true,
      transitionCurve: Curves.fastOutSlowIn,
      transitionDuration: const Duration(milliseconds: 300),
      routeSettings: const RouteSettings(name: "/show_room_dialog"),
    );

    if (result != null) {
      final index = _rooms.indexWhere((r) => r.id == result.id);
      if (index != -1) {
        _rooms[index] = result;
        _filteredRooms[index] = result;
      }
    }
  }

  // =================================================================

  Future<Room?> openEditRoomDialog(Room room) {
    return Get.dialog<Room?>(
      EditRoomDialog(room: room),
      barrierDismissible: false,
    );
  }

  // =================================================================

  Future<Room?> disableRoom(Room room) {
    return Get.dialog<Room>(DisableRoomAlertDialog(room: room),
        barrierDismissible: false);
  }

  // =================================================================

  void confirmDisableRoom(Room room) async {
    try {
      await roomService.disableRoom(room.id);
      var newRoom = room.copyWith(estado: "Deshabilitado");
      _filteredRooms.remove(room);
      _rooms.remove(room);
      _rooms.add(newRoom);
      _filteredRooms.add(newRoom);

      Get.back(result: newRoom);
      Get.find<PushAlertController>().add(
        PushAlert(
          title: "Salón deshabilitado",
          body:
              "El salón ${room.nombresalon} ha sido deshabilitado correctamente.",
          type: PushAlertType.warning,
        ),
      );
    } catch (e) {
      Get.back();

      Get.find<PushAlertController>().add(
        PushAlertError(
          title: "Error al deshabilitar salón",
          body: e.toString(),
        ),
      );
    }
  }

  // =================================================================

  Future<Room?> enableRoom(Room room) {
    return Get.dialog<Room>(EnableRoomAlertDialog(room: room),
        barrierDismissible: false);
  }

  // =================================================================

  void confirmEnableRoom(Room room) async {
    try {
      await roomService.enableRoom(room.id);
      var newRoom = room.copyWith(estado: "Habilitado");
      _filteredRooms.remove(room);
      _rooms.remove(room);
      _rooms.add(newRoom);
      _filteredRooms.add(newRoom);

      Get.back(result: newRoom);
      Get.find<PushAlertController>().add(
        PushAlertSuccess(
          title: "Salón habilitado",
          body:
              "El salón ${room.nombresalon} ha sido habilitado correctamente.",
        ),
      );
    } catch (e) {
      Get.back();
      Get.find<PushAlertController>().add(
        PushAlertError(
          title: "Error al habilitar salón",
          body: e.toString(),
        ),
      );
    }
  }

  // =================================================================

  void openEditRoomImagesDialog(Room room) {
    Get.dialog(EditRoomImagesDialog(room: room), barrierDismissible: false);
  }
}
