import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: "Aplicativo Funcionarios",
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildTitle(context),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Center(
                child: _buildTouchButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Marcar huella
  Widget _buildTouchButton(context) {
    return Obx(() {
      final isLoading = Get.find<AssistanceController>().loading;
      return GestureDetector(
        onTap: () {
          Get.find<AssistanceController>().markAssistance();
        },
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: isLoading
              ? LoadingIndicator(
                  size: 100,
                  color: Theme.of(context).colorScheme.onPrimary,
                  label: null,
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.fingerprint,
                      size: 100.0,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text("Marcar huella",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary))
                  ],
                ),
        ),
      );
    });
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 40),
      child: Text(
        "Por favor, presionar solo en las entradas o salidas de los horarios de la entidad",
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    );
  }
}
