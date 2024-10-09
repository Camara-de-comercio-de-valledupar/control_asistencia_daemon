import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:control_asistencia_daemon/lib.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService _authenticationService =
      AuthenticationService.instance;

  AuthenticationBloc() : super(const AuthenticationInitial()) {
    on<AuthenticationEvent>(_logEvent);
    on<AuthenticationStarted>(_onAuthenticationStarted);
    on<AuthenticationLoginRequested>(_login);
    on<AuthenticationLogoutRequested>(_logout);
  }

  void _logEvent(AuthenticationEvent event, Emitter<AuthenticationState> emit) {
    if (kDebugMode) {
      log("AuthenticationBloc -> event: $event");
    }
  }

  FutureOr<void> _logout(AuthenticationLogoutRequested event,
      Emitter<AuthenticationState> emit) async {
    await _authenticationService.signOut();
    emit(const AuthenticationInitial());
  }

  FutureOr<void> _login(event, emit) async {
    emit(AuthenticationInProgress());
    await Future.delayed(const Duration(seconds: 2));
    String email = "${event.email}@ccvalledupar.org.co";
    try {
      final user = await _authenticationService.signInWithEmailAndPassword(
          email, event.password);
      await _rememberCredentials(
          rememberMe: event.rememberMe,
          email: event.email,
          password: event.password);
      emit(AuthenticationSuccess(user));
    } catch (e) {
      emit(AuthenticationFailure(e.toString()));
    }
    emit(const AuthenticationInvalidCredentialsFailure());
  }

  FutureOr<void> _rememberCredentials({
    required bool rememberMe,
    required String email,
    required String password,
  }) async {
    if (rememberMe) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('rememberMe', rememberMe);
      prefs.setString('email', email);
      prefs.setString('password', password);
    }
  }

  FutureOr<void> _forgetCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('rememberMe');
    prefs.remove('email');
    prefs.remove('password');
  }

  FutureOr<void> _getRememberedCredentials(
      AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    if (rememberMe) {
      final email = prefs.getString('email') ?? '';
      final password = prefs.getString('password') ?? '';
      final rememberMe = prefs.getBool('rememberMe') ?? false;
      emit(AuthenticationInitial(
          email: email, password: password, rememberMe: rememberMe));
    }
  }

  void _onAuthenticationStarted(
      AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationInProgress());
    await Future.delayed(const Duration(seconds: 2));
    try {
      final member = await _authenticationService.loggedInMember;
      if (kDebugMode) {
        log("AuthenticationBloc -> member: $member");
      }
      if (member != null) {
        emit(AuthenticationSuccess(member));
      } else {
        emit(const AuthenticationInitial());
      }
    } catch (e) {
      emit(const AuthenticationUnknownFailure());
      emit(const AuthenticationInitial());
    }
  }
}
