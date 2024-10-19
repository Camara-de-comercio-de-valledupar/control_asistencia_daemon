part of 'window_manager_cubit.dart';

sealed class WindowManagerState extends Equatable {
  const WindowManagerState();

  @override
  List<Object> get props => [];
}

final class WindowManagerInitial extends WindowManagerState {}

final class WindowManagerResizedToAdmin extends WindowManagerState {}

final class WindowManagerResizedToUser extends WindowManagerState {}
