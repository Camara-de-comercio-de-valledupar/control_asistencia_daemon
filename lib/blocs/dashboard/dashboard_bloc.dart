import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardInitial()) {
    on<DashboardShowInitialViewRequested>((event, emit) {
      emit(const DashboardInitial());
    });
    on<DashboardShowAssistanceHistoryRequested>((event, emit) {
      emit(const DashboardShowAssistanceHistoryView());
    });
    on<DashboardTakeAssistanceRequested>((event, emit) {
      emit(const DashboardShowAssistanceView());
    });

    on<DashboardShowStatisticsRequested>((event, emit) {
      emit(const DashboardShowStatisticsView());
    });
  }
}
