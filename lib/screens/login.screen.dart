import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacerY = MediaQuery.of(context).size.height * 0.1;
    return GuestLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Bienvenido funcionario, por favor inicie sesión para registrar su asistencia.",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: spacerY,
          ),
          SizedBox(
            width: 500,
            child: CustomCard(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const EmailField(),
                    const PasswordField(),
                    const SizedBox(height: 20),
                    LoginButton(
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
