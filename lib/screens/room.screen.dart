import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      runOnMobile: false,
      title: 'Gestión de salones',
      child: Obx(() {
        final List<Room> rooms = Get.find<RoomController>().filteredRooms;
        final isLoading = Get.find<RoomController>().loading;
        final isDesktop = MediaQuery.of(context).size.width > 1200;
        final isTablet = MediaQuery.of(context).size.width > 700;

        int gridColumnCount = isDesktop
            ? 4
            : isTablet
                ? 2
                : 1;
        if (isLoading) {
          return const Center(child: LoadingIndicator());
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Buscar salón",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
                      ),
                      onChanged: (query) {
                        Get.find<RoomController>().filterRooms(query);
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (isDesktop || isTablet)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Get.find<RoomController>().openCreateNewRoomDialog();
                      },
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.plus),
                          SizedBox(width: 10),
                          Text("Nuevo salón"),
                        ],
                      ),
                    ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      Get.find<RoomController>().refreshRooms();
                    },
                    child: const Icon(FontAwesomeIcons.arrowRotateLeft),
                  ),
                ],
              ),
            ),
            Expanded(
              child: rooms.isEmpty
                  ? const Center(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(FontAwesomeIcons.boxOpen,
                            size: 100, color: Colors.grey),
                        Text("No hay salones registrados",
                            style: TextStyle(fontSize: 20, color: Colors.grey)),
                      ],
                    ))
                  : GridView.builder(
                      padding: const EdgeInsets.all(20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gridColumnCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.find<RoomController>().openShowRoomDialog(
                              rooms[index],
                            );
                          },
                          child: RoomCard(
                            room: rooms[index],
                          ),
                        );
                      },
                      itemCount: rooms.length,
                    ),
            ),
          ],
        );
      }),
    );
  }
}
