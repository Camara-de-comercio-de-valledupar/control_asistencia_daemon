part of 'schedule_bloc.dart';

sealed class ScheduleState extends Equatable {
  const ScheduleState();
  
  @override
  List<Object> get props => [];
}

final class ScheduleInitial extends ScheduleState {}
