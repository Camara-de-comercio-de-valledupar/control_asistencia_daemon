import 'package:bloc/bloc.dart';
import 'package:control_asistencia_daemon/lib.dart';
import 'package:equatable/equatable.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationStarted) {
        emit(AuthenticationInProgress());
        await Future.delayed(const Duration(seconds: 2));
        emit(AuthenticationInitial());
      }
      if (event is AuthenticationLoginRequested) {
        emit(AuthenticationInProgress());
        await Future.delayed(const Duration(seconds: 2));
        if (event.email == "test_1@example.com" && event.password == "1234") {
          emit(const AuthenticationSuccess(User(
            email: "test_1@example.com",
            firstName: "John",
            lastName: "Doe",
            id: "1",
          )));
        } else {
          emit(const AuthenticationInvalidCredentialsFailure());
        }
      }
      if (event is AuthenticationLogoutRequested) {
        emit(AuthenticationInitial());
      }
    });
  }
}
