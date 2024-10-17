part of 'assistance_bloc.dart';

sealed class AssistanceState extends Equatable {
  const AssistanceState();

  @override
  List<Object> get props => [];
}

final class AssistanceInitial extends AssistanceState {}

final class AssistanceCameraControllerLoaded extends AssistanceState {}

final class AssistancePictureTaken extends AssistanceState {
  final Uint8List picture;

  const AssistancePictureTaken(this.picture);

  @override
  List<Object> get props => [picture];
}

final class AssistanceSendingRequest extends AssistanceState {}

final class AssistanceRequestSent extends AssistanceState {}

final class AssistanceRequestFailed extends AssistanceState {}

final class AssistanceHistoryLoaded extends AssistanceState {
  final List<Assistance> assistances;

  const AssistanceHistoryLoaded(this.assistances);

  @override
  List<Object> get props => [assistances];
}

final class AssistanceHistoryEmpty extends AssistanceState {}
