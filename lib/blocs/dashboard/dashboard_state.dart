part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  final String title;
  const DashboardState({required this.title});

  @override
  List<Object> get props => [title];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial() : super(title: "Dashboard");
}

final class DashboardShowLoading extends DashboardState {
  const DashboardShowLoading() : super(title: "");
}

final class DashboardShowAssistanceHistoryView extends DashboardState {
  const DashboardShowAssistanceHistoryView()
      : super(title: "Historial de mis asistencias");
}

final class DashboardShowStatisticsView extends DashboardState {
  const DashboardShowStatisticsView() : super(title: "Estadísticas Generales");
}

final class DashboardShowAssistanceManagementView extends DashboardState {
  const DashboardShowAssistanceManagementView()
      : super(title: "Administrar Asistencias");
}

final class DashboardShowAssistanceStatisticsView extends DashboardState {
  const DashboardShowAssistanceStatisticsView()
      : super(title: "Estadísticas de mis asistencias");
}

final class DashboardShowUserManagementView extends DashboardState {
  const DashboardShowUserManagementView()
      : super(title: "Administrar funcionarios");
}

final class DashboardShowRoleManagementView extends DashboardState {
  const DashboardShowRoleManagementView()
      : super(title: "Administrar roles y permisos");
}

final class DashboardShowTakeAssistanceView extends DashboardState {
  const DashboardShowTakeAssistanceView() : super(title: "Tomar Asistencia");
}
