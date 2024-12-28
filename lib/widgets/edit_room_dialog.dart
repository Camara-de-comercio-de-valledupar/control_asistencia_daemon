import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class EditRoomDialog extends StatelessWidget {
  final Room room;
  const EditRoomDialog({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    Get.put(
      CreateRoomController(
        initialRoomName: room.nombresalon,
        initialRoomLocation: room.ubicacion,
        initialRoomPricePerDay: room.valordia,
        initialRoomPricePerMidday: room.valormediodia,
        initialRoomDescription: room.descripcion,
        initialRoomCapacity: room.capacidad,
      ),
    );
    return CustomDialog(
        width: MediaQuery.of(context).size.width * 0.6,
        title: "Editar salón \"${room.nombresalon}\"",
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
              Text("Actualizar"),
            ],
          ): () {
            Get.find<CreateRoomController>().updateRoom(room);
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
                          initialValue:
                              Get.find<CreateRoomController>().roomName,
                          decoration: const InputDecoration(
                            labelText: "Nombre del salón",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          onChanged: (value) => Get.find<CreateRoomController>()
                              .setRoomName(value),
                          inputFormatters: [
                            UppercaseTextFormatter(),
                          ],
                        ),
                        TextFormField(
                          initialValue:
                              Get.find<CreateRoomController>().roomLocation,
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
                          initialValue:
                              Get.find<CreateRoomController>().roomPricePerDay,
                          labelText: "Precio por día",
                          onChanged: (value) {
                            Get.find<CreateRoomController>()
                                .setRoomPricePerDay(value);
                          },
                        ),

                        CurrencyInput(
                          initialValue: Get.find<CreateRoomController>()
                              .roomPricePerMidday,
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
                        initialValue:
                            Get.find<CreateRoomController>().roomDescription,
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
                        initialValue:
                            Get.find<CreateRoomController>().roomCapacity,
                        onChanged: (value) {
                          Get.find<CreateRoomController>()
                              .setRoomCapacity(value);
                        },
                      ),
                    ]),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          );
        }));
  }
}
