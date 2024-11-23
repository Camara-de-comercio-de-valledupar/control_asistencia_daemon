import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class StatisticsDashboardView extends StatefulWidget {
  final List<AssistanceReport> reports;

  const StatisticsDashboardView({super.key, required this.reports});

  @override
  State<StatisticsDashboardView> createState() =>
      _StatisticsDashboardViewState();
}

class _StatisticsDashboardViewState extends State<StatisticsDashboardView> {
  List<AssistanceReport> _reports = [];
  List<String>? _selectedUser;

  @override
  void initState() {
    super.initState();
    _reports = widget.reports;
  }

  @override
  Widget build(BuildContext context) {
    final users = _reports
        .map((report) => [report.userEmail, report.userName])
        .toSet()
        .toList();
    return Column(
      children: [
        Row(
          children: [
            MonthPicker(
              onChanged: (DateTime? date) {
                if (date != null) {
                  setState(() {
                    _reports = widget.reports
                        .where((report) =>
                            report.date.month == date.month &&
                            report.date.year == date.year)
                        .toList();
                  });
                }
              },
            ),
            DateRangePicker(
              onChanged: (DateTime? start, DateTime? end) {
                if (start != null && end != null) {
                  setState(() {
                    _reports = widget.reports
                        .where((report) =>
                            report.date.isAfter(start) &&
                            report.date.isBefore(end))
                        .toList();
                  });
                }
              },
            ),
            //filtro por empleado
            CustomCardButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return FilterUserDialog(
                      usersFiltered: users,
                      onUserSelected: (user) {
                        setState(() {
                          _reports = widget.reports
                              .where((report) => report.userEmail == user[0])
                              .toList();
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
          ]
              .map((widget) => Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: widget,
                  )))
              .toList(),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: LineChartWidget(reports: _reports),
              ),
              Expanded(
                child: LateArrivalChartWidget(reports: _reports),
              ),
              Expanded(
                child: AbsenceChartWidget(reports: _reports),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MonthPicker extends StatefulWidget {
  final ValueChanged<DateTime?> onChanged;

  const MonthPicker({super.key, required this.onChanged});

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  final monthTargets = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre"
  ];

  DateTime? _selectedDate;

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        constraints: const BoxConstraints(maxHeight: 300, maxWidth: 300),
        backgroundColor: Colors.transparent,
        builder: (BuildContext builder) {
          return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Seleccionar mes",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Wrap(
                      children: List.generate(12, (index) {
                        return CustomCardButton(
                          onPressed: () {
                            setState(() {
                              _selectedDate =
                                  DateTime(DateTime.now().year, index + 1);
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            monthTargets[index],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ));
        }).whenComplete(() {
      widget.onChanged(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomCardButton(
      onPressed: () => _showMonthPicker(context),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 30,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: 10),
          Text(
            _selectedDate == null
                ? "Seleccionar mes"
                : monthTargets[_selectedDate!.month - 1],
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
