part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class AuthenticationStarted extends AuthenticationEvent {}

final class AuthenticationLoginRequested extends AuthenticationEvent {
  final String email;
  final String password;

  const AuthenticationLoginRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {}
