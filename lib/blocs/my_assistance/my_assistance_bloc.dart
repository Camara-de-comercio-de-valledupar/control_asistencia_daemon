import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:control_asistencia_daemon/lib.dart';
import 'package:equatable/equatable.dart';

part 'my_assistance_event.dart';
part 'my_assistance_state.dart';

class MyAssistanceBloc extends Bloc<MyAssistanceEvent, MyAssistanceState> {
  CameraController? cameraController;

  AssistanceService assistanceService = AssistanceService.getInstance();

  MyAssistanceBloc() : super(MyAssistanceInitial()) {
    on<MyAssistanceLoadCameraController>((event, emit) {
      cameraController = event.cameraController;
      emit(MyAssistanceCameraControllerLoaded());
    });
    on<MyAssistanceTakeAPicture>(_takeAPicture);
    on<MyAssistanceSendAssistanceRequest>(_sendAssistanceRequest);
    on<MyAssistanceGetAssistanceRequests>(_getAssistanceRequests);
  }

  FutureOr<void> _getAssistanceRequests(
      MyAssistanceGetAssistanceRequests event, emit) async {
    final assistances = await assistanceService.getMyAssistance();
    if (assistances.isEmpty) {
      emit(MyAssistanceHistoryEmpty());
      return;
    }
    emit(MyAssistanceHistoryLoaded(assistances));
  }

  FutureOr<void> _takeAPicture(event, emit) async {
    if (cameraController?.value.isInitialized == true) {
      final picture = await cameraController!.takePicture();
      emit(MyAssistancePictureTaken(await picture.readAsBytes()));
    }
  }

  FutureOr<void> _sendAssistanceRequest(
      MyAssistanceSendAssistanceRequest event, emit) async {
    emit(MyAssistanceSendingRequest());
    await assistanceService
        .sendAssistanceRequest(SendAssistanceRequest(event.picture));
    emit(MyAssistanceRequestSent());
  }
}
