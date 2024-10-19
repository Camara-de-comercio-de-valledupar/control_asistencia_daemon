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

class UserManagementUpdateUserRequested extends UserManagementEvent {
  final User user;
  const UserManagementUpdateUserRequested(this.user);

  @override
  List<Object> get props => [user];
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
