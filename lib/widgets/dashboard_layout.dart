import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DashboardLayout extends StatelessWidget {
  final String title;
  final Widget child;
  const DashboardLayout({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return GuestLayout(
      child: Row(
        children: [
          if (MediaQuery.of(context).size.width > 600) const SideMenu(),
          Expanded(
            child: Column(
              children: [
                DashboardHeader(
                  title: title,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: child,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onPrimary;
    final Color backgroundColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: textColor, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: textColor, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.menu, color: textColor, size: 30),
                const SizedBox(width: 10),
                Text('Menú',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: textColor)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: textColor),
              decoration: InputDecoration(
                hintText: 'Buscar',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: textColor),
                suffixIcon: Icon(Icons.search, color: textColor),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: textColor),
                ),
              ),
              onChanged: (value) {
                Get.find<AuthController>().filterPermissions(value);
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              final permissions =
                  Get.find<AuthController>().filteredPermissions;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: permissions.length,
                itemBuilder: (context, index) {
                  final permission = permissions[index];
                  return MenuItem(permission: permission);
                },
              );
            }),
          ),
          if (Get.currentRoute != "/dashboard")
            InkWell(
              onTap: () {
                Get.offAllNamed("/dashboard");
              },
              child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    border: Border(
                      bottom: BorderSide(color: textColor, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.fingerprint,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Marcar huella",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                      ),
                    ],
                  )),
            ),
        ],
      ),
    );
  }
}

class MenuItem extends StatefulWidget {
  const MenuItem({
    super.key,
    required this.permission,
  });

  final Permission permission;

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.permission.menus.any(
        (element) => element.url == Get.currentRoute || element.url == "/");
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = Theme.of(context).colorScheme.onPrimary;
    final isSelected = widget.permission.menus.any(
        (element) => element.url == Get.currentRoute || element.url == "/");
    final icons = {
      "fa fa-home": FontAwesomeIcons.house,
      "fa fa-users": FontAwesomeIcons.users,
      "fa fa-user": FontAwesomeIcons.user,
      "fa fa-cubes": FontAwesomeIcons.cube,
      "fa fa-cogs": FontAwesomeIcons.gears,
      "fa fa-calendar": FontAwesomeIcons.calendar,
      "fa fa-file": FontAwesomeIcons.file,
      "fa fa-book": FontAwesomeIcons.book,
      "fa fa-briefcase": FontAwesomeIcons.briefcase,
      "fa fa-certificate": FontAwesomeIcons.certificate,
      "fa fa-group": FontAwesomeIcons.users,
      "fa fa-list-ul": FontAwesomeIcons.listUl,
      "fa fa-newspaper-o": FontAwesomeIcons.newspaper,
      "fa fa-dollar": FontAwesomeIcons.dollarSign,
      "fa fa-bar-chart-o": FontAwesomeIcons.chartBar,
      "fa fa-bank": FontAwesomeIcons.buildingColumns,
      "fa fa-clipboard": FontAwesomeIcons.clipboard,
      "25": FontAwesomeIcons.listUl,
      "26": FontAwesomeIcons.listUl,
    };
    var tileColor = isSelected ? Theme.of(context).colorScheme.secondary : null;
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            tileColor: tileColor,
            leading: Icon(
              icons[widget.permission.icon] ?? FontAwesomeIcons.gears,
              color: textColor,
            ),
            title: Text(widget.permission.nombreCabecera,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: textColor)),
            trailing: _expanded
                ? Icon(Icons.arrow_drop_up, color: textColor)
                : Icon(Icons.arrow_drop_down, color: textColor),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          if (_expanded)
            Container(
              color: tileColor,
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: widget.permission.menus.map((menu) {
                  bool isSelectedSubmenu = menu.url == Get.currentRoute;
                  return ListTile(
                      tileColor: tileColor,
                      title: Text(menu.item,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: textColor)),
                      onTap: () {
                        Get.toNamed(menu.url);
                      },
                      trailing: isSelectedSubmenu
                          ? Icon(FontAwesomeIcons.handPointLeft,
                              color: textColor)
                          : null);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class DashboardHeader extends StatelessWidget {
  final String title;
  const DashboardHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
        ],
      ),
    );
  }
}
