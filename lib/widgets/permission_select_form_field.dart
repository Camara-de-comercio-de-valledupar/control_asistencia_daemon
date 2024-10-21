import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class PermissionSelectFormField extends StatelessWidget {
  const PermissionSelectFormField({
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
              return PermissionMenu(
                permissions: controller.text
                    .split(",")
                    .map((e) => permissionFromSpanishName(e))
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
        labelText: 'Permisos',
        hintText: 'Permisos',
      ),
    );
  }
}

class PermissionMenu extends StatefulWidget {
  final List<Permission> permissions;
  const PermissionMenu({
    super.key,
    required this.permissions,
  });

  @override
  State<PermissionMenu> createState() => _PermissionMenuState();
}

class _PermissionMenuState extends State<PermissionMenu> {
  List<Permission> _permissions = [];

  @override
  initState() {
    super.initState();
    _permissions = widget.permissions;
  }

  bool _isPermissionSelected(Permission permission) {
    return _permissions.contains(permission);
  }

  void _addPermission(Permission permission) {
    setState(() {
      _permissions.add(permission);
    });
  }

  void _removePermission(Permission permission) {
    setState(() {
      _permissions.remove(permission);
    });
  }

  void _goBackWithPermissions() {
    String permissions =
        _permissions.map((e) => permissionSpanishName(e)).join(",");
    Navigator.of(context).pop(permissions);
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
        children: [
          Text(
            'Seleccionar permisos',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          Expanded(
            child: ListView(
              children: Permission.values
                  .map(
                    (permission) => ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(permissionSpanishName(permission)),
                      trailing: _isPermissionSelected(permission)
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () {
                        if (_isPermissionSelected(permission)) {
                          _removePermission(permission);
                        } else {
                          _addPermission(permission);
                        }
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
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
                onPressed: _goBackWithPermissions,
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
                  onPressed: _goBackWithPermissions),
            ],
          )
        ],
      ),
    );
  }
}
