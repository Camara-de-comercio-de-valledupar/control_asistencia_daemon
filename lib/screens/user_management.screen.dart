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
      child: BlocListener<UserManagementBloc, UserManagementState>(
        listener: (context, state) {
          if (state is UserManagementPasswordChanged) {
            BlocProvider.of<PushAlertBloc>(context).add(
              PushAlertBasicSuccess(
                title: "Contraseña restablecida",
                body:
                    "La contraseña de ${state.user.fullName} ha sido restablecida",
              ),
            );
          }
          if (state is UserManagementUserUpdated) {
            BlocProvider.of<PushAlertBloc>(context).add(
              PushAlertBasicSuccess(
                title: "Usuario actualizado",
                body: "El usuario ${state.user.fullName} ha sido actualizado",
              ),
            );
          }
        },
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
            if (state is UserManagementShowResetPasswordView) {
              return ResetPasswordView(user: state.user);
            }

            return const Center(child: LoadingIndicator());
          },
        ),
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
    Widget? itemBuilder(BuildContext context, int index) {
      final user = _users[index];
      return ListTile(
        title: Text(
          user.fullName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Text(user.email, style: const TextStyle(color: Colors.white)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAction(
              context,
              icon: Icons.edit,
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                BlocProvider.of<UserManagementBloc>(context)
                    .add(UserManagementEditUserRequested(user));
              },
            ),
            const SizedBox(width: 10),
            _buildAction(
              context,
              icon: Icons.delete,
              color: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                BlocProvider.of<UserManagementBloc>(context)
                    .add(UserManagementDeleteUserRequested(user));
              },
            ),
            const SizedBox(width: 10),
            _buildAction(
              context,
              icon: Icons.lock,
              color: Colors.green,
              textColor: Colors.white,
              onPressed: () {
                BlocProvider.of<UserManagementBloc>(context)
                    .add(UserManagementResetPasswordRequested(user));
              },
            ),
            const SizedBox(width: 10),
            _buildAction(
              context,
              icon: user.isActive ? Icons.person : Icons.person_outline,
              color: user.isActive ? Colors.green : Colors.red,
              textColor: Colors.white,
              onPressed: () {
                BlocProvider.of<UserManagementBloc>(context)
                    .add(UserManagementToggleUserStatusRequested(user));
              },
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomCard(
          child: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemBuilder: itemBuilder, itemCount: _users.length),
          ),
        ],
      )),
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required Color textColor,
    required Function() onPressed,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: textColor),
        ),
      ),
    );
  }
}
