import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardInitial()) {
    on<DashboardShowInitialViewRequested>(_showInitialView);
    on<DashboardShowAssistanceHistoryRequested>(_showAssistanceHistoryView);
    on<DashboardShowTakeAssistanceRequested>(_showAssistanceView);
    on<DashboardShowStatisticsRequested>(_showStatisticsView);
    on<DashboardShowAssistanceManagementRequested>(
        _showAssistanceManagementView);
    on<DashboardShowAssistanceStatisticsRequested>(
        _showAssistanceStatisticsView);
    on<DashboardShowUserManagementRequested>(_showUserManagementView);
    on<DashboardShowRoleManagementRequested>(_showRoleManagementView);
  }

  FutureOr<void> _showRoleManagementView(event, emit) {
    emit(const DashboardShowRoleManagementView());
  }

  FutureOr<void> _showUserManagementView(event, emit) {
    emit(const DashboardShowUserManagementView());
  }

  FutureOr<void> _showAssistanceStatisticsView(event, emit) {
    emit(const DashboardShowAssistanceStatisticsView());
  }

  FutureOr<void> _showAssistanceManagementView(event, emit) {
    emit(const DashboardShowAssistanceManagementView());
  }

  FutureOr<void> _showInitialView(event, emit) {
    emit(const DashboardInitial());
  }

  FutureOr<void> _showAssistanceHistoryView(event, emit) {
    emit(const DashboardShowAssistanceHistoryView());
  }

  FutureOr<void> _showStatisticsView(event, emit) {
    emit(const DashboardShowStatisticsView());
  }

  void _showAssistanceView(DashboardShowTakeAssistanceRequested event,
      Emitter<DashboardState> emit) {
    emit(const DashboardShowTakeAssistanceView());
  }
}
