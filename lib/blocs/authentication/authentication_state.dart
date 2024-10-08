part of 'authentication_bloc.dart';

sealed class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

final class AuthenticationInitial extends AuthenticationState {
  final String email;
  final String password;
  final bool rememberMe;

  const AuthenticationInitial({
    this.email = "",
    this.password = "",
    this.rememberMe = false,
  });
}

final class AuthenticationSuccess extends AuthenticationState {
  final Member member;

  const AuthenticationSuccess(this.member);

  @override
  List<Object> get props => [member];
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

final class AuthenticationUnknownFailure extends AuthenticationFailure {
  const AuthenticationUnknownFailure() : super("unknown-error");
}
