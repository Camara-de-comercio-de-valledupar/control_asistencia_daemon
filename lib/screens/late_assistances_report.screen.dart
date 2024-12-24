// ignore_for_file: deprecated_member_use

import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LateAssistancesReportScreen extends StatefulWidget {
  const LateAssistancesReportScreen({super.key});

  @override
  State<LateAssistancesReportScreen> createState() =>
      _LateAssistancesReportScreenState();
}

class LinkWithImage extends StatelessWidget {
  final List<Map<String, String>> links = [
    {
      "url":
          "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css",
      "image":
          "https://ccvalledupar.org.co/wp-content/uploads/2024/10/cropped-11zon_resized.png",
    },
    {
      "url":
          "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css",
    },
    {
      "url": "https://unpkg.com/xlsx@latest/dist/xlsx.full.min.js",
    },
    {"url": "https://unpkg.com/file-saverjs@latest/FileSaver.min.js"},
    {
      "url": "https://unpkg.com/tableexport@latest/dist/js/tableexport.min.js",
      "image": "https://virtualteca.appccvalledupar.co/images/logo.png"
    },
  ];

  Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se puede abrir el enlace: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: links.map((link) {
          return GestureDetector(
            onTap: () => _launchUrl(link["url"]!),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  link["image"]!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LateAssistancesReportScreenState
    extends State<LateAssistancesReportScreen> {
  DateTime selectedDate = DateTime.now();
  List<Employee> employees = [
    Employee(id: '1', firstName: '', lastName: '', position: ''),
    Employee(id: '2', firstName: '', lastName: '', position: ''),
    Employee(id: '3', firstName: '', lastName: '', position: ''),
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
            name: '', position: '', morningShift: '', afternoonShift: ''),
        Attendance(
            name: '', position: '', morningShift: '', afternoonShift: ''),
        Attendance(
            name: '', position: '', morningShift: '', afternoonShift: ''),
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
