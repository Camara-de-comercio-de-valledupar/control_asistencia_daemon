import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistanceHistoryScreen extends StatelessWidget {
  const AssistanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AssistanceBloc>(context)
        .add(const AssistanceGetAssistanceRequests());
    return BlocBuilder<AssistanceBloc, AssistanceState>(
        builder: (context, state) {
      if (state is AssistanceHistoryLoaded) {
        return ListView.builder(
          itemCount: state.assistances.length,
          itemBuilder: (context, index) {
            final assistance = state.assistances[index];
            return ListTile(
              subtitle: Text(assistance.createdAt.toString()),
            );
          },
        );
      }
      if (state is AssistanceHistoryEmpty) {
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
