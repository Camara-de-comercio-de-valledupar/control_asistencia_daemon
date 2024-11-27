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
    on<UserManagementEditUserRequested>(_onUserManagementEditUserRequested);
    on<UserManagementDeleteUserRequested>(_onUserManagementDeleteUserRequested);
    on<UserManagementFetchUsersRequested>(_onUserManagementFetchUsersRequested);
    on<UserManagementStoreUserRequested>(_onUserManagementStoreUserRequested);
    on<UserManagementDeleteUserConfirmed>(_onUserManagementDeleteUserConfirmed);
    on<UserManagementDeleteUserCancelled>(_onUserManagementDeleteUserCancelled);
    on<UserManagementUpdateUserRequested>(_onUserManagementUpdateUserRequested);
    on<UserManagementResetPasswordRequested>(
        _onUserManagementResetPasswordRequested);
    on<UserManagementSendResetPassword>(_onUserManagementSendResetPassword);
    on<UserManagementToggleUserStatusRequested>(
        _onUserManagementToggleUserStatusRequested);
  }

  void _init() async {
    final users = await UserService.getInstance().getUsers();
    add(UserManagementFetchUsersRequested(users));
  }

  void _onUserManagementUpdateUserRequested(
      UserManagementUpdateUserRequested event,
      Emitter<UserManagementState> emit) async {
    final user = User(
      id: event.id,
      firstName: event.firstName,
      lastName: event.lastName,
      email: "${event.email}@ccvalledupar.org.co",
      username: event.username,
      isActive: event.isActive,
      roles: event.roles.split(",").map((e) => roleFromSpanishName(e)).toList(),
      permissions: event.permissions
          .split(",")
          .map((e) => permissionFromSpanishName(e))
          .toList(),
    );
    await UserService.getInstance().updateUser(user);
    _init();
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
      email: '${event.email}@ccvalledupar.org.co',
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

  void _onUserManagementEditUserRequested(UserManagementEditUserRequested event,
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

  void _onUserManagementResetPasswordRequested(
      UserManagementResetPasswordRequested event,
      Emitter<UserManagementState> emit) async {
    emit(UserManagementShowResetPasswordView(event.user));
  }

  void _onUserManagementSendResetPassword(UserManagementSendResetPassword event,
      Emitter<UserManagementState> emit) async {
    await AuthenticationService.getInstance().resetPassword(
      userId: event.user.id,
      password: event.password,
    );
    emit(UserManagementPasswordChanged(event.user));
    _init();
  }

  void _onUserManagementToggleUserStatusRequested(
      UserManagementToggleUserStatusRequested event,
      Emitter<UserManagementState> emit) async {
    final user = event.user.copyWith(isActive: !event.user.isActive);
    await UserService.getInstance().updateUser(user);
    emit(UserManagementUserUpdated(user));
    _init();
  }
}
