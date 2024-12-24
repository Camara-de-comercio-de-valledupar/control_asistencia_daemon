import 'package:control_asistencia_daemon/lib.dart';
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

  // =================================================================

  @override
  void onReady() {
    super.onReady();
    _fetchRooms();
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
}
