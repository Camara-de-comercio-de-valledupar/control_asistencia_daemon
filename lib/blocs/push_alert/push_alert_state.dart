part of 'push_alert_bloc.dart';

sealed class PushAlertState extends Equatable {
  const PushAlertState();

  @override
  List<Object> get props => [];
}

final class PushAlertInitial extends PushAlertState {}

final class PushAlertReceived extends PushAlertState {
  final PushAlert pushAlert;

  const PushAlertReceived(this.pushAlert);

  @override
  List<Object> get props => [pushAlert];
}
