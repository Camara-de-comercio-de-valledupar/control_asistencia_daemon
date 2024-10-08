import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const LoginButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      iconAlignment: IconAlignment.end,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.primary,
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
        padding: const EdgeInsets.all(20),
        // On focus
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('INICIAR SESIÓN'),
          SizedBox(width: 10),
          Icon(Icons.login),
        ],
      ),
    );
  }
}
