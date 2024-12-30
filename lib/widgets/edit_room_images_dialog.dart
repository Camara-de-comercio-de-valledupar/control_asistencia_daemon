import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class EditRoomImagesDialog extends StatelessWidget {
  final Room room;
  const EditRoomImagesDialog({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    Get.put(
      EditImageRoomController(
        room: room,
      ),
    );
    return CustomDialog(
        width: MediaQuery.of(context).size.width * 0.6,
        title: "Actualizar fotos del salón \"${room.nombresalon}\"",
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
          Obx(() {
            return Get.find<EditImageRoomController>().loading
                ? LoadingIndicator(
                    label: null,
                    color: Theme.of(context).colorScheme.onSecondary,
                    size: 25,
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.check),
                      SizedBox(width: 10),
                      Text("Actualizar"),
                    ],
                  );
          }): () {
            Get.find<EditImageRoomController>().updateRoom();
          },
        },
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (room.imagenes.isNotEmpty) ...[
                  Text(
                    "Fotos actuales",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Text(
                    "Puedes clickear las fotos para agregar a las fotos nuevas",
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        ...room.imagenes.map(
                          (image) => MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Get.find<EditImageRoomController>()
                                    .addExistingImage(image.file);
                              },
                              child: CachingImage(
                                url: image.file,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                borderRadius: 0,
                                errorWidget: const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        _buildRemoveAllImages(context),
                      ]),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
                Text(
                  "Fotos nuevas",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  "Puedes clickear las fotos para eliminarlas",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Obx(() {
                  return Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        _buildAddNewImage(context),
                        ...Get.find<EditImageRoomController>()
                            .images
                            .map((image) => MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.find<EditImageRoomController>()
                                          .removeImage(image);
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        border: Border.all(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        image: DecorationImage(
                                          image: MemoryImage(image),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.xmark,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                      ),
                                    ),
                                  ),
                                )),
                      ]);
                }),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          );
        }));
  }

  Widget _buildRemoveAllImages(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Get.find<EditImageRoomController>().removeAllImages();
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: Icon(
            FontAwesomeIcons.trash,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewImage(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Get.find<EditImageRoomController>().pickImage();
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          child: Icon(
            FontAwesomeIcons.plus,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}
