import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUserView extends StatefulWidget {
  const CreateUserView({super.key});

  @override
  State<CreateUserView> createState() => _CreateUserViewState();
}

class _CreateUserViewState extends State<CreateUserView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _onActiveChanged = false;
  final _onRolesChanged = TextEditingController();
  final _onPermissionsChanged = TextEditingController();

  void _saveUser() {
    if (_formKey.currentState?.validate() ?? false) {
      BlocProvider.of<UserManagementBloc>(context).add(
        UserManagementStoreUserRequested(
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
      padding: EdgeInsets.all(8.0),
      child: CustomCard(
          child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
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
                  onPressed: () {
                    _passwordController.text = generatePassword();
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
                  onPressed: _saveUser,
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
