part of 'authentication_bloc.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationSuccess extends AuthenticationState {
  final User user;

  const AuthenticationSuccess(this.user);

  @override
  List<Object> get props => [user];
}

final class AuthenticationInProgress extends AuthenticationState {}

final class AuthenticationFailure extends AuthenticationState {
  final String message;

  const AuthenticationFailure(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthenticationInvalidCredentialsFailure
    extends AuthenticationFailure {
  const AuthenticationInvalidCredentialsFailure()
      : super("invalid-credentials");
}

final class AuthenticationUserNotFoundFailure extends AuthenticationFailure {
  const AuthenticationUserNotFoundFailure() : super("user-not-found");
}
