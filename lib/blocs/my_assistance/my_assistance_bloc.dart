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
  AssistanceAppCCValleduparService assistanceAppCCValleduparService =
      AssistanceAppCCValleduparService.getInstance();
  CacheService cacheService = CacheService.getInstance();

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

    List<List<Assistance>> groupedAsDate = [];

    for (var assistance in assistances) {
      if (groupedAsDate.isEmpty) {
        groupedAsDate.add([assistance]);
        continue;
      }

      final lastGroup = groupedAsDate.last;
      final lastAssistance = lastGroup.last;

      if (lastAssistance.createdAt.difference(assistance.createdAt).inDays ==
          0) {
        lastGroup.add(assistance);
      } else {
        groupedAsDate.add([assistance]);
      }
    }

    if (groupedAsDate.isEmpty) {
      emit(MyAssistanceHistoryEmpty());
      return;
    }

    List<AssistanceReport> reports = [];

    for (var group in groupedAsDate) {
      reports.add(AssistanceReport.fromAssistances(group));
    }

    reports.sort((a, b) => b.date.compareTo(a.date));

    emit(MyAssistanceHistoryLoaded(reports));
  }

  FutureOr<void> _takeAPicture(event, emit) async {
    emit(MyAssistancePictureTaken(Uint8List(0)));
  }

  FutureOr<void> _sendAssistanceRequest(
      MyAssistanceSendAssistanceRequest event, emit) async {
    emit(MyAssistanceSendingRequest());
    final memberString = cacheService.getString("member");
    if (memberString == null) {
      emit(MyAssistanceRequestFailed());
      return;
    }
    final member = memberAppCCvalleduparFromJson(memberString);
    final message = await assistanceAppCCValleduparService.createAssistance(
        memberId: member.id.toString());

    emit(MyAssistanceRequestSent(
      message: message,
    ));
  }
}
