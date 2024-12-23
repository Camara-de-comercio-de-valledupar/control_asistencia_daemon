import 'package:control_asistencia_daemon/lib.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  final RxBool _isConnected = RxBool(true);

  // =================================================================

  bool get isConnected => _isConnected.value;

  // =================================================================

  @override
  void onReady() {
    super.onReady();
    ever(
      _isConnected,
      _onConnectionChange,
    );
    _listenConnectionPeriodically();
  }

  // =================================================================

  void _onConnectionChange(bool value) {
    if (kDebugMode) {
      print("ConnectionController._onConnectionChange -> $value");
    }
    if (!value) {
      Get.offAllNamed("/offline");
    } else {
      if (Get.currentRoute == "/offline") {
        Get.offAllNamed("/dashboard");
      }
    }
  }

  // =================================================================

  void _listenConnectionPeriodically() {
    Future.delayed(const Duration(seconds: 5), _listenConnectionPeriodically);
  }

  // =================================================================

  void _listenConnection() async {
    await Dio(BaseOptions(
      maxRedirects: 1,
      connectTimeout: const Duration(seconds: 2),
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
    _listenConnection();
  }
}
