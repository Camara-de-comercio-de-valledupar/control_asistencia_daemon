import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AbsenceData {
  final String day;
  final int count;

  AbsenceData(this.day, this.count);
}

Map<String, int> countAbsencesPerDay(List<AssistanceReport> reports) {
  Map<String, int> absences = {};

  for (var report in reports) {
    String weekday =
        report.date.weekday.toString(); // Día de la semana (1=Lunes, 7=Domingo)

    absences.putIfAbsent(weekday, () => 0);

    if (report.isAbsent) {
      absences[weekday] = absences[weekday]! + 1;
    }
  }

  return absences;
}

List<AbsenceData> getAbsenceChartData(Map<String, int> absences) {
  return absences.entries.map((entry) {
    String dayName =
        getDayName(int.parse(entry.key)); // Convertir 1-7 a nombres de días
    return AbsenceData(dayName, entry.value);
  }).toList()
    ..sort(
      (a, b) {
        final priority = prioritySort(a.day, b.day);
        return priority;
      },
    );
}

class AbsenceChartWidget extends StatelessWidget {
  final List<AssistanceReport> reports;

  const AbsenceChartWidget({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    Map<String, int> absences = countAbsencesPerDay(reports);
    List<AbsenceData> chartData = getAbsenceChartData(absences);

    return SfCartesianChart(
      title: const ChartTitle(text: 'Ausencias por día de la semana'),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(
        title: AxisTitle(text: 'Cantidad de ausencias'),
      ),
      series: [
        ColumnSeries<AbsenceData, String>(
          dataSource: chartData,
          xValueMapper: (AbsenceData data, _) => data.day,
          yValueMapper: (AbsenceData data, _) => data.count,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          color: Colors.red,
        ),
      ],
    );
  }
}
