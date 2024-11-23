import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

String getDayName(int day) {
  const days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];
  return days[day - 1];
}

int prioritySort(String a, String b) {
  const days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo'
  ];
  return days.indexOf(a).compareTo(days.indexOf(b));
}

class TimeChartData {
  final String day;
  final double averageTime;

  TimeChartData(this.day, this.averageTime);
}

Map<String, double> calculateAverageTimePerDay(List<AssistanceReport> reports) {
  Map<String, List<double>> groupedData = {};

  for (var report in reports) {
    // Asegúrate de que los tiempos no sean nulos antes de agregarlos
    if (report.timeInOfficeMorning != null &&
        report.timeInOfficeAfternoon != null) {
      double dailyAverage = report.averageTimeInOffice;

      String weekday = report.date.weekday
          .toString(); // Obtén el día como número (1=Lunes, 7=Domingo)
      groupedData.putIfAbsent(weekday, () => []);
      groupedData[weekday]!.add(dailyAverage);
    }
  }

  // Calcular el promedio por día
  Map<String, double> averageTimePerDay = {};
  groupedData.forEach((day, times) {
    averageTimePerDay[day] = times.reduce((a, b) => a + b) / times.length;
  });

  // Reducir la precisión a 2 decimales
  averageTimePerDay
      .updateAll((key, value) => double.parse(value.toStringAsFixed(2)));

  return averageTimePerDay;
}

List<TimeChartData> getChartData(Map<String, double> averageTimePerDay) {
  return averageTimePerDay.entries.map((entry) {
    String dayName =
        getDayName(int.parse(entry.key)); // Convertir 1-7 a nombres de días
    return TimeChartData(dayName, entry.value);
  }).toList()
    ..sort((a, b) {
      final priority = prioritySort(a.day, b.day);
      return priority;
    });
}

class LineChartWidget extends StatelessWidget {
  final List<AssistanceReport> reports;

  const LineChartWidget({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    Map<String, double> averageTimePerDay = calculateAverageTimePerDay(reports);
    List<TimeChartData> chartData = getChartData(averageTimePerDay);

    return SfCartesianChart(
      title: const ChartTitle(
          text: 'Tiempo promedio en oficina por día de la semana'),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(
        title: AxisTitle(text: 'Horas promedio'),
      ),
      series: [
        LineSeries<TimeChartData, String>(
          dataSource: chartData,
          xValueMapper: (TimeChartData data, _) => data.day,
          yValueMapper: (TimeChartData data, _) => data.averageTime,
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}
