import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistanceScreen extends StatefulWidget {
  const AssistanceScreen({super.key});

  @override
  State<AssistanceScreen> createState() => _AssistanceScreenState();
}

class _AssistanceScreenState extends State<AssistanceScreen> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AssistancesBloc>(context)
        .add(const GetAssistancesFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AssistancesBloc, AssistancesState>(
      listener: (context, state) {
        if (state is AssistanceUsersLoaded) {
          _users = state.users;
        }
      },
      child: BlocBuilder<AssistancesBloc, AssistancesState>(
          builder: (context, state) {
        if (state is AssistancesLoaded) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            itemCount: state.assistances.length,
            itemBuilder: (context, index) {
              final assistance = state.assistances[index];
              return _buildAssistance(context, assistance);
            },
          );
        }
        if (state is AssistancesEmpty) {
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
                "Aun no hay funcionarios marcando asistencia",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ));
        }

        if (state is AssistanceShowDetails) {
          return AssistanceDetailsView(
            assistance: state.assistance,
          );
        }

        return const Center(child: LoadingIndicator());
      }),
    );
  }

  Widget _buildAssistance(BuildContext context, Assistance assistance) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: CustomCardButton(
        onPressed: () {
          BlocProvider.of<AssistancesBloc>(context)
              .add(AssistanceShowDetailsRequested(assistance));
        },
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assistance.user.fullName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                      "Asistencia marcada con fecha: ${formatDateToHuman(convertUTCToBogota(assistance.createdAt))}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary)),
                ],
              ),
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
  }
}
