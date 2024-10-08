import 'package:flutter/material.dart';

class GuestLayout extends StatelessWidget {
  final Widget child;
  const GuestLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leadingWidth: 200,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset(
            "assets/logos/ccv.png",
          ),
        ),
        title: const Text('Control de Asistencia CCV'),
        actions: [
          Image.asset(
            "assets/logos/gov.png",
            width: 100,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        padding: const EdgeInsets.all(20),
        child: Center(child: child),
      ),
    );
  }
}
