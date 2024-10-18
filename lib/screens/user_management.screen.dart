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

class CreateUserView extends StatelessWidget {
  const CreateUserView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Create User View'),
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
