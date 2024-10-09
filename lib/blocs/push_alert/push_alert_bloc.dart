import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'push_alert_event.dart';
part 'push_alert_state.dart';

class PushAlertBloc extends Bloc<PushAlertEvent, PushAlertState> {
  PushAlertBloc() : super(PushAlertInitial()) {
    on<PushAlertEvent>((event, emit) {
      if (kDebugMode) {
        log("PushAlertBloc -> event: $event");
      }
    });
    on<PushAlertBasic>((event, emit) {
      final pushAlert = PushAlert(
        title: event.title,
        body: event.body,
        type: event.type,
      );
      emit(PushAlertReceived(pushAlert));
    });

    on<PushAlertCustom>((event, emit) {
      emit(PushAlertReceived(event.pushAlert));
      emit(PushAlertInitial());
    });
  }
}
