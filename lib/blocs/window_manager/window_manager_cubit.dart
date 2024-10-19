import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'window_manager_state.dart';

class WindowManagerCubit extends Cubit<WindowManagerState> {
  WindowManagerCubit() : super(WindowManagerInitial());

  void resizeWindowToAdmin() {
    emit(WindowManagerResizedToAdmin());
  }

  void resizeWindowToUser() {
    emit(WindowManagerResizedToUser());
  }
}
