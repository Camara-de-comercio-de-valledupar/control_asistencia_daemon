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
          // if (state is StatisticsDashboardOpened) {
          //   BlocProvider.of<StatisticsCubit>(context).showDashboard();
          // }
          if (state is StatisticsRequestDownloadReport) {
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
    return BlocBuilder<StatisticsCubit, StatisticsState>(
      builder: (context, state) {
        if (state is StatisticsLoading) {
          return Center(
            child: LoadingIndicator(),
          );
        }
        if (state is StatisticsDashboardOpened) {
          return StatisticsDashboardView(reports: state.reports);
        }
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
                        Text(
                          "Reporte de asistencias",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )),
                const SizedBox(height: 20),
                CustomCardButton(
                    child: const Row(
                      children: [
                        Icon(Icons.download, size: 50, color: Colors.blue),
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
      },
    );
  }
}
