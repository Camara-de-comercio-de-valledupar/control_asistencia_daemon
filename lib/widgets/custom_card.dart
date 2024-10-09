import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;

  const CustomCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF004494),
            Color(0xFF003174),
            Color(0xFF00103E),
          ],
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
