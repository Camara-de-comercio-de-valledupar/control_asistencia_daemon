part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class AuthenticationStarted extends AuthenticationEvent {}

final class AuthenticationProfileFetched extends AuthenticationEvent {
  final String token;

  const AuthenticationProfileFetched(this.token);

  @override
  List<Object> get props => [token];
}

final class AuthenticationLoginRequested extends AuthenticationEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const AuthenticationLoginRequested(
      this.email, this.password, this.rememberMe);

  @override
  List<Object> get props => [email, password];
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {}

final class AuthenticationForgotPasswordRequested extends AuthenticationEvent {}
