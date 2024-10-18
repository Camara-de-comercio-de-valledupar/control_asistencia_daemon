part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

final class DashboardShowInitialViewRequested extends DashboardEvent {}

final class DashboardShowAssistanceHistoryRequested extends DashboardEvent {}

final class DashboardShowStatisticsRequested extends DashboardEvent {}

final class DashboardShowAssistanceManagementRequested extends DashboardEvent {}

final class DashboardShowAssistanceStatisticsRequested extends DashboardEvent {}

final class DashboardShowUserManagementRequested extends DashboardEvent {}

final class DashboardShowRoleManagementRequested extends DashboardEvent {}

final class DashboardShowTakeAssistanceRequested extends DashboardEvent {}
