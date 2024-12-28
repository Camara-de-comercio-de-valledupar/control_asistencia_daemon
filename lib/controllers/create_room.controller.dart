import 'package:control_asistencia_daemon/lib.dart';
import 'package:get/get.dart';

class CreateRoomController extends GetxController {
  final String? initialRoomName;
  final String? initialRoomDescription;
  final int? initialRoomCapacity;
  final int? initialRoomPricePerDay;
  final int? initialRoomPricePerMidday;
  final String? initialRoomLocation;

  // =================================================================

  CreateRoomController({
    this.initialRoomName,
    this.initialRoomDescription,
    this.initialRoomCapacity,
    this.initialRoomPricePerDay,
    this.initialRoomPricePerMidday,
    this.initialRoomLocation,
  });

  // =================================================================

  final RoomService _roomService = RoomService.getInstance();

  // =================================================================

  final RxString _roomName = "".obs;
  final RxString _roomDescription = "".obs;
  final RxInt _roomCapacity = 0.obs;
  final RxInt _roomPricePerDay = 0.obs;
  final RxInt _roomPricePerMidday = 0.obs;
  final RxBool _loading = false.obs;
  final RxString _roomLocation = "".obs;

  // =================================================================

  String get roomName => _roomName.value;
  String get roomDescription => _roomDescription.value;
  int get roomCapacity => _roomCapacity.value;
  int get roomPricePerDay => _roomPricePerDay.value;
  int get roomPricePerMidday => _roomPricePerMidday.value;
  bool get loading => _loading.value;
  String get roomLocation => _roomLocation.value;

  // =================================================================

  void setRoomName(String value) => _roomName.value = value;
  void setRoomDescription(String value) => _roomDescription.value = value;
  void setRoomCapacity(int value) => _roomCapacity.value = value;
  void setRoomPricePerDay(int value) => _roomPricePerDay.value = value;
  void setRoomPricePerMidday(int value) => _roomPricePerMidday.value = value;
  void setRoomLocation(String value) => _roomLocation.value = value;

  // =================================================================

  @override
  void onInit() {
    super.onInit();
    setRoomName(initialRoomName ?? "");
    setRoomDescription(initialRoomDescription ?? "");
    setRoomCapacity(initialRoomCapacity ?? 0);
    setRoomPricePerDay(initialRoomPricePerDay ?? 0);
    setRoomPricePerMidday(initialRoomPricePerMidday ?? 0);
    setRoomLocation(initialRoomLocation ?? "");
  }

  // =================================================================

  void createRoom() async {
    _loading.value = true;
    try {
      await _roomService.createRoom(
        roomName: roomName,
        roomDescription: roomDescription,
        roomCapacity: roomCapacity,
        roomPricePerDay: roomPricePerDay,
        roomPricePerMidday: roomPricePerMidday,
        roomLocation: roomLocation,
      );

      Get.find<PushAlertController>().add(PushAlertSuccess(
        title: "Salón creado",
        body: "El salón $roomName ha sido creado correctamente",
      ));

      Get.back();
    } catch (error) {
      Get.find<PushAlertController>().add(PushAlertError(
        title: "Error al crear salón",
        body: error.toString(),
      ));
    } finally {
      _loading.value = false;
    }
  }

  void updateRoom(Room room) async {
    _loading.value = true;
    try {
      await _roomService.updateRoom(
        roomId: room.id,
        roomName: roomName,
        roomDescription: roomDescription,
        roomCapacity: roomCapacity,
        roomPricePerDay: roomPricePerDay,
        roomPricePerMidday: roomPricePerMidday,
        roomLocation: roomLocation,
        roomState: "Habilitado",
      );
      final updatedRoom = room.copyWith(
        nombresalon: roomName,
        descripcion: roomDescription,
        capacidad: roomCapacity,
        valordia: roomPricePerDay,
        valormediodia: roomPricePerMidday,
        ubicacion: roomLocation,
        estado: "Habilitado",
      );

      Get.back(result: updatedRoom);

      Get.find<PushAlertController>().add(PushAlertSuccess(
        title: "Salón actualizado",
        body: "El salón $roomName ha sido actualizado correctamente",
      ));
    } catch (error) {
      Get.back();
      Get.find<PushAlertController>().add(PushAlertError(
        title: "Error al actualizar salón",
        body: error.toString(),
      ));
    } finally {
      _loading.value = false;
    }
  }
}
