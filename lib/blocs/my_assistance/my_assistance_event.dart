part of 'my_assistance_bloc.dart';

sealed class MyAssistanceEvent extends Equatable {
  const MyAssistanceEvent();

  @override
  List<Object> get props => [];
}

class MyAssistanceLoadCameraController extends MyAssistanceEvent {
  final CameraController cameraController;

  const MyAssistanceLoadCameraController(this.cameraController);

  @override
  List<Object> get props => [cameraController];
}

class MyAssistanceTakeAPicture extends MyAssistanceEvent {
  const MyAssistanceTakeAPicture();
}

class MyAssistanceSendAssistanceRequest extends MyAssistanceEvent {
  final Uint8List picture;
  const MyAssistanceSendAssistanceRequest(this.picture);
}

class MyAssistanceGetAssistanceRequests extends MyAssistanceEvent {
  const MyAssistanceGetAssistanceRequests();
}
