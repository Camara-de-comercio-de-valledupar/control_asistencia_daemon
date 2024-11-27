part of 'user_management_bloc.dart';

sealed class UserManagementState extends Equatable {
  const UserManagementState();

  @override
  List<Object> get props => [];
}

class UserManagementInitial extends UserManagementState {}

class UserManagementShowCreateUserView extends UserManagementState {}

class UserManagementShowUpdateUserView extends UserManagementState {
  final User user;
  const UserManagementShowUpdateUserView(this.user);

  @override
  List<Object> get props => [user];
}

class UserManagementShowDeleteUserView extends UserManagementState {
  final User user;
  const UserManagementShowDeleteUserView(this.user);

  @override
  List<Object> get props => [user];
}

class UserManagementShowUsersView extends UserManagementState {
  final List<User> users;
  const UserManagementShowUsersView(this.users);

  @override
  List<Object> get props => [users];
}

class UserManagementShowResetPasswordView extends UserManagementState {
  final User user;
  const UserManagementShowResetPasswordView(this.user);

  @override
  List<Object> get props => [user];
}

class UserManagementPasswordChanged extends UserManagementState {
  final User user;
  const UserManagementPasswordChanged(this.user);

  @override
  List<Object> get props => [user];
}

class UserManagementUserUpdated extends UserManagementState {
  final User user;
  const UserManagementUserUpdated(this.user);

  @override
  List<Object> get props => [user];
}
