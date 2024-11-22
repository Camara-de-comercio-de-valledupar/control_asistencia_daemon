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
            child: CustomCardButton(
              onPressed: () async {
                final DateTimeRange? selectedDate = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2025),
                  builder: (context, child) {
                    return Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: 400,
                          height: 400,
                          child: Theme(
                              data: ThemeData(
                                iconTheme: IconThemeData(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                colorScheme: ColorScheme.light(
                                  surface:
                                      Theme.of(context).colorScheme.onPrimary,
                                  onSurface:
                                      Theme.of(context).colorScheme.primary,
                                  primary:
                                      Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              child: child!),
                        ),
                      ),
                    );
                  },
                );
                setState(() {
                  _selectedDateRange = selectedDate;
                });
              },
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 30,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _selectedDateRange == null
                        ? "Seleccionar fecha"
                        : "Desde ${formatDateToHumanDate(_selectedDateRange!.start)} hasta ${formatDateToHumanDate(_selectedDateRange!.end)}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
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

class FilterUserDialog extends StatefulWidget {
  final List<List<String>> usersFiltered;
  final ValueChanged<List<String>> onUserSelected;
  const FilterUserDialog(
      {super.key, required this.usersFiltered, required this.onUserSelected});

  @override
  State<FilterUserDialog> createState() => _FilterUserDialogState();
}

class _FilterUserDialogState extends State<FilterUserDialog> {
  List<List<String>> _usersFiltered = [];

  @override
  void initState() {
    super.initState();
    _usersFiltered = widget.usersFiltered;
  }

  void _filterUsers(String query) {
    setState(() {
      _usersFiltered = widget.usersFiltered
          .where((user) =>
              isSimilarString(user[1].toLowerCase(), query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Seleccionar usuario",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      content: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextFormField(
              onChanged: _filterUsers,
              decoration: InputDecoration(
                labelText: "Buscar usuario",
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _usersFiltered.length,
                itemBuilder: (context, index) {
                  final user = _usersFiltered[index];
                  return ListTile(
                    title: Text(user[1],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    subtitle: Text(user[0],
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    onTap: () {
                      widget.onUserSelected(user);
                      Navigator.of(context).pop(user);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
