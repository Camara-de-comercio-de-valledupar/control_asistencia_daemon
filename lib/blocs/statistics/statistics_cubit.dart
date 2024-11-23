import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:control_asistencia_daemon/lib.dart';
import 'package:equatable/equatable.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsInitial());

  void openDashboard() async {
    emit(StatisticsLoading());
    final reports = await AssistanceService.getInstance()
        .getAssistanceReports()
        .onError((err, stacktrace) {
      emit(StatisticsError(err.toString()));
      return [];
    });
    emit(StatisticsDashboardOpened(reports));
  }

  void downloadReport() async {
    emit(StatisticsLoading());
    final report = await AssistanceService.getInstance()
        .downloadReport()
        .onError((err, stacktrace) {
      emit(StatisticsError(err.toString()));
      return Uint8List(0);
    });

    emit(StatisticsReportDownloaded(report));
  }

  void goToDownloadReport() async {
    emit(StatisticsRequestDownloadReport());
  }

  void saveReport(Uint8List report) async {
    final path = await FileService.getInstance().searchFilepath();
    await FileService.getInstance().saveFile(report, path);
  }
}
