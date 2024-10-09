part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

final class DashboardShowInitialViewRequested extends DashboardEvent {}

final class DashboardTakeAssistanceRequested extends DashboardEvent {}

final class DashboardShowAssistanceHistoryRequested extends DashboardEvent {}

final class DashboardShowStatisticsRequested extends DashboardEvent {}
