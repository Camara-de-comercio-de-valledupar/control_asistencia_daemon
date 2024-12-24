import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class LateAssistancesReportScreen extends StatefulWidget {
  const LateAssistancesReportScreen({super.key});

  @override
  State<LateAssistancesReportScreen> createState() =>
      _LateAssistancesReportScreenState();
}

class _LateAssistancesReportScreenState
    extends State<LateAssistancesReportScreen> {
  DateTime selectedDate = DateTime.now();
  List<Employee> employees = [
    Employee(
        id: '1',
        firstName: 'Juan',
        lastName: 'Pérez',
        position: 'Desarrollador'),
    Employee(
        id: '2', firstName: 'Ana', lastName: 'Gómez', position: 'Diseñadora'),
    Employee(
        id: '3', firstName: 'Luis', lastName: 'Martínez', position: 'Gerente'),
  ];
  List<Attendance> attendances = [];
  bool isEmployeeView = false;
  String selectedEmployeeId = "";

  @override
  void initState() {
    super.initState();
    // Simulamos la carga de datos de asistencia
    fetchAttendanceByDate();
  }

  void fetchAttendanceByDate() {
    // Simulamos datos de asistencia
    setState(() {
      attendances = [
        Attendance(
            name: 'Juan Pérez',
            position: 'Desarrollador',
            morningShift: '08:00',
            afternoonShift: '17:00'),
        Attendance(
            name: 'Ana Gómez',
            position: 'Diseñadora',
            morningShift: '09:00',
            afternoonShift: '18:00'),
        Attendance(
            name: 'Luis Martínez',
            position: 'Gerente',
            morningShift: '08:30',
            afternoonShift: '17:30'),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: "Reporte de llegadas tarde",
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEmployeeView = false;
                    fetchAttendanceByDate(); // Simulamos la carga de datos al cambiar la vista
                  });
                },
                child: const Text('Consultar por día'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEmployeeView = true;
                  });
                },
                child: const Text('Consultar por funcionario'),
              ),
            ],
          ),
          if (!isEmployeeView) ...[
            TextButton(
              onPressed: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (date != null && date != selectedDate) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              child: Text(
                  'Seleccionar fecha: ${selectedDate.toLocal().toString().split(' ')[0]}'),
            ),
            ElevatedButton(
              onPressed: fetchAttendanceByDate,
              child: const Text('Buscar'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: attendances.length,
                itemBuilder: (context, index) {
                  final attendance = attendances[index];
                  return ListTile(
                    title: Text(attendance.name),
                    subtitle: Text(attendance.position),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Mañana: ${attendance.morningShift}'),
                        Text('Tarde: ${attendance.afternoonShift}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            DropdownButton<String>(
              value: selectedEmployeeId,
              hint: const Text('Seleccione un empleado'),
              items: employees.map((Employee employee) {
                return DropdownMenuItem<String>(
                  value: employee.id,
                  child: Text('${employee.firstName} ${employee.lastName}'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedEmployeeId = newValue!;
                });
              },
            ),
            // Se puede añadir funcionalidad adicional para la búsqueda por empleados aquí
          ],
        ],
      ),
    );
  }
}

class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String position;

  Employee(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.position});
}

class Attendance {
  final String name;
  final String position;
  final String morningShift;
  final String afternoonShift;

  Attendance(
      {required this.name,
      required this.position,
      required this.morningShift,
      required this.afternoonShift});
}
