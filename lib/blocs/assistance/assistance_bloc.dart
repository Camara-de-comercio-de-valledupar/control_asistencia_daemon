import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:control_asistencia_daemon/lib.dart';
import 'package:equatable/equatable.dart';

part 'assistance_event.dart';
part 'assistance_state.dart';

class AssistanceBloc extends Bloc<AssistanceEvent, AssistanceState> {
  CameraController? cameraController;

  AssistanceService assistanceService = AssistanceService.getInstance();

  AssistanceBloc() : super(AssistanceInitial()) {
    on<AssistanceLoadCameraController>((event, emit) {
      cameraController = event.cameraController;
      emit(AssistanceCameraControllerLoaded());
    });
    on<AssistanceTakeAPicture>(_takeAPicture);
    on<AssistanceSendAssistanceRequest>(_sendAssistanceRequest);
    on<AssistanceGetAssistanceRequests>(_getAssistanceRequests);
  }

  FutureOr<void> _getAssistanceRequests(
      AssistanceGetAssistanceRequests event, emit) async {
    final assistances = await assistanceService.getAssistanceRequests();
    if (assistances.isEmpty) {
      emit(AssistanceHistoryEmpty());
      return;
    }
    emit(AssistanceHistoryLoaded(assistances));
  }

  FutureOr<void> _takeAPicture(event, emit) async {
    if (cameraController?.value.isInitialized == true) {
      final picture = await cameraController!.takePicture();
      emit(AssistancePictureTaken(await picture.readAsBytes()));
    }
  }

  FutureOr<void> _sendAssistanceRequest(
      AssistanceSendAssistanceRequest event, emit) async {
    emit(AssistanceSendingRequest());
    await assistanceService.sendAssistanceRequest(
        SendAssistanceRequest(event.token, event.picture));
    emit(AssistanceRequestSent());
  }
}
