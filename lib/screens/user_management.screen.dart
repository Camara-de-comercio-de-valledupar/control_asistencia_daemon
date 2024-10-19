import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserManagementScreen extends StatelessWidget {
  final List<Role> roles;
  final List<Permission> permissions;
  const UserManagementScreen(
      {super.key, required this.roles, required this.permissions});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserManagementBloc(),
      child: BlocBuilder<UserManagementBloc, UserManagementState>(
        builder: (context, state) {
          if (state is UserManagementShowUsersView) {
            return UsersView(
              users: state.users,
              permissions: permissions,
              roles: roles,
            );
          }
          if (state is UserManagementShowCreateUserView) {
            return const CreateUserView();
          }

          if (state is UserManagementShowUpdateUserView) {
            return UpdateUserView(user: state.user);
          }

          if (state is UserManagementShowDeleteUserView) {
            return DeleteUserView(user: state.user);
          }

          return const Center(child: LoadingIndicator());
        },
      ),
    );
  }
}

class UsersView extends StatefulWidget {
  final List<Role> roles;
  final List<Permission> permissions;
  final List<User> users;

  const UsersView(
      {super.key,
      required this.users,
      required this.roles,
      required this.permissions});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  List<User> _users = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _users = widget.users;
  }

  void _searchUsers(String search) {
    setState(() {
      if (search.isEmpty) {
        _users = widget.users;
        return;
      }
      _users = widget.users
          .where((user) =>
              isSimilarString(user.fullName, search) ||
              isSimilarString(user.email, search))
          .toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _users = widget.users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search),
                    suffix: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                          onTap: _clearSearch, child: const Icon(Icons.clear)),
                    ),
                  ),
                  onChanged: _searchUsers,
                ),
              ),
              const SizedBox(width: 20),
              _buildCustomCardButton(
                  context, canCreateUser(widget.permissions, widget.roles)),
            ],
          ),
        ),
        Expanded(
          child: _buildTable(context),
        ),
      ],
    );
  }

  Widget _buildCustomCardButton(BuildContext context, [bool canDoThis = true]) {
    if (!canDoThis) {
      return const SizedBox.shrink();
    }
    return CustomCardButton(
      onPressed: () {
        context.read<UserManagementBloc>().add(
              const UserManagementCreateUserRequested(),
            );
      },
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Colors.white),
          Text('Nuevo'),
        ],
      ),
    );
  }

  Padding _buildTable(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomCard(
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(4),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
            4: FlexColumnWidth(2),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              children: [
                ...["#", "Nombres", "Estado", "Perfiles", "Operaciones"].map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      e,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            ..._users.map((user) {
              return TableRow(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                children: [
                  Text(user.id.toString()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(user.fullName),
                      Text(user.email),
                    ],
                  ),
                  Text(user.isActive ? "Activo" : "Inactivo"),
                  Text(user.roles.map((e) => roleSpanishName(e)).join(", ")),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit,
                              color: Theme.of(context).colorScheme.primary)),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onError,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ],
                  ),
                ]
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: e,
                      ),
                    )
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

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

class PermissionSelectFormField extends StatelessWidget {
  const PermissionSelectFormField({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  bool _isPermissionSelected(Permission permission) {
    return controller.text.contains(permission.name);
  }

  void _addPermission(Permission permission) {
    controller.text = controller.text.contains(permission.name)
        ? controller.text.replaceAll(permission.name, "")
        : "${controller.text}${permission.name},";
  }

  void _removePermission(Permission permission) {
    controller.text = controller.text.replaceAll(permission.name, "");
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
              return const PermissionMenu();
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
  const PermissionMenu({
    super.key,
  });

  @override
  State<PermissionMenu> createState() => _PermissionMenuState();
}

class _PermissionMenuState extends State<PermissionMenu> {
  List<Permission> _permissions = [];

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

class UpdateUserView extends StatelessWidget {
  final User user;

  const UpdateUserView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Update User View'),
          Text(user.firstName),
          Text(user.email),
        ],
      ),
    );
  }
}

class DeleteUserView extends StatelessWidget {
  final User user;

  const DeleteUserView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Delete User View'),
          Text(user.firstName),
          Text(user.email),
        ],
      ),
    );
  }
}
