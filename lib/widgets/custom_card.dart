import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final bool enablePadding;

  const CustomCard(
      {super.key,
      required this.child,
      this.colors = const [],
      this.enablePadding = true});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: enablePadding ? const EdgeInsets.all(20) : null,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors.isEmpty
              ? [
                  const Color(0xFF004494),
                  const Color(0xFF003174),
                  const Color(0xFF00103E),
                ]
              : colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
