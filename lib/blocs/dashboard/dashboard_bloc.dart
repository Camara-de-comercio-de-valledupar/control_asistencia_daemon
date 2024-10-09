import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardInitial()) {
    on<DashboardShowInitialViewRequested>(_showInitialView);
    on<DashboardShowAssistanceHistoryRequested>(_showAssistanceHistoryView);
    on<DashboardTakeAssistanceRequested>(_showAssistanceView);
    on<DashboardShowStatisticsRequested>(_showStatisticsView);
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

  void _showAssistanceView(
      DashboardTakeAssistanceRequested event, Emitter<DashboardState> emit) {
    emit(const DashboardShowAssistanceView());
  }
}
