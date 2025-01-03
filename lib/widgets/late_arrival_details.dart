import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LateArrivalDetails extends StatelessWidget {
  final LateArrival lateArrival;
  final DateTime begin;
  final DateTime end;
  const LateArrivalDetails(
      {super.key,
      required this.lateArrival,
      required this.begin,
      required this.end});

  @override
  Widget build(BuildContext context) {
    Get.put(LateArrivalDetailsController(
        lateArrival: lateArrival, begin: begin, end: end));
    String? lateArrivalImage =
        Get.find<CurriculumController>().getLateArrivalImage(lateArrival);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Theme.of(context).colorScheme.primary,
            child: Row(
              children: [
                const CustomBackButton(),
                Container(
                  height: 30,
                  width: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                ),
                Text(
                  "Detalles de llegadas tarde",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMember(lateArrivalImage, context),
                        const SizedBox(height: 20),
                        Expanded(
                          child: _buildWorkPermits(context),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    width: 1,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.5),
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                  ),
                  Expanded(
                    child: LayoutBuilder(builder: (context, constrains) {
                      final height = constrains.maxHeight;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Listado de Llegadas tarde",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 10),
                          _buildMorningAfternoonFilter(context),
                          const SizedBox(height: 10),
                          Expanded(
                            child: _buildLateArrivalDetailList(height, context),
                          ),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildMember(String? lateArrivalImage, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachingImage(
          url: lateArrivalImage ?? "",
          width: 150,
          height: 150,
          borderRadius: 0,
          errorWidget: Container(
            color: Theme.of(context).colorScheme.primary,
            child: Icon(
              FontAwesomeIcons.user,
              size: 100,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                lateArrival.nombreCompleto,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              Text(
                "C.C ${dniFormat(lateArrival.noDocumento)}",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      overflow: TextOverflow.ellipsis,
                    ),
              ),
              Text(
                lateArrival.nombreCargo,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      overflow: TextOverflow.ellipsis,
                    ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkPermits(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Permisos de trabajo",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Obx(() {
            final loading = Get.find<LateArrivalDetailsController>().loading;
            final workPermits =
                Get.find<LateArrivalDetailsController>().workPermits;
            if (loading) {
              return const Center(
                child: LoadingIndicator(),
              );
            }
            if (workPermits.isEmpty) {
              return const Center(
                child: Text("No hay permisos de trabajo"),
              );
            }
            return ListView.builder(
              itemCount: workPermits.length,
              itemBuilder: (context, index) {
                final workPermit = workPermits[index];
                return ListTile(
                  title: Text(
                    "${workPermit.nombreTipo} - ${workPermit.remuneracion == "SI" ? 'Remunerado' : 'No remunerado'}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workPermit.otroMotivo,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              overflow: TextOverflow.ellipsis,
                            ),
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Fecha: ${formatDateToHumanDate(workPermit.fechaEntrada)} - ${formatDateToHumanDate(workPermit.fechaSalida)}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Hora: ${workPermit.horaSalidaFormateada} - ${workPermit.horaEntradaFormateada}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  SingleChildScrollView _buildLateArrivalDetailList(
      double height, BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() {
        final loading = Get.find<LateArrivalDetailsController>().loading;
        final lateArrivalDetails =
            Get.find<LateArrivalDetailsController>().lateArrivalDetailsFiltered;
        final isBoth = Get.find<LateArrivalDetailsController>().isBothFilter;
        final lateArrivalDetailsGrouped =
            Get.find<LateArrivalDetailsController>().lateArrivalDetailsGrouped;
        final currentLateArrivalDetail =
            Get.find<LateArrivalDetailsController>().selectedLateArrivalDetail;
        if (loading) {
          return SizedBox(
            width: double.infinity,
            height: height,
            child: const Center(
              child: LoadingIndicator(),
            ),
          );
        }
        if (isBoth) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              if (lateArrivalDetails.isEmpty)
                SizedBox(
                  width: double.infinity,
                  height: height,
                  child: const Center(
                    child: Text("No hay llegadas tarde"),
                  ),
                ),
              ...lateArrivalDetailsGrouped.entries.map((lateArrival) {
                final String joinDates = lateArrival.value.map(
                  (e) {
                    return e.hourFormatted;
                  },
                ).join(" - ");
                return ListTile(
                  onTap: () {
                    Get.find<LateArrivalDetailsController>()
                        .toggleSelectLateArrivalDetail(lateArrival.value.first);
                  },
                  leading: Icon(
                    currentLateArrivalDetail == lateArrival.value.first
                        ? FontAwesomeIcons.solidCircleCheck
                        : FontAwesomeIcons.circle,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    formatDateToSpanishDate(lateArrival.key),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(joinDates,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                    ],
                  ),
                );
              }),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            if (lateArrivalDetails.isEmpty)
              SizedBox(
                width: double.infinity,
                height: height,
                child: const Center(
                  child: Text("No hay llegadas tarde"),
                ),
              ),
            ...lateArrivalDetails.map((lateArrival) {
              return ListTile(
                onTap: () {
                  Get.find<LateArrivalDetailsController>()
                      .toggleSelectLateArrivalDetail(lateArrival);
                },
                leading: Icon(
                  currentLateArrivalDetail == lateArrival
                      ? FontAwesomeIcons.solidCircleCheck
                      : FontAwesomeIcons.circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: Text(
                  formatDateToSpanishDate(lateArrival.fecha),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lateArrival.hourFormatted,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _buildMorningAfternoonFilter(BuildContext context) {
    return Obx(() {
      final totalMorningLateArrivals =
          Get.find<LateArrivalDetailsController>().totalMorningLateArrivals;
      final totalAfternoonLateArrivals =
          Get.find<LateArrivalDetailsController>().totalAfternoonLateArrivals;
      final totalLateArrivals =
          Get.find<LateArrivalDetailsController>().totalLateArrivals;
      final isMorning =
          Get.find<LateArrivalDetailsController>().isMorningFilter;
      final isAfternoon =
          Get.find<LateArrivalDetailsController>().isAfternoonFilter;
      final isBoth = Get.find<LateArrivalDetailsController>().isBothFilter;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: isMorning
                    ? ElevatedButton(
                        onPressed: () {
                          Get.find<LateArrivalDetailsController>()
                              .setMorningFilter();
                        },
                        child:
                            Text("Jornada mañana ($totalMorningLateArrivals)"),
                      )
                    : OutlinedButton(
                        onPressed: () {
                          Get.find<LateArrivalDetailsController>()
                              .setMorningFilter();
                        },
                        child:
                            Text("Jornada mañana ($totalMorningLateArrivals)"),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: !isAfternoon
                    ? OutlinedButton(
                        onPressed: () {
                          Get.find<LateArrivalDetailsController>()
                              .setAfternoonFilter();
                        },
                        child:
                            Text("Jornada tarde ($totalAfternoonLateArrivals)"),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          Get.find<LateArrivalDetailsController>()
                              .setAfternoonFilter();
                        },
                        child:
                            Text("Jornada tarde ($totalAfternoonLateArrivals)"),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          isBoth
              ? ElevatedButton(
                  onPressed: () {
                    Get.find<LateArrivalDetailsController>().setBothFilter();
                  },
                  child: Text("Ambas jornadas ($totalLateArrivals)"),
                )
              : OutlinedButton(
                  onPressed: () {
                    Get.find<LateArrivalDetailsController>().setBothFilter();
                  },
                  child: Text("Ambas jornadas ($totalLateArrivals)"),
                )
        ],
      );
    });
  }
}
