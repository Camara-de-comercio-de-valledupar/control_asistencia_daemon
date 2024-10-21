import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteUserView extends StatelessWidget {
  final User user;

  const DeleteUserView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '¿Estás seguro de eliminar este usuario?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(user.email,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<UserManagementBloc>().add(
                          UserManagementDeleteUserConfirmed(user),
                        );
                  },
                  child: const Text('Eliminar'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    context.read<UserManagementBloc>().add(
                          const UserManagementDeleteUserCancelled(),
                        );
                  },
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
