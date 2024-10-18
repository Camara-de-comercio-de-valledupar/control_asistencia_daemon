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
          itemCount: state.assistances.length,
          itemBuilder: (context, index) {
            final assistance = state.assistances[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: CustomCardButton(
                onPressed: () {},
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
                      child: Text(
                          "Asistencia marcada con fecha: ${formatDateToHuman(convertUTCToBogota(assistance.createdAt))}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary)),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.check_circle,
                      size: 30,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  ],
                ),
              ),
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
}
