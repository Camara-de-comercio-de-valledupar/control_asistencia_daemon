part of 'assistances_bloc.dart';

sealed class AssistancesEvent extends Equatable {
  const AssistancesEvent();

  @override
  List<Object> get props => [];
}

class GetAssistancesFetchRequested extends AssistancesEvent {
  final DateTime? startDate;
  final DateTime? endDate;
  const GetAssistancesFetchRequested({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object> get props => [
        startDate ?? DateTime.now(),
        endDate ?? DateTime.now(),
      ];
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
