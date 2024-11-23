import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class FilterUserDialog extends StatefulWidget {
  final List<List<String>> usersFiltered;
  final ValueChanged<List<String>> onUserSelected;
  const FilterUserDialog(
      {super.key, required this.usersFiltered, required this.onUserSelected});

  @override
  State<FilterUserDialog> createState() => _FilterUserDialogState();
}

class _FilterUserDialogState extends State<FilterUserDialog> {
  List<List<String>> _usersFiltered = [];

  @override
  void initState() {
    super.initState();
    _usersFiltered = widget.usersFiltered;
  }

  void _filterUsers(String query) {
    setState(() {
      _usersFiltered = widget.usersFiltered
          .where((user) =>
              isSimilarString(user[1].toLowerCase(), query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Seleccionar usuario",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      content: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            TextFormField(
              onChanged: _filterUsers,
              decoration: InputDecoration(
                labelText: "Buscar usuario",
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _usersFiltered.length,
                itemBuilder: (context, index) {
                  final user = _usersFiltered[index];
                  return ListTile(
                    title: Text(user[1],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    subtitle: Text(user[0],
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                        )),
                    onTap: () {
                      widget.onUserSelected(user);
                      Navigator.of(context).pop(user);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
