import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ProductCount {
  final String product;
  final int count;

  ProductCount({required this.product, required this.count});
}

class RequestByDate {
  final DateTime date;
  final int count;

  RequestByDate({required this.date, required this.count});
}

class RequestByArea {
  final String area;
  final int count;
  final String percentage;

  RequestByArea(
      {required this.area, required this.count, required this.percentage});
}

enum MonthValue {
  all,
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december,
}

Map<MonthValue, String> monthNames = {
  MonthValue.january: "Enero",
  MonthValue.february: "Febrero",
  MonthValue.march: "Marzo",
  MonthValue.april: "Abril",
  MonthValue.may: "Mayo",
  MonthValue.june: "Junio",
  MonthValue.july: "Julio",
  MonthValue.august: "Agosto",
  MonthValue.september: "Septiembre",
  MonthValue.october: "Octubre",
  MonthValue.november: "Noviembre",
  MonthValue.december: "Diciembre",
  MonthValue.all: "Todos",
};

class WarehouseReportController extends GetxController {
  final RxList<WarehouseReport> _warehouseReports = <WarehouseReport>[].obs;
  final RxList<WarehouseReport> _filteredWarehouseReports =
      <WarehouseReport>[].obs;

  // ===========================================================================

  final Rx<MonthValue> _selectedMonth = MonthValue.january.obs;
  final RxInt _selectedYear = DateTime.now().year.obs;
  final RxBool _loading = false.obs;
  final RxString _selectedProduct = RxString("Todos");
  final RxString _selectedArea = RxString("Todos");
  final RxString _selectedEmployee = RxString("Todos");

  // ===========================================================================

  String? get selectedProduct => _selectedProduct.value;
  String? get selectedArea => _selectedArea.value;
  String? get selectedEmployee => _selectedEmployee.value;
  List<WarehouseReport> get warehouseReports => _warehouseReports.toList();
  List<WarehouseReport> get filteredWarehouseReports =>
      _filteredWarehouseReports.toList();

  int get selectedYear => _selectedYear.value;
  String get selectedMonth => monthNames[_selectedMonth.value]!;
  bool get loading => _loading.value;

  Set<ProductCount> get productsCount {
    final productsWithAmount = <String, int>{};
    for (final warehouseReport in filteredWarehouseReports) {
      final product = warehouseReport.producto;
      final amount = warehouseReport.cantidad;
      productsWithAmount[product] = productsWithAmount[product] ?? 0 + amount;
    }

    final productsCount = productsWithAmount.entries.map((e) {
      return ProductCount(product: e.key, count: e.value);
    }).toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    return productsCount.take(10).toSet();
  }

  int get productsCountMax {
    final pc = productsCount.toList();
    if (pc.isEmpty) {
      return 10;
    }
    return (pc.reduce((a, b) => a.count > b.count ? a : b).count) + 10;
  }

  Set<RequestByArea> get requestsByArea {
    final areasWithCount = <String, int>{};
    for (final warehouseReport in filteredWarehouseReports) {
      final area = warehouseReport.area;
      areasWithCount[area] = (areasWithCount[area] ?? 0) + 1;
    }

    final areasCount = areasWithCount.entries.map((e) {
      return RequestByArea(
        area: e.key,
        count: e.value,
        percentage: ((e.value / filteredWarehouseReports.length) * 100)
            .toStringAsFixed(2),
      );
    }).toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    return areasCount.take(10).toSet();
  }

  Set<RequestByDate> get requestsByDate {
    final daysWithCount = <DateTime, int>{};
    for (final warehouseReport in filteredWarehouseReports) {
      final day = warehouseReport.fechaSolicitud;
      daysWithCount[day] = (daysWithCount[day] ?? 0) + 1;
    }
    final daysCount = daysWithCount.entries.map((e) {
      return RequestByDate(date: e.key, count: e.value);
    });
    return daysCount.toSet();
  }

  Set<int> get years {
    final limit = DateTime.now().year - 2016;
    return List.generate(limit, (i) => i + 2017).toSet();
  }

  Set<String> get months {
    return monthNames.entries.map((e) => e.value).toSet();
  }

  Set<String> get areas {
    final areas = <String>{"Todos"};
    for (final warehouseReport in warehouseReports) {
      final area = warehouseReport.area;
      areas.add(area);
    }

    return areas;
  }

  Set<String> get products {
    final products = <String>{"Todos"};
    for (final warehouseReport in warehouseReports) {
      final product = warehouseReport.producto;
      products.add(product);
    }

    return products;
  }

  Set<String> get employees {
    final employees = <String>{"Todos"};
    for (final warehouseReport in warehouseReports) {
      final employee = warehouseReport.funcionario;
      employees.add(employee);
    }

    return employees;
  }

  List<String> get columns => [
        'Producto',
        'Cantidad',
        'Area',
        'Funcionario',
        'Fecha',
      ];

  List<List<String>> get rows {
    final rows = <List<String>>[];

    for (final warehouseReport in filteredWarehouseReports) {
      rows.add([
        warehouseReport.producto,
        warehouseReport.cantidad.toString(),
        warehouseReport.area,
        warehouseReport.funcionario,
        formatDateToSpanishDate(warehouseReport.fechaSolicitud),
      ]);
    }

    return rows;
  }

  // ===========================================================================

  void onSelectEmployee(String? value) {
    _selectedEmployee.value = value ?? "Todos";
  }

  void onSelectArea(String? value) {
    _selectedArea.value = value ?? "Todos";
  }

  void onSelectProduct(String? value) {
    _selectedProduct.value = value ?? "Todos";
  }

  void onSelectYear(int? year) {
    _selectedYear.value = year ?? DateTime.now().year;
  }

  void onSelectMonth(String? month) {
    _selectedMonth.value = monthNames.entries
        .firstWhere(
          (e) => e.value == month,
          orElse: () => const MapEntry(MonthValue.all, "Todos"),
        )
        .key;
  }

  // ===========================================================================

  final WarehouseReportService _warehouseReportService =
      WarehouseReportService.getInstance();
  final CacheService _cacheService = CacheService.getInstance();

  // ==========================================================================

  @override
  void onReady() {
    super.onReady();
    everAll([
      _warehouseReports,
      _selectedProduct,
      _selectedArea,
      _selectedEmployee,
      _selectedMonth,
    ], _filterWarehouseReports);
    ever(_selectedYear, _fetchWarehouseReportsByYear);
    ever(_warehouseReports, _saveWarehouseReportsOnCache,
        condition: (_) => !_loading.value);
    _fetchWarehouseReportsOnCache(
      selectedYear: _selectedYear.value,
    );
  }

  // ==========================================================================

  void _fetchWarehouseReportsByYear(int? year) {
    if (year != null) {
      _fetchWarehouseReportsOnCache(selectedYear: year);
    }
  }

  // ===========================================================================

  void _filterWarehouseReports(values) {
    final product = _selectedProduct.value;
    final area = _selectedArea.value;
    final employee = _selectedEmployee.value;
    final month = _selectedMonth.value.index;
    if (kDebugMode) {
      print(
        "product: $product - area: $area - employee: $employee - month: $month",
      );
    }

    // Si alguno de los filtros es "Todos" entonces mostrar todos los registros
    _filteredWarehouseReports.assignAll(_warehouseReports
        .where((e) =>
            ((product == "Todos" || product == e.producto)) &&
            ((area == "Todos" || area == e.area)) &&
            ((employee == "Todos" || employee == e.funcionario)) &&
            ((month == MonthValue.all.index || month == e.mes)))
        .toList());
  }

  // ==========================================================================

  void _saveWarehouseReportsOnCache(List<WarehouseReport> warehouseReports) {
    final warehouseReportsString = warehouseReportToJson(warehouseReports);
    _cacheService.setString(
        "warehouse_reports_$selectedYear", warehouseReportsString);
  }

  // ==========================================================================

  void _fetchWarehouseReportsOnCache({
    required int selectedYear,
  }) async {
    _loading.value = true;
    final warehouseReportsString =
        _cacheService.getString("warehouse_reports_$selectedYear");
    if (warehouseReportsString != null) {
      final warehouseReports = warehouseReportFromJson(warehouseReportsString);
      _warehouseReports.assignAll(warehouseReports);
      _loading.value = false;
    }
    _fetchWarehouseReports(selectedYear: selectedYear)
        .catchError((error, stackTrace) {
      _loading.value = false;
    });
    _loading.value = false;
  }

  // ==========================================================================

  Future<void> _fetchWarehouseReports({
    required int selectedYear,
  }) async {
    final warehouseReports =
        await _warehouseReportService.getWarehouseReports(year: selectedYear);
    _warehouseReports.assignAll(warehouseReports);
  }

  // ==========================================================================

  void onClearFilters() {
    _selectedProduct.value = "Todos";
    _selectedArea.value = "Todos";
    _selectedEmployee.value = "Todos";
    _selectedYear.value = DateTime.now().year;
    _selectedMonth.value = MonthValue.all;
  }

  // ==========================================================================

  void onExportToExcel() {
    // TODO: Implementar lógica de exportar a excel
  }
}
