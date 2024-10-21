part of 'assistances_bloc.dart';

sealed class AssistancesEvent extends Equatable {
  const AssistancesEvent();

  @override
  List<Object> get props => [];
}

class GetAssistancesFetchRequested extends AssistancesEvent {
  const GetAssistancesFetchRequested();

  @override
  List<Object> get props => [];
}

class AssistanceUsersFetched extends AssistancesEvent {
  final List<User> users;
  const AssistanceUsersFetched(this.users);

  @override
  List<Object> get props => [users];
}

class AssistanceShowDetailsRequested extends AssistancesEvent {
  final Assistance assistance;
  const AssistanceShowDetailsRequested(this.assistance);

  @override
  List<Object> get props => [assistance];
}
