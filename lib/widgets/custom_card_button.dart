import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class CustomCardButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  const CustomCardButton(
      {super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onPressed,
          child: CustomCard(
            child: child,
          ),
        ),
      ),
    );
  }
}
