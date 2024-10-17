import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:control_asistencia_daemon/lib.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService _authenticationService =
      AuthenticationService.getInstance();

  final cacheService = CacheService.getInstance();
  String token = "";

  AuthenticationBloc() : super(const AuthenticationInitial()) {
    on<AuthenticationEvent>(_logEvent);
    on<AuthenticationStarted>(_onAuthenticationStarted);
    on<AuthenticationLoginRequested>(_login);
    on<AuthenticationLogoutRequested>(_logout);
    on<AuthenticationProfileFetched>(_fetchProfile);
  }

  void _logEvent(AuthenticationEvent event, Emitter<AuthenticationState> emit) {
    if (kDebugMode) {
      log("AuthenticationBloc -> event: $event");
    }
  }

  FutureOr<void> _fetchProfile(AuthenticationProfileFetched event,
      Emitter<AuthenticationState> emit) async {
    emit(AuthenticationInProgress());
    await cacheService.setString('token', event.token);
    final member = await _authenticationService.loggedInMember;
    emit(AuthenticationSuccess(member));
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
    final token = await _authenticationService.signInWithEmailAndPassword(
        email, event.password);
    await _rememberCredentials(
        rememberMe: event.rememberMe,
        email: event.email,
        password: event.password);
    emit(AuthenticationPreSuccess(token));
  }

  FutureOr<void> _rememberCredentials({
    required bool rememberMe,
    required String email,
    required String password,
  }) async {
    if (rememberMe) {
      cacheService.setBool('rememberMe', rememberMe);
      cacheService.setString('email', email);
      cacheService.setString('password', password);
    }
  }

  FutureOr<void> _forgetCredentials() async {
    cacheService.remove('rememberMe');
    cacheService.remove('email');
    cacheService.remove('password');
  }

  FutureOr<void> _getRememberedCredentials(
      AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    final rememberMe = cacheService.getBool('rememberMe') ?? false;
    if (rememberMe) {
      final email = cacheService.getString('email') ?? '';
      final password = cacheService.getString('password') ?? '';
      final rememberMe = cacheService.getBool('rememberMe') ?? false;
      emit(AuthenticationInitial(
          email: email, password: password, rememberMe: rememberMe));
    }
  }

  void _onAuthenticationStarted(
      AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationInProgress());
    await Future.delayed(const Duration(seconds: 2));
    await _getRememberedCredentials(event, emit);
    final member = await _authenticationService.loggedInMember;
    if (kDebugMode) {
      log("AuthenticationBloc -> member: $member");
    }
    emit(AuthenticationSuccess(member));
  }
}
