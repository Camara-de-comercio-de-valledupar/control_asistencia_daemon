import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WarehouseReportScreen extends StatelessWidget {
  const WarehouseReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: "Reporte de Almacén",
      child: Obx(() {
        final loading = Get.find<WarehouseReportController>().loading;
        return Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomScrollView(slivers: [
                SliverToBoxAdapter(
                  child: Text(
                    "Filtros de búsqueda",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(child: _buildFilters(context)),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Text(
                    "Métricas de almacén",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(child: _buildCharts(context)),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Text(
                    "Reporte de almacén",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(child: _buildTable(context)),
              ]),
            ),
            if (loading)
              ColoredBox(
                  color: Colors.black.withValues(
                    alpha: 0.2,
                  ),
                  child: const Center(child: LoadingIndicator())),
          ],
        );
      }),
    );
  }

  Widget _buildCharts(BuildContext context) {
    return Obx(() {
      Set<RequestByDate> requestsByDate =
          Get.find<WarehouseReportController>().requestsByDate;
      Set<RequestByArea> requestsByArea =
          Get.find<WarehouseReportController>().requestsByArea;
      Set<ProductCount> productsCount =
          Get.find<WarehouseReportController>().productsCount;
      double productsCountMax =
          Get.find<WarehouseReportController>().productsCountMax.toDouble();
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(children: [
            Expanded(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  "Distribución por areas",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                ),
                SfCircularChart(
                  series: [
                    PieSeries<RequestByArea, String>(
                      dataSource: requestsByArea.toList(),
                      xValueMapper: (RequestByArea request, _) => request.area,
                      yValueMapper: (RequestByArea request, _) => request.count,
                      // Ver porcentajes
                      dataLabelMapper: (datum, index) => "${datum.percentage}%",
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                        textStyle: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                  // Leyenda
                  legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.right,
                  ),
                )
              ]),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Solicitudes por fecha",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black,
                        ),
                  ),
                  SfCartesianChart(
                    primaryXAxis: const DateTimeCategoryAxis(),
                    series: [
                      LineSeries<RequestByDate, DateTime>(
                        dataSource: requestsByDate.toList(),
                        xValueMapper: (RequestByDate request, _) =>
                            request.date,
                        yValueMapper: (RequestByDate request, _) =>
                            request.count,
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          textStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
          const SizedBox(height: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Top 10 productos mas solicitados",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                    ),
              ),
              SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: productsCountMax,
                ),
                series: [
                  BarSeries<ProductCount, String>(
                    dataSource: productsCount.toList(),
                    xValueMapper: (ProductCount product, _) => product.product,
                    yValueMapper: (ProductCount product, _) => product.count,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  )
                ],
              )
            ],
          )
        ],
      );
    });
  }

  Widget _buildTable(BuildContext context) {
    return Obx(() {
      var rows = Get.find<WarehouseReportController>().rows;
      var columns = Get.find<WarehouseReportController>().columns;
      return DataTable(
        columns: columns.map((e) {
          return DataColumn(
            label: Text(
              e,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                  ),
            ),
          );
        }).toList(),
        rows: rows.map((e) {
          return DataRow(
            cells: e.map((e) {
              return DataCell(
                Text(
                  e,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                      ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      );
    });
  }

  Widget _buildFilters(BuildContext context) {
    return Obx(() {
      final products = Get.find<WarehouseReportController>().products.toList();
      final areas = Get.find<WarehouseReportController>().areas.toList();
      final employees =
          Get.find<WarehouseReportController>().employees.toList();

      final years = Get.find<WarehouseReportController>().years.toList();
      final months = Get.find<WarehouseReportController>().months.toList();
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: CustomDropdownSearch<int>(
              value: Get.find<WarehouseReportController>().selectedYear,
              label: 'Seleccione un año',
              items: years,
              onChanged: Get.find<WarehouseReportController>().onSelectYear,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CustomDropdownSearch(
              value: Get.find<WarehouseReportController>().selectedMonth,
              label: 'Seleccione un mes',
              items: months,
              onChanged: Get.find<WarehouseReportController>().onSelectMonth,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CustomDropdownSearch(
              value: Get.find<WarehouseReportController>().selectedProduct,
              label: 'Seleccione un producto',
              items: products,
              onChanged: Get.find<WarehouseReportController>().onSelectProduct,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CustomDropdownSearch(
              value: Get.find<WarehouseReportController>().selectedArea,
              label: 'Seleccione un area',
              items: areas,
              onChanged: Get.find<WarehouseReportController>().onSelectArea,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CustomDropdownSearch(
              value: Get.find<WarehouseReportController>().selectedEmployee,
              label: 'Seleccione un empleado',
              items: employees,
              onChanged: Get.find<WarehouseReportController>().onSelectEmployee,
            ),
          ),
          const SizedBox(width: 10),
          CustomCard(
            enablePadding: false,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: Get.find<WarehouseReportController>().onClearFilters,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(FontAwesomeIcons.trash,
                          color: Theme.of(context).colorScheme.onPrimary),
                      const SizedBox(width: 10),
                      const Text("Limpiar filtros"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
