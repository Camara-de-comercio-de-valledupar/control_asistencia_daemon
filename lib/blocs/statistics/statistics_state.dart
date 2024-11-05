part of 'statistics_cubit.dart';

sealed class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => [];
}

final class StatisticsInitial extends StatisticsState {}

final class StatisticsDashboardOpened extends StatisticsState {}

final class StatisticsReportDownloaded extends StatisticsState {}
