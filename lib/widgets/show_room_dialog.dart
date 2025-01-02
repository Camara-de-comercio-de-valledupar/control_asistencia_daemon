import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ShowRoomDialog extends StatefulWidget {
  final Room room;
  const ShowRoomDialog({super.key, required this.room});

  @override
  State<ShowRoomDialog> createState() => _ShowRoomDialogState();
}

class _ShowRoomDialogState extends State<ShowRoomDialog> {
  late Room _room;

  @override
  void initState() {
    super.initState();
    _room = widget.room;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      width: MediaQuery.of(context).size.width * 0.4,
      title: "Información del salón",
      actions: {
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.solidImage),
            SizedBox(width: 10),
            Text("Editar imágenes"),
          ],
        ): () async {
          Get.find<RoomController>().openEditRoomImagesDialog(_room);
        },
        if (_room.estado == "Habilitado") ...{
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.pencil),
              SizedBox(width: 10),
              Text("Editar"),
            ],
          ): () async {
            final result = await Get.find<RoomController>().disableRoom(_room);
            if (result != null) {
              setState(() {
                _room = result;
              });
            }
          },
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.toggleOff),
              SizedBox(width: 10),
              Text("Deshabilitar"),
            ],
          ): () async {
            final result = await Get.find<RoomController>().disableRoom(_room);
            if (result != null) {
              setState(() {
                _room = result;
              });
            }
          }
        },
        if (_room.estado == "Deshabilitado") ...{
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.toggleOn),
              SizedBox(width: 10),
              Text("Habilitar"),
            ],
          ): () async {
            final result = await Get.find<RoomController>().enableRoom(_room);
            if (result != null) {
              setState(() {
                _room = result;
              });
            }
          }
        },
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(FontAwesomeIcons.xmark),
            SizedBox(width: 10),
            Text("Cerrar"),
          ],
        ): () {
          Get.back(
            result: _room,
          );
        },
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 350,
              height: 400,
              child: RoomCard(room: _room),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Descripción",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _room.descripcion,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Ubicación",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _room.ubicacion,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
