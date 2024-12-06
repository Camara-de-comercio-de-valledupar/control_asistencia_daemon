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
  final AuthenticationAppCCValleduparService _authenticationService =
      AuthenticationAppCCValleduparService.getInstance();

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
    try {
      emit(AuthenticationInProgress());
      final memberString = cacheService.getString("member");
      if (memberString != null) {
        final member = memberAppCCvalleduparFromJson(memberString);
        emit(AuthenticationSuccess(member));
      } else {
        emit(const AuthenticationInitial());
      }
    } catch (e) {
      emit(const AuthenticationInitial());
    }
  }

  FutureOr<void> _logout(AuthenticationLogoutRequested event,
      Emitter<AuthenticationState> emit) async {
    cacheService.remove("member");
    emit(const AuthenticationInitial());
  }

  FutureOr<void> _login(event, emit) async {
    try {
      emit(AuthenticationInProgress());
      await Future.delayed(const Duration(seconds: 2));
      final member = await _authenticationService.signInWithEmailAndPassword(
          event.email, event.password);
      await cacheService.setString(
          "member", memberAppCCvalleduparToJson(member));
      emit(AuthenticationSuccess(member));
    } catch (e) {
      if (kDebugMode) {
        log("AuthenticationBloc -> error: $e");
      }
      emit(const AuthenticationInitial());
    }
  }

  void _onAuthenticationStarted(
      AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    try {
      emit(AuthenticationInProgress());
      await Future.delayed(const Duration(seconds: 2));
      final memberString = cacheService.getString("member");
      if (kDebugMode) {
        print("memberString: $memberString");
      }
      if (memberString == null) {
        emit(const AuthenticationInitial());
      }
      final member = memberAppCCvalleduparFromJson(memberString!);

      if (kDebugMode) {
        log("AuthenticationBloc -> member: $member");
      }
      emit(AuthenticationSuccess(member));
    } catch (e) {
      if (kDebugMode) {
        log("AuthenticationBloc -> error: $e");
      }
      emit(const AuthenticationInitial());
    }
  }
}
