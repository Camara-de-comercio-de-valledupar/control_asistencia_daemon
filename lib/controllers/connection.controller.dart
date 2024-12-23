import 'package:control_asistencia_daemon/lib.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  final RxBool _isConnected = RxBool(true);

  // =================================================================

  bool get isConnected => _isConnected.value;

  // =================================================================

  @override
  void onReady() {
    super.onReady();
    debounce(_isConnected, _onConnectionChange,
        time: const Duration(seconds: 1));
    _listenConnectionPeriodically();
  }

  // =================================================================

  void _onConnectionChange(bool value) {
    if (!value) {
      Get.offAllNamed("/offline");
    } else {
      if (Get.currentRoute == "/offline") {
        Get.offAllNamed(Get.previousRoute);
      }
    }
  }

  // =================================================================

  void _listenConnectionPeriodically() {
    _listenConnection();
    Future.delayed(const Duration(seconds: 5), _listenConnectionPeriodically);
  }

  // =================================================================

  void _listenConnection() {
    Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
    )).get(appUrl).then((response) {
      _isConnected.value = true;
    }).catchError((e) {
      if (e is DioException &&
          (e.type == DioExceptionType.connectionError ||
              e.type == DioExceptionType.connectionTimeout)) {
        _isConnected.value = false;
      } else {
        _isConnected.value = true;
      }
    });
  }

  // =================================================================

  void retry() {
    Get.offAllNamed("/");
    _listenConnection();
  }
}
