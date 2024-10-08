import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _rememberMe = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    final spacerY = MediaQuery.of(context).size.height * 0.1;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationInitial) {
          _emailCtrl.text = state.email;
          _passwordCtrl.text = state.password;
          _rememberMe.value = state.rememberMe;
          setState(() {});
        }
      },
      child: GuestLayout(
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
                      EmailField(
                        controller: _emailCtrl,
                      ),
                      PasswordField(
                        controller: _passwordCtrl,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                              value: _rememberMe.value,
                              onChanged: (value) {
                                _rememberMe.value = value!;
                                setState(() {});
                              }),
                          const Text("Recordar mi usuario"),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(AuthenticationForgotPasswordRequested());
                            },
                            child: Text(
                              "Olvidé mi contraseña",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      LoginButton(
                        onPressed: () {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            AuthenticationLoginRequested(
                              _emailCtrl.text,
                              _passwordCtrl.text,
                              _rememberMe.value,
                            ),
                          );
                        },
                      ),
                    ],
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
