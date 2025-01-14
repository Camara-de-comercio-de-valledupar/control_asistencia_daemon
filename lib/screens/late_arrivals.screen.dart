import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LateArrivalsScreen extends StatelessWidget {
  const LateArrivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      runOnMobile: false,
      title: "Llegadas tarde",
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Filtros de búsqueda",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            // Filtros de búsqueda
            _buildFilters(context),
            const SizedBox(height: 20),
            // Tabla de llegadas tarde
            _buildTable(context),
          ],
        ),
      ),
    );
  }

  Row _buildFilters(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomCard(
            enablePadding: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextFormField(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                cursorColor: Theme.of(context).colorScheme.onPrimary,
                decoration: InputDecoration(
                  hintText: "Buscar por nombre, apellido, cargo o cédula",
                  contentPadding: EdgeInsets.zero,
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  counterStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                onChanged: (p0) {
                  Get.find<LateArrivalsController>().setSearch(p0);
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        // Menu por fecha, por rango de fechas o por opciones rápidas
        FilterDatePopupButton(
          onChanged: (p0) {
            if (p0 != null) {
              Get.find<LateArrivalsController>().setDate(p0);
            }
          },
          onDateRangeChanged: (p0, p1) {
            if (p0 != null && p1 != null) {
              Get.find<LateArrivalsController>().setDateRange(DateTimeRange(
                start: p0,
                end: p1,
              ));
            }
          },
        ),
        const SizedBox(width: 20),
        CustomCardButton(
          onPressed: () {
            Get.find<LateArrivalsController>().refreshLateArrivals();
          },
          child: const Icon(Icons.refresh, size: 30, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context) {
    return SingleChildScrollView(
      child: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        bool isDesktop = width > 800;
        bool isTablet = width > 600;
        bool isMobile = width <= 600;
        return Obx(() {
          final lateArrivals = Get.find<LateArrivalsController>().lateArrivals;
          final isLoading = Get.find<LateArrivalsController>().loading;

          if (isLoading) {
            return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: const Center(child: LoadingIndicator()));
          }

          return Table(
            columnWidths: {
              0: FlexColumnWidth(
                isDesktop
                    ? 4
                    : isTablet
                        ? 3
                        : 2,
              ),
              1: FlexColumnWidth(
                isDesktop
                    ? 4
                    : isTablet
                        ? 2
                        : 1,
              ),
              2: const FlexColumnWidth(1),
              3: const FlexColumnWidth(1),
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: TableBorder.all(
              color: Theme.of(context).colorScheme.primary,
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                children: [
                  "Nombres",
                  if (!isMobile) "Cargo",
                  "Cantidad",
                  if (!isMobile) "Acciones",
                ]
                    .map((e) => TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            e,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                        )))
                    .toList(),
              ),
              ...lateArrivals.map((e) {
                final image =
                    Get.find<CurriculumController>().getLateArrivalImage(e);
                return TableRow(
                  children: [
                    Row(
                      children: [
                        CachingImage(
                          url: image ?? "",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorWidget: Icon(Icons.person,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.nombreCompleto,
                                style: Theme.of(context).textTheme.titleLarge),
                            Text("C.C ${dniFormat(e.noDocumento)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                          ],
                        ),
                      ],
                    ),
                    if (!isMobile)
                      Text(e.nombreCargo,
                          style: Theme.of(context).textTheme.titleLarge),
                    Text(e.cantidad.toString(),
                        style: Theme.of(context).textTheme.titleLarge),
                    if (!isMobile)
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.find<LateArrivalsController>()
                                  .showLateArrivalDetails(e);
                            },
                            child: const Text("Ver detalles"),
                          ),
                        ],
                      ),
                  ]
                      .map((e) => TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: e,
                          )))
                      .toList(),
                );
              }),
            ],
          );
        });
      }),
    );
  }
}

class FilterDatePopupButton extends StatefulWidget {
  final void Function(DateTime?) onChanged;
  final void Function(DateTime?, DateTime?) onDateRangeChanged;

  const FilterDatePopupButton({
    super.key,
    required this.onChanged,
    required this.onDateRangeChanged,
  });

  @override
  State<FilterDatePopupButton> createState() => _FilterDatePopupButtonState();
}

class _FilterDatePopupButtonState extends State<FilterDatePopupButton> {
  final List<Map<String, int>> _initialOptions = [
    {"Hoy": 0},
    {"Ayer": 1},
    {"Esta semana": 2},
    {"Este mes": 3},
    {"Mes pasado": 8},
    {"Año pasado": 9},
    {"Personalizado": 4},
  ];
  final List<Map<String, int>> _customOptions = [
    {"Rango de fechas": 5},
    {"Dia específico": 6},
    {"Opciones rápidas": 7},
  ];
  String? _label;
  final _popupButtonKey = GlobalKey<PopupMenuButtonState<int>>();
  bool _isCustom = false;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      key: _popupButtonKey,
      offset: const Offset(0, 80),
      color: Theme.of(context).colorScheme.primary,
      itemBuilder: (context) => (_isCustom ? _customOptions : _initialOptions)
          .map((e) => PopupMenuItem<int>(
                value: e.values.first,
                child: Text(
                  e.keys.first,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ))
          .toList(),
      child: CustomCard(
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 30,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(width: 10),
            Text(
              _label ?? "Filtrar por fecha",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
          ],
        ),
      ),
      onSelected: (value) {
        final now = DateTime.now();
        setState(() {
          _label = _initialOptions
              .firstWhere((element) => element.values.first == value,
                  orElse: () => {"Filtrar por fecha": -1})
              .keys
              .first;
        });
        switch (value) {
          case 0:
            widget.onChanged(DateTime(now.year, now.month, now.day));
            break;
          case 1:
            widget.onChanged(DateTime(now.year, now.month, now.day - 1));
            break;
          case 2:
            widget.onDateRangeChanged(
              DateTime(now.year, now.month, now.day - now.weekday),
              DateTime(now.year, now.month, now.day + (7 - now.weekday)),
            );
            break;
          case 3:
            widget.onDateRangeChanged(
              DateTime(now.year, now.month, 1),
              DateTime(now.year, now.month + 1, 0),
            );
            break;
          case 4:
            setState(() {
              _isCustom = true;
            });
            _popupButtonKey.currentState?.showButtonMenu();
            break;

          case 5:
            showDateRangePicker(
              context: context,
              firstDate: DateTime(2012),
              lastDate: DateTime.now().add(const Duration(days: 1)),
              builder: (context, child) {
                return Center(
                  child: SizedBox(
                    width: 600,
                    height: 600,
                    child: Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        colorScheme: ColorScheme.light(
                          surface: Theme.of(context).colorScheme.onPrimary,
                          onSurface: Theme.of(context).colorScheme.primary,
                          primary: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: child!,
                    ),
                  ),
                );
              },
            ).then((value) {
              if (value != null) {
                widget.onDateRangeChanged(value.start, value.end);
              }
            });
            setState(() {
              _isCustom = false;
            });
            break;
          case 6:
            showDatePicker(
              context: context,
              firstDate: DateTime(2012),
              lastDate: DateTime.now().add(const Duration(days: 1)),
              builder: (context, child) {
                return Center(
                  child: SizedBox(
                    width: 600,
                    height: 600,
                    child: Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        colorScheme: ColorScheme.light(
                          surface: Theme.of(context).colorScheme.onPrimary,
                          onSurface: Theme.of(context).colorScheme.primary,
                          primary: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      child: child!,
                    ),
                  ),
                );
              },
            ).then((value) {
              if (value != null) {
                widget.onChanged(value);
              }
            });
            setState(() {
              _isCustom = false;
            });
            break;
          case 7:
            setState(() {
              _isCustom = false;
            });
            // Open menu with quick options
            _popupButtonKey.currentState?.showButtonMenu();
            break;
          case 8:
            widget.onDateRangeChanged(
              DateTime(now.year, now.month - 1, 1),
              DateTime(now.year, now.month, 0),
            );
            break;
          case 9:
            widget.onDateRangeChanged(
              DateTime(now.year - 1, 1, 1),
              DateTime(now.year - 1, 12, 31),
            );
            break;
        }
      },
    );
  }
}
