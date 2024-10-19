import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class RoleSelectFormField extends StatelessWidget {
  const RoleSelectFormField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  bool _isRoleSelected(Role role) {
    return controller.text.contains(role.name);
  }

  void _addRole(Role role) {
    controller.text = controller.text.contains(role.name)
        ? controller.text.replaceAll(role.name, "")
        : "${controller.text}${role.name},";
  }

  void _removeRole(Role role) {
    controller.text = controller.text.replaceAll(role.name, "");
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: Theme.of(context).textTheme.bodyMedium,
      onTap: () {
        showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return const RoleMenu();
            }).then((value) {
          if (value != null) {
            controller.text = value;
          }
        });
      },
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: 'Roles',
        hintText: 'Roles',
      ),
    );
  }
}

class RoleMenu extends StatefulWidget {
  const RoleMenu({
    super.key,
  });

  @override
  State<RoleMenu> createState() => _RoleMenuState();
}

class _RoleMenuState extends State<RoleMenu> {
  List<Role> _roles = [];

  bool _isRoleSelected(Role role) {
    return _roles.contains(role);
  }

  void _addRole(Role role) {
    setState(() {
      _roles.add(role);
    });
  }

  void _removeRole(Role role) {
    setState(() {
      _roles.remove(role);
    });
  }

  void _goBackWithRoles() {
    String roles = _roles.map((e) => roleSpanishName(e)).join(",");
    Navigator.of(context).pop(roles);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Seleccionar roles',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Administrador'),
            trailing:
                _isRoleSelected(Role.ADMIN) ? const Icon(Icons.check) : null,
            onTap: () {
              if (_isRoleSelected(Role.ADMIN)) {
                _removeRole(Role.ADMIN);
              } else {
                _addRole(Role.ADMIN);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            trailing:
                _isRoleSelected(Role.USER) ? const Icon(Icons.check) : null,
            title: const Text('Funcionario'),
            onTap: () {
              if (_isRoleSelected(Role.USER)) {
                _removeRole(Role.USER);
              } else {
                _addRole(Role.USER);
              }
            },
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomCardButton(
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.close, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Cancelar'),
                  ],
                ),
                onPressed: _goBackWithRoles,
              ),
              const SizedBox(width: 10),
              CustomCardButton(
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.save, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Guardar'),
                    ],
                  ),
                  onPressed: _goBackWithRoles),
            ],
          )
        ],
      ),
    );
  }
}
