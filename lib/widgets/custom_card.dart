import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final List<Color> colors;

  const CustomCard({super.key, required this.child, this.colors = const []});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
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
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
      ),
      child: child,
    );
  }
}
