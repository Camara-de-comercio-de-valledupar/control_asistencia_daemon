part of 'statistics_cubit.dart';

sealed class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => [];
}

final class StatisticsInitial extends StatisticsState {}

final class StatisticsDashboardOpened extends StatisticsState {
  final List<AssistanceReport> reports;

  const StatisticsDashboardOpened(this.reports);

  @override
  List<Object> get props => [reports];
}

final class StatisticsRequestDownloadReport extends StatisticsState {}

final class StatisticsReportDownloaded extends StatisticsState {
  final Uint8List report;
  const StatisticsReportDownloaded(this.report);
}

final class StatisticsLoading extends StatisticsState {}

final class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError(this.message);

  @override
  List<Object> get props => [message];
}
