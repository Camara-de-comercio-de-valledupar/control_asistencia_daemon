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

final class DashboardShowAssistanceView extends DashboardState {
  const DashboardShowAssistanceView() : super(title: "Tomar Asistencia");
}

final class DashboardShowAssistanceHistoryView extends DashboardState {
  const DashboardShowAssistanceHistoryView()
      : super(title: "Historial de Asistencias");
}

final class DashboardShowStatisticsView extends DashboardState {
  const DashboardShowStatisticsView() : super(title: "Estadísticas");
}
