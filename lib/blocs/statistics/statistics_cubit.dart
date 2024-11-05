import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:url_launcher/url_launcher.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit() : super(StatisticsInitial());

  void openDashboard() {
    emit(StatisticsDashboardOpened());
  }

  void showDashboard() {
    final uri = Uri.parse(
        "https://app.powerbi.com/view?r=eyJrIjoiYmMxOTU0MjItMmU0NC00ZTI3LTkxOTMtZDRiZDFhMDZkM2VkIiwidCI6ImYzZjUxNDViLWY3MWEtNDRiZi1iMjdmLWFhYWY1MGI0MjhhZiIsImMiOjR9");
    launchUrl(uri);
  }

  void goToDownloadReport() {
    emit(StatisticsReportDownloaded());
  }

  void downloadReport() {}
}
