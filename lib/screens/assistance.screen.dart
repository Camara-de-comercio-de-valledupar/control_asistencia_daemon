import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistanceScreen extends StatefulWidget {
  const AssistanceScreen({super.key});

  @override
  State<AssistanceScreen> createState() => _AssistanceScreenState();
}

class _AssistanceScreenState extends State<AssistanceScreen> {
  List<List<String>> _users = [];
  DateTimeRange? _selectedDateRange;
  List<String>? _selectedUser;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssistancesBloc>(context)
        .add(const GetAssistancesFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BlocListener<AssistancesBloc, AssistancesState>(
            listener: (context, state) {
              if (state is AssistancesLoaded) {
                _users = state.reports
                    .map((report) => [report.userEmail, report.userName])
                    .toList();
                setState(() {});
              }
            },
            child: BlocBuilder<AssistancesBloc, AssistancesState>(
                builder: (context, state) {
              if (state is! AssistancesLoaded) {
                return const Center(child: LoadingIndicator());
              }

              if (state is AssistancesEmpty) {
                return Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.warning,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      "Aun no hay funcionarios marcando asistencia",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ));
              }

              final reports = state.reports.where((report) {
                if (_selectedDateRange != null) {
                  if (report.date.isBefore(_selectedDateRange!.start) ||
                      report.date.isAfter(_selectedDateRange!.end)) {
                    return false;
                  }
                }

                if (_selectedUser != null) {
                  if (report.userEmail != _selectedUser![0]) {
                    return false;
                  }
                }

                return true;
              }).toList();

              return Column(
                children: [
                  _buildFilters(context),
                  Expanded(
                    child: CustomCard(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final report = reports[index];

                          return _buildReport(context, report);
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: BlocBuilder<AssistancesBloc, AssistancesState>(
            builder: (context, state) {
              return FloatingActionButton.extended(
                onPressed: () {
                  BlocProvider.of<AssistancesBloc>(context)
                      .add(const GetAssistancesFetchRequested());
                },
                label: () {
                  if (state is AssistancesLoading) {
                    return const Text("Cargando asistencias...");
                  }
                  if (state is AssistancesEmpty) {
                    return const Text("Cargar asistencias");
                  }
                  return const Text("Refrescar");
                }(),
                icon: () {
                  if (state is AssistancesLoading) {
                    return null;
                  }
                  return const Icon(Icons.refresh);
                }(),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          // Filtro por rango de fechas
          Expanded(
            child: DateRangePicker(
              onChanged: (start, end) {
                if (start == null || end == null) {
                  return;
                }
                setState(() {
                  _selectedDateRange = DateTimeRange(start: start, end: end);
                });
                BlocProvider.of<AssistancesBloc>(context).add(
                  GetAssistancesFetchRequested(
                    startDate: start,
                    endDate: end,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 20),
          // Filtro por usuario
          Expanded(
            child: CustomCardButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return FilterUserDialog(
                      usersFiltered: _users,
                      onUserSelected: (user) {
                        setState(() {
                          _selectedUser = user;
                        });
                      },
                    );
                  },
                );
              },
              child: Row(children: [
                Icon(
                  Icons.person,
                  size: 30,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(width: 10),
                Text(
                  _selectedUser == null
                      ? "Seleccionar usuario"
                      : _selectedUser![1],
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReport(BuildContext context, AssistanceReport assistanceReport) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 30,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assistanceReport.userName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Jornada de la mañana",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                          Text(
                              "Hora de llegada: ${formatDatetimeToHourMinute(assistanceReport.timeOfEntryMorning)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: assistanceReport.isLateInMorningEntry
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                                  )),
                          Text(
                              "Hora de salida: ${formatDatetimeToHourMinute(assistanceReport.timeOfExitMorning)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: assistanceReport.isSoonInMorningExit
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                                  )),
                          Text(
                              "Tiempo en la oficina: ${formatTimeOfDay(assistanceReport.timeInOfficeMorning)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Jornada de la tarde",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                          Text(
                              "Hora de llegada: ${formatDatetimeToHourMinute(assistanceReport.timeOfEntryAfternoon)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: assistanceReport
                                            .isLateInAfternoonEntry
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                                  )),
                          Text(
                              "Hora de salida: ${formatDatetimeToHourMinute(assistanceReport.timeOfExitAfternoon)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: assistanceReport
                                            .isSoonInAfternoonExit
                                        ? Colors.red
                                        : Theme.of(context).colorScheme.primary,
                                  )),
                          Text(
                              "Tiempo en la oficina: ${formatTimeOfDay(assistanceReport.timeInOfficeAfternoon)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )),
                        ],
                      ),
                    )
                  ],
                ),
                Text(
                    "Fecha de asistencia: ${formatDateToHumanDate(assistanceReport.date)}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )),
              ],
            ),
          ),
          const Spacer(),
          Icon(
            Icons.check_circle,
            size: 30,
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
