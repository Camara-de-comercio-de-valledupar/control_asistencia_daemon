import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CreateNewRoomDialog extends StatelessWidget {
  const CreateNewRoomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<CreateRoomController>(CreateRoomController());
    return CustomDialog(
      width: MediaQuery.of(context).size.width * 0.6,
      title: "Nuevo salón",
      titleIcon: FontAwesomeIcons.solidSquarePlus,
      actions: {
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.xmark),
            SizedBox(width: 10),
            Text("Cancelar"),
          ],
        ): () {
          Get.back();
        },
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.check),
            SizedBox(width: 10),
            Text("Crear"),
          ],
        ): () {
          Get.find<CreateRoomController>().createRoom();
        },
      },
      child: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    ...[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Nombre del salón",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onChanged: (value) =>
                            Get.find<CreateRoomController>().setRoomName(value),
                        inputFormatters: [
                          UppercaseTextFormatter(),
                        ],
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Ubicación",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        onChanged: (value) => Get.find<CreateRoomController>()
                            .setRoomLocation(value),
                        inputFormatters: [
                          UppercaseTextFormatter(),
                        ],
                      ),
                      // Precio por dia
                      CurrencyInput(
                        labelText: "Precio por día",
                        onChanged: (value) {
                          Get.find<CreateRoomController>()
                              .setRoomPricePerDay(value);
                        },
                      ),

                      CurrencyInput(
                        labelText: "Precio por medio día",
                        onChanged: (value) {
                          Get.find<CreateRoomController>()
                              .setRoomPricePerMidday(value);
                        },
                      ),
                    ].map(
                      (e) => SizedBox(
                        width: constraints.maxWidth > 800
                            ? constraints.maxWidth / 2.1
                            : constraints.maxWidth,
                        child: e,
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Descripción",
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      onChanged: (value) => Get.find<CreateRoomController>()
                          .setRoomDescription(value),
                      maxLines: 8,
                      maxLength: 500,
                    ),
                    CapacitySelector(
                      onChanged: (value) {
                        Get.find<CreateRoomController>().setRoomCapacity(value);
                      },
                    ),
                  ]),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        );
      }),
    );
  }
}
