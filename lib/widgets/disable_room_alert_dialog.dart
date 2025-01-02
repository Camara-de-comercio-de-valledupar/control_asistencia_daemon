import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class DisableRoomAlertDialog extends StatelessWidget {
  final Room room;
  const DisableRoomAlertDialog({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: "Deshabilitar salón",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Theme.of(context).colorScheme.error,
            size: 50,
          ),
          const SizedBox(width: 10),
          Text(
            "¿Estás seguro de que deseas habilitar este salón?",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
            maxLines: 3,
          ),
        ],
      ),
      actions: {
        const Row(
          children: [
            Icon(FontAwesomeIcons.xmark),
            SizedBox(width: 10),
            Text("Cancelar"),
          ],
        ): () {
          Get.back();
        },
        const Row(
          children: [
            Icon(FontAwesomeIcons.trash),
            SizedBox(width: 10),
            Text("Deshabilitar"),
          ],
        ): () {
          Get.find<RoomController>().confirmDisableRoom(room);
        },
      },
    );
  }
}

class EnableRoomAlertDialog extends StatelessWidget {
  final Room room;
  const EnableRoomAlertDialog({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: "Habilitar salón",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.triangleExclamation,
            color: Theme.of(context).colorScheme.error,
            size: 50,
          ),
          const SizedBox(width: 10),
          Text(
            "¿Estás seguro de que deseas habilitar este salón?",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
            maxLines: 3,
          ),
        ],
      ),
      actions: {
        const Row(
          children: [
            Icon(FontAwesomeIcons.xmark),
            SizedBox(width: 10),
            Text("Cancelar"),
          ],
        ): () {
          Get.back();
        },
        const Row(
          children: [
            Icon(FontAwesomeIcons.toggleOn),
            SizedBox(width: 10),
            Text("Habilitar"),
          ],
        ): () {
          Get.find<RoomController>().confirmEnableRoom(room);
        },
      },
    );
  }
}
