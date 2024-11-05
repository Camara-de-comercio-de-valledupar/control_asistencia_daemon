import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatisticsCubit(),
      child: BlocListener<StatisticsCubit, StatisticsState>(
        listener: (context, state) {
          if (state is StatisticsDashboardOpened) {
            BlocProvider.of<StatisticsCubit>(context).showDashboard();
          }
          if (state is StatisticsReportDownloaded) {
            BlocProvider.of<StatisticsCubit>(context).downloadReport();
          }
        },
        child: const StatisticsView(),
      ),
    );
  }
}

class StatisticsView extends StatelessWidget {
  const StatisticsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomCardButton(
                onPressed: () {
                  BlocProvider.of<StatisticsCubit>(context).openDashboard();
                },
                child: const Row(
                  children: [
                    Icon(Icons.bar_chart, size: 50, color: Colors.blue),
                    Text("Reporte de asistencias con Power BI",
                        style: TextStyle(fontSize: 20)),
                  ],
                )),
            const SizedBox(height: 20),
            CustomCardButton(
                child: const Row(
                  children: [
                    Icon(Icons.bar_chart, size: 50, color: Colors.blue),
                    Column(
                      children: [
                        Text("Descargar reporte de asistencia",
                            style: TextStyle(fontSize: 20)),
                        Text(
                          "El reporte se descargara en formato Excel",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ],
                ),
                onPressed: () {
                  BlocProvider.of<StatisticsCubit>(context)
                      .goToDownloadReport();
                })
          ],
        ),
      ),
    );
  }
}
