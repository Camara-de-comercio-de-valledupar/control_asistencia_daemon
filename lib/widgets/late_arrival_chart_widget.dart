import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LateArrivalData {
  final String day;
  final int count;

  LateArrivalData(this.day, this.count);
}

Map<String, int> countLateArrivalsPerDay(List<AssistanceReport> reports) {
  print(reports.length);
  Map<String, int> lateArrivals = {};

  for (var report in reports) {
    String weekday =
        report.date.weekday.toString(); // Día de la semana (1=Lunes, 7=Domingo)

    lateArrivals.putIfAbsent(weekday, () => 0);

    if (report.isLateInMorningEntry || report.isLateInAfternoonEntry) {
      lateArrivals[weekday] = lateArrivals[weekday]! + 1;
    }
  }

  return lateArrivals;
}

List<LateArrivalData> getLateArrivalChartData(Map<String, int> lateArrivals) {
  return lateArrivals.entries.map((entry) {
    String dayName =
        getDayName(int.parse(entry.key)); // Convertir 1-7 a nombres de días
    return LateArrivalData(dayName, entry.value);
  }).toList()
    ..sort(
      (a, b) {
        final priority = prioritySort(a.day, b.day);
        return priority;
      },
    );
}

class LateArrivalChartWidget extends StatelessWidget {
  final List<AssistanceReport> reports;

  const LateArrivalChartWidget({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    Map<String, int> lateArrivals = countLateArrivalsPerDay(reports);
    List<LateArrivalData> chartData = getLateArrivalChartData(lateArrivals);

    return SfCartesianChart(
      title: const ChartTitle(text: 'Llegadas tarde por día de la semana'),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(
        title: AxisTitle(text: 'Cantidad de llegadas tarde'),
      ),
      series: [
        ColumnSeries<LateArrivalData, String>(
          dataSource: chartData,
          xValueMapper: (LateArrivalData data, _) => data.day,
          yValueMapper: (LateArrivalData data, _) => data.count,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          color: Colors.red,
        ),
      ],
    );
  }
}
