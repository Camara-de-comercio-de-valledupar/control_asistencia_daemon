import 'package:bloc/bloc.dart';
import 'package:control_asistencia_daemon/lib.dart';
import 'package:equatable/equatable.dart';

part 'user_management_event.dart';
part 'user_management_state.dart';

class UserManagementBloc
    extends Bloc<UserManagementEvent, UserManagementState> {
  UserManagementBloc() : super(UserManagementInitial()) {
    _init();
    on<UserManagementShowInitialView>(_onUserManagementShowInitialView);
    on<UserManagementCreateUserRequested>(_onUserManagementCreateUserRequested);
    on<UserManagementUpdateUserRequested>(_onUserManagementUpdateUserRequested);
    on<UserManagementDeleteUserRequested>(_onUserManagementDeleteUserRequested);
    on<UserManagementFetchUsersRequested>(_onUserManagementFetchUsersRequested);
    on<UserManagementStoreUserRequested>(_onUserManagementStoreUserRequested);
    on<UserManagementDeleteUserConfirmed>(_onUserManagementDeleteUserConfirmed);
    on<UserManagementDeleteUserCancelled>(_onUserManagementDeleteUserCancelled);
  }

  void _init() async {
    final users = await UserService.getInstance().getUsers();
    add(UserManagementFetchUsersRequested(users));
  }

  void _onUserManagementDeleteUserConfirmed(
      UserManagementDeleteUserConfirmed event,
      Emitter<UserManagementState> emit) async {
    await UserService.getInstance().deleteUser(event.user);
    _init();
  }

  void _onUserManagementDeleteUserCancelled(
      UserManagementDeleteUserCancelled event,
      Emitter<UserManagementState> emit) {
    _init();
  }

  void _onUserManagementStoreUserRequested(
      UserManagementStoreUserRequested event,
      Emitter<UserManagementState> emit) async {
    final user = User(
      id: 0,
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      username: event.username,
      isActive: event.isActive,
      roles: event.roles.split(",").map((e) => roleFromSpanishName(e)).toList(),
      permissions: event.permissions
          .split(",")
          .map((e) => permissionFromSpanishName(e))
          .toList(),
    );
    await UserService.getInstance().createUser(user, event.password);
    _init();
  }

  void _onUserManagementShowInitialView(
      UserManagementShowInitialView event, Emitter<UserManagementState> emit) {
    emit(UserManagementInitial());
    _init();
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
