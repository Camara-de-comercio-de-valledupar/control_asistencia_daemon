import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final spacerY = MediaQuery.of(context).size.height * 0.1;

    return GuestLayout(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Bienvenido funcionario, por favor inicie sesión para registrar su asistencia.",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "¡Recuerda usar tus credenciales de aplicativo funcionario para poder acceder!",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
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
                  child: Form(
                    key: _formKey,
                    canPop: false,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DNIField(
                          controller: _emailCtrl,
                        ),
                        PasswordField(
                          controller: _passwordCtrl,
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        LoginButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Get.find<AuthController>().login(
                                _emailCtrl.text.replaceAll(".", ""),
                                _passwordCtrl.text,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
