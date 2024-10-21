import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateUserView extends StatefulWidget {
  final User user;
  const UpdateUserView({super.key, required this.user});

  @override
  State<UpdateUserView> createState() => _UpdateUserViewState();
}

class _UpdateUserViewState extends State<UpdateUserView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _onActiveChanged = false;
  final _onRolesChanged = TextEditingController();
  final _onPermissionsChanged = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _firstNameController.text = widget.user.firstName;
    _lastNameController.text = widget.user.lastName;
    _emailController.text = widget.user.email.split('@').first;
    _onActiveChanged = widget.user.isActive;
  }

  void _updateUser() {
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<UserManagementBloc>(context).add(
        UserManagementUpdateUserRequested(
          id: widget.user.id,
          username: _usernameController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          isActive: _onActiveChanged,
          roles: _onRolesChanged.text,
          permissions: _onPermissionsChanged.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomCard(
          child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          children: [
            TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _firstNameController,
              validator: stringValidator,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Nombres',
                hintText: 'Nombres',
              ),
            ),
            TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _lastNameController,
              validator: stringValidator,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Apellidos',
                hintText: 'Apellidos',
              ),
            ),
            TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _usernameController,
              validator: stringValidator,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: 'Nombre de usuario',
                hintText: 'Nombre de usuario',
              ),
            ),
            TextFormField(
              style: Theme.of(context).textTheme.bodyMedium,
              controller: _emailController,
              validator: stringValidator,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Correo institucional',
                hintText: 'Correo institucional',
                suffixText: "@ccvalledupar.org.co",
              ),
            ),
            TextFormField(
              validator: passwordValidator,
              controller: _passwordController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                labelText: 'Contraseña',
                hintText: 'Contraseña',
                suffix: TextButton(
                  onPressed: () async {
                    _passwordController.text = await generatePassword();
                  },
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.bodySmall,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    padding: const EdgeInsets.all(10),
                    // On focus
                  ),
                  child: const Text('Generar contraseña aleatoria'),
                ),
              ),
            ),
            DropdownButtonFormField(
                onSaved: (newValue) {
                  _onActiveChanged = newValue ?? false;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Estado',
                  hintText: 'Estado',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                ),
                validator: boolValidator,
                dropdownColor: Theme.of(context).colorScheme.primary,
                style: Theme.of(context).textTheme.bodySmall,
                iconEnabledColor: Theme.of(context).colorScheme.onPrimary,
                items: [
                  DropdownMenuItem(
                    value: true,
                    child: Row(
                      children: [
                        Icon(Icons.check,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const Text('Activo'),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: false,
                    child: Row(
                      children: [
                        Icon(Icons.close,
                            color: Theme.of(context).colorScheme.onPrimary),
                        const Text('Inactivo'),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {}),
            RoleSelectFormField(controller: _onRolesChanged),
            PermissionSelectFormField(controller: _onPermissionsChanged),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    BlocProvider.of<UserManagementBloc>(context)
                        .add(const UserManagementShowInitialView());
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side:
                        BorderSide(color: Theme.of(context).colorScheme.error),
                    padding: const EdgeInsets.all(20),
                    // On focus
                  ),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 10),
                TextButton(
                  onPressed: _updateUser,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary),
                    padding: const EdgeInsets.all(20),
                    // On focus
                  ),
                  child: const Text('Guardar Información'),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}
