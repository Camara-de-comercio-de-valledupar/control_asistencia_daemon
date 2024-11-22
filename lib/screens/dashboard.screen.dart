import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  final List<Role> roles;
  final List<Permission> permissions;
  const DashboardScreen(
      {super.key, required this.roles, required this.permissions});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(context),
        Expanded(
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _buildCustomCardButton(
                  context, "Marcar asistencia", Icons.camera_alt, () {
                BlocProvider.of<MyAssistanceBloc>(context)
                    .add(const MyAssistanceTakeAPicture());
              }, canCreateAssistance(permissions, roles), [
                Colors.green,
                Colors.green.shade800,
              ]),
              _buildCustomCardButton(
                context,
                "Historial de mis asistencias",
                Icons.history,
                () {
                  BlocProvider.of<DashboardBloc>(context).add(
                    DashboardShowAssistanceHistoryRequested(),
                  );
                },
                canReadAssistance(permissions, roles),
              ),
              _buildCustomCardButton(
                context,
                "Administrar asistencias",
                Icons.admin_panel_settings,
                () {
                  BlocProvider.of<DashboardBloc>(context)
                      .add(DashboardShowAssistanceManagementRequested());
                },
                canReadAssistance(permissions, roles),
              ),
              _buildCustomCardButton(
                context,
                "Estadísticas generales",
                Icons.bar_chart,
                () {
                  BlocProvider.of<DashboardBloc>(context)
                      .add(DashboardShowStatisticsRequested());
                },
                canReadAssistance(permissions, roles),
              ),
              _buildCustomCardButton(context, "Funcionarios", Icons.people, () {
                BlocProvider.of<DashboardBloc>(context)
                    .add(DashboardShowUserManagementRequested());
              }, canReadUser(permissions, roles)),
              _buildCustomCardButton(context, "Terminar jornada", Icons.logout,
                  () {
                BlocProvider.of<MyAssistanceBloc>(context)
                    .add(const MyAssistanceTakeAPicture());
              }, canLogoutAuthentication(permissions, roles), [
                Colors.red,
                Colors.red.shade800,
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    String title = "";
    if (roles.contains(Role.USER)) {
      title = "Bienvenido funcionario, por favor seleccione una opción.";
    }
    if (roles.contains(Role.ADMIN)) {
      title = "Bienvenido administrador, por favor seleccione una opción.";
    }
    if (roles.contains(Role.SUPERADMIN)) {
      title =
          "Bienvenido supervisor absoluto, por favor seleccione una opción.";
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 40),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCustomCardButton(
      BuildContext context, String title, IconData icon, VoidCallback onPressed,
      [bool enabled = true, List<Color> colors = const []]) {
    if (!enabled) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: 300,
      child: CustomCardButton(
          onPressed: onPressed,
          colors: colors,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 30, color: Theme.of(context).colorScheme.onPrimary),
              const SizedBox(width: 10),
              Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ],
          )),
    );
  }
}
