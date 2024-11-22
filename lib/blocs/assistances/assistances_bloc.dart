import 'package:bloc/bloc.dart';
import 'package:control_asistencia_daemon/lib.dart';
import 'package:equatable/equatable.dart';

part 'assistances_event.dart';
part 'assistances_state.dart';

class AssistancesBloc extends Bloc<AssistancesEvent, AssistancesState> {
  AssistancesBloc() : super(AssistancesInitial()) {
    _init();
    on<GetAssistancesFetchRequested>(_onAssistancesFetchRequested);
    on<AssistanceUsersFetched>(_onAssistanceUsersFetched);
    on<AssistanceShowDetailsRequested>(_onAssistanceShowDetailsRequested);
  }

  void _init() async {
    final users = await UserService.getInstance().getUsers();
    add(AssistanceUsersFetched(users));
  }

  void _onAssistanceShowDetailsRequested(
      AssistanceShowDetailsRequested event, Emitter<AssistancesState> emit) {
    emit(AssistanceShowDetails(event.assistance));
  }

  void _onAssistanceUsersFetched(
      AssistanceUsersFetched event, Emitter<AssistancesState> emit) {
    emit(AssistanceUsersLoaded(event.users));
  }

  void _onAssistancesFetchRequested(GetAssistancesFetchRequested event,
      Emitter<AssistancesState> emit) async {
    emit(AssistancesLoading());
    final assistances = await AssistanceService.getInstance()
        .getAssistanceReports()
        .onError((error, stackTrace) {
      emit(AssistancesError(error.toString()));
      return [];
    });
    if (assistances.isEmpty) {
      emit(AssistancesEmpty());
      return;
    }
    emit(AssistancesLoaded(assistances));
  }
}
