part of 'assistances_bloc.dart';

sealed class AssistancesState extends Equatable {
  const AssistancesState();

  @override
  List<Object> get props => [];
}

final class AssistancesInitial extends AssistancesState {}

final class AssistancesLoaded extends AssistancesState {
  final List<AssistanceReport> reports;
  const AssistancesLoaded(this.reports);

  @override
  List<Object> get props => [reports];
}

final class AssistancesEmpty extends AssistancesState {}

final class AssistanceUsersLoaded extends AssistancesState {
  final List<User> users;
  const AssistanceUsersLoaded(this.users);

  @override
  List<Object> get props => [users];
}

final class AssistanceShowDetails extends AssistancesState {
  final Assistance assistance;
  const AssistanceShowDetails(this.assistance);

  @override
  List<Object> get props => [assistance];
}
