import 'package:bloc/bloc.dart';
import 'package:control_asistencia_daemon/lib.dart';
import 'package:equatable/equatable.dart';

part 'user_management_event.dart';
part 'user_management_state.dart';

class UserManagementBloc
    extends Bloc<UserManagementEvent, UserManagementState> {
  UserManagementBloc() : super(UserManagementInitial()) {
    _init();
    on<UserManagementCreateUserRequested>(_onUserManagementCreateUserRequested);
    on<UserManagementUpdateUserRequested>(_onUserManagementUpdateUserRequested);
    on<UserManagementDeleteUserRequested>(_onUserManagementDeleteUserRequested);
    on<UserManagementFetchUsersRequested>(_onUserManagementFetchUsersRequested);
  }

  void _init() async {
    final users = await UserService.getInstance().getUsers();
    add(UserManagementFetchUsersRequested(users));
  }

  void _onUserManagementCreateUserRequested(
      UserManagementCreateUserRequested event,
      Emitter<UserManagementState> emit) {
    emit(UserManagementShowCreateUserView());
  }

  void _onUserManagementUpdateUserRequested(
      UserManagementUpdateUserRequested event,
      Emitter<UserManagementState> emit) {
    emit(UserManagementShowUpdateUserView(event.user));
  }

  void _onUserManagementDeleteUserRequested(
      UserManagementDeleteUserRequested event,
      Emitter<UserManagementState> emit) {
    emit(UserManagementShowDeleteUserView(event.user));
  }

  void _onUserManagementFetchUsersRequested(
      UserManagementFetchUsersRequested event,
      Emitter<UserManagementState> emit) {
    emit(UserManagementShowUsersView(
      event.users,
    ));
  }
}
