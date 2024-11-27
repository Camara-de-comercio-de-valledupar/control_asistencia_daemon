part of 'user_management_bloc.dart';

sealed class UserManagementEvent extends Equatable {
  const UserManagementEvent();

  @override
  List<Object> get props => [];
}

class UserManagementShowInitialView extends UserManagementEvent {
  const UserManagementShowInitialView();

  @override
  List<Object> get props => [];
}

class UserManagementFetchUsersRequested extends UserManagementEvent {
  final List<User> users;
  const UserManagementFetchUsersRequested(this.users);

  @override
  List<Object> get props => [users];
}

class UserManagementCreateUserRequested extends UserManagementEvent {
  const UserManagementCreateUserRequested();

  @override
  List<Object> get props => [];
}

class UserManagementEditUserRequested extends UserManagementEvent {
  final User user;
  const UserManagementEditUserRequested(this.user);

  @override
  List<Object> get props => [user];
}

class UserManagementUpdateUserRequested extends UserManagementEvent {
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String roles;
  final String permissions;
  final bool isActive;

  const UserManagementUpdateUserRequested({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.roles,
    required this.permissions,
    required this.isActive,
  });

  @override
  List<Object> get props => [
        id,
        username,
        firstName,
        lastName,
        email,
        password,
        roles,
        permissions,
        isActive
      ];
}

class UserManagementDeleteUserRequested extends UserManagementEvent {
  final User user;
  const UserManagementDeleteUserRequested(this.user);

  @override
  List<Object> get props => [user];
}

class UserManagementStoreUserRequested extends UserManagementEvent {
  final String username;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String roles;
  final String permissions;
  final bool isActive;

  const UserManagementStoreUserRequested({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.roles,
    required this.permissions,
    required this.isActive,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        password,
        roles,
        isActive,
        permissions,
        username
      ];
}

class UserManagementDeleteUserConfirmed extends UserManagementEvent {
  final User user;
  const UserManagementDeleteUserConfirmed(this.user);

  @override
  List<Object> get props => [user];
}

class UserManagementDeleteUserCancelled extends UserManagementEvent {
  const UserManagementDeleteUserCancelled();

  @override
  List<Object> get props => [];
}

class UserManagementResetPasswordRequested extends UserManagementEvent {
  final User user;
  const UserManagementResetPasswordRequested(this.user);

  @override
  List<Object> get props => [user];
}

class UserManagementSendResetPassword extends UserManagementEvent {
  final User user;
  final String password;
  const UserManagementSendResetPassword(this.user, this.password);

  @override
  List<Object> get props => [user, password];
}

class UserManagementToggleUserStatusRequested extends UserManagementEvent {
  final User user;
  const UserManagementToggleUserStatusRequested(this.user);

  @override
  List<Object> get props => [user];
}
