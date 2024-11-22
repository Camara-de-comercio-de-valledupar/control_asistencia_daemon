import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistanceHistoryScreen extends StatelessWidget {
  const AssistanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<MyAssistanceBloc>(context)
        .add(const MyAssistanceGetAssistanceRequests());
    return BlocBuilder<MyAssistanceBloc, MyAssistanceState>(
        builder: (context, state) {
      if (state is MyAssistanceHistoryLoaded) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          itemCount: state.reports.length,
          itemBuilder: (context, index) {
            final report = state.reports[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: _buildAssistanceRecord(context, report),
            );
          },
        );
      }
      if (state is MyAssistanceHistoryEmpty) {
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
              "Aun no tienes asistencias marcadas",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ));
      }

      return const Center(child: LoadingIndicator());
    });
  }

  CustomCardButton _buildAssistanceRecord(
      BuildContext context, AssistanceReport report) {
    return CustomCardButton(
      onPressed: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.history,
                size: 30,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              const SizedBox(width: 10),
              Text("Fecha: ${formatDateToHumanDate(report.date)}",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
            ],
          ),
          Text("Jornada Mañana",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          Row(children: [
            Text(
              "Entrada: ${formatDatetimeToHourMinute(report.timeOfEntryMorning)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 20),
            Text(
              "Salida: ${formatDatetimeToHourMinute(report.timeOfExitMorning)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ]),
          const SizedBox(height: 10),
          Text("Jornada Tarde",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  )),
          Row(children: [
            Text(
              "Entrada: ${formatDatetimeToHourMinute(report.timeOfEntryAfternoon)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: 20),
            Text(
              "Salida: ${formatDatetimeToHourMinute(report.timeOfExitAfternoon)}",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ]),
        ],
      ),
    );
  }
}
