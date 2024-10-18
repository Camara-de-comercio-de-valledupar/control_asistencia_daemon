part of 'user_management_bloc.dart';

sealed class UserManagementEvent extends Equatable {
  const UserManagementEvent();

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
