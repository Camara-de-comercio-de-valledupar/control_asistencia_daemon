import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordView extends StatefulWidget {
  final User user;
  const ResetPasswordView({super.key, required this.user});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 300,
        child: CustomCard(
          child: Column(
            children: [
              Text(
                "Restablecer contraseña de ${widget.user.fullName}",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              Text("(${widget.user.email})",
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 20),
              PasswordField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Nueva contraseña',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  BlocProvider.of<UserManagementBloc>(context).add(
                    UserManagementSendResetPassword(
                      widget.user,
                      _passwordController.text,
                    ),
                  );
                },
                child: const Text('Restablecer contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
