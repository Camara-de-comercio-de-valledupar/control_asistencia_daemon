part of 'assistance_bloc.dart';

sealed class AssistanceEvent extends Equatable {
  const AssistanceEvent();

  @override
  List<Object> get props => [];
}

class AssistanceLoadCameraController extends AssistanceEvent {
  final CameraController cameraController;

  const AssistanceLoadCameraController(this.cameraController);

  @override
  List<Object> get props => [cameraController];
}

class AssistanceTakeAPicture extends AssistanceEvent {
  const AssistanceTakeAPicture();
}

class AssistanceSendAssistanceRequest extends AssistanceEvent {
  final Uint8List picture;
  final String token;
  const AssistanceSendAssistanceRequest(this.picture, this.token);
}

class AssistanceGetAssistanceRequests extends AssistanceEvent {
  const AssistanceGetAssistanceRequests();
}
