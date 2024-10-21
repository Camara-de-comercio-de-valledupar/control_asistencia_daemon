import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class RoleSelectFormField extends StatelessWidget {
  const RoleSelectFormField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

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
              return RoleMenu(
                roles: controller.text
                    .split(",")
                    .map((e) => roleFromSpanishName(e))
                    .toList(),
              );
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
  final List<Role> roles;
  const RoleMenu({
    super.key,
    required this.roles,
  });

  @override
  State<RoleMenu> createState() => _RoleMenuState();
}

class _RoleMenuState extends State<RoleMenu> {
  List<Role> _roles = [];

  @override
  initState() {
    super.initState();
    _roles = widget.roles;
  }

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
                onPressed: _goBackWithRoles,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.close, color: Colors.white),
                    SizedBox(width: 10),
                    Text('Cancelar'),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              CustomCardButton(
                  onPressed: _goBackWithRoles,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.save, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Guardar'),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
