import 'dart:typed_data';

import 'package:control_asistencia_daemon/lib.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditImageRoomController extends GetxController {
  final Room room;

  // =================================================================

  EditImageRoomController({
    required this.room,
  });

  // =================================================================

  final RxList<Uint8List> _images = <Uint8List>[].obs;
  final RxBool _loading = RxBool(false);

  // =================================================================

  List<Uint8List> get images => _images;
  bool get loading => _loading.value;

  // =================================================================

  final RoomService roomService = RoomService.getInstance();

  // =================================================================

  void addImage(Uint8List image) {
    _images.add(image);
  }

  void removeImage(Uint8List image) {
    _images.remove(image);
  }

  // =================================================================

  void updateRoom() async {
    _loading.value = true;
    try {
      await roomService.updateRoomImages(room, _images);
      Get.back();
      Get.find<PushAlertController>().add(PushAlertSuccess(
        title: "Fotos actualizadas",
        body:
            "Las fotos del salón \"${room.nombresalon}\" han sido actualizadas correctamente",
      ));
    } catch (e) {
      Get.find<PushAlertController>().add(PushAlertError(
        title: "Error al actualizar fotos",
        body: e.toString(),
      ));
    } finally {
      _loading.value = false;
    }
  }

  // =================================================================

  void pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      addImage(bytes);
    }
  }

  // =================================================================

  void addExistingImage(String imageUrl) async {
    final bytes = await networkToUint8List(imageUrl);
    if (bytes != null) {
      addImage(bytes);
    }
  }

  // =================================================================

  void removeAllImages() async {
    try {
      await roomService.removeAllRoomImages(room);
      Get.back();
      Get.find<PushAlertController>().add(PushAlertSuccess(
        title: "Fotos eliminadas",
        body: "Las fotos del salón \"${room.nombresalon}\" han sido eliminadas",
      ));
    } catch (e) {
      Get.find<PushAlertController>().add(PushAlertError(
        title: "Error al eliminar fotos",
        body: e.toString(),
      ));
    }
  }
}
