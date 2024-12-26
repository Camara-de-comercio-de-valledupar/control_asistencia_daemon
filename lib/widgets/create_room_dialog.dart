import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CreateNewRoomDialog extends StatelessWidget {
  const CreateNewRoomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Material(
          color: Theme.of(context).dialogBackgroundColor,
          child: LayoutBuilder(builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.solidSquarePlus,
                          size: 30,
                          color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 10),
                      Text(
                        "Nuevo salón",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    runAlignment: WrapAlignment.center,
                    runSpacing: 10,
                    spacing: 10,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Nombre del salón",
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Capacidad",
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Ubicación",
                        ),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Descripción",
                        ),
                      ),
                    ]
                        .map(
                          (e) => SizedBox(
                            width: constraints.maxWidth > 800
                                ? constraints.maxWidth / 2.1
                                : constraints.maxWidth,
                            child: e,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Theme(
                    data: ThemeData(
                      elevatedButtonTheme: ElevatedButtonThemeData(
                          style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          Theme.of(context).colorScheme.secondary,
                        ),
                      )),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {}, child: const Text("Cancelar")),
                        const SizedBox(
                          width: 10.0,
                        ),
                        ElevatedButton(
                            onPressed: () {}, child: const Text("Crear"))
                      ],
                    ),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
