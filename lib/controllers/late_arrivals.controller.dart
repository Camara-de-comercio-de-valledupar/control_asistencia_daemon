import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LateArrivalsController extends GetxController {
  // =======================================================

  final LateArrivalsService _lateArrivalsService =
      LateArrivalsService.getInstance();

  // =======================================================

  final RxList<LateArrival> _lateArrivals = <LateArrival>[].obs;
  final RxList<LateArrival> _filteredLateArrivals = <LateArrival>[].obs;

  // =======================================================

  final Rx<String?> _search = "".obs;
  final Rx<DateTime?> _date = DateTime.now().obs;
  final Rx<DateTimeRange?> _dateRange = Rx<DateTimeRange?>(null);
  final RxBool _loading = false.obs;

  // =======================================================

  String? get search => _search.value;
  DateTime? get date => _date.value;
  DateTimeRange? get dateRange => _dateRange.value;
  List<LateArrival> get lateArrivals => _filteredLateArrivals;
  bool get loading => _loading.value;

  // =======================================================

  void setSearch(String value) {
    _search.value = value;
  }

  void setDate(DateTime value) {
    _date.value = value;
    _dateRange.value = null;
  }

  void setDateRange(DateTimeRange value) {
    _dateRange.value = value;
    _date.value = null;
  }

  // =======================================================

  void clearFilters() {
    _search.value = "";
    _date.value = DateTime.now();
    _dateRange.value =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
  }

  // =======================================================

  @override
  void onReady() {
    ever(_date, _fetchLateArrivalsByDate);
    ever(_dateRange, _fetchLateArrivalsByDateRange);
    ever(_search, _fetchLateArrivalsBySearch);
    ever(_lateArrivals, _filteredLateArrivals.assignAll);
    _fetchLateArrivalsToday();
    super.onReady();
  }

  // =======================================================

  void _fetchLateArrivalsToday() async {
    _fetchLateArrivalsByDate(DateTime.now());
  }

  // =======================================================

  void _fetchLateArrivalsByDate(DateTime? date) async {
    if (date == null) return;
    try {
      _loading.value = true;
      final lateArrivals = await _lateArrivalsService.getLateArrivals(
        begin: date,
        end: date,
      );
      _lateArrivals.assignAll(lateArrivals);
    } finally {
      _loading.value = false;
    }
  }

  // =======================================================

  void _fetchLateArrivalsByDateRange(DateTimeRange? dateRange) async {
    if (dateRange == null) return;
    try {
      _loading.value = true;
      final lateArrivals = await _lateArrivalsService.getLateArrivals(
        begin: dateRange.start,
        end: dateRange.end,
      );
      _lateArrivals.assignAll(lateArrivals);
    } finally {
      _loading.value = false;
    }
  }

  // =======================================================

  void _fetchLateArrivalsBySearch(String? search) async {
    if (search == null) return;
    if (search.isEmpty) {
      _filteredLateArrivals.assignAll(_lateArrivals);
      return;
    }
    _filteredLateArrivals.assignAll(
      _lateArrivals
          .where(
            (lateArrival) =>
                lateArrival.nombreCompleto
                    .toLowerCase()
                    .contains(search.toLowerCase()) ||
                lateArrival.noDocumento.contains(search.toLowerCase()) ||
                lateArrival.nombreCargo.contains(search.toLowerCase()),
          )
          .toList(),
    );
  }

  // =======================================================

  void refreshLateArrivals() {
    _fetchLateArrivalsToday();
  }

  // =======================================================

  void showLateArrivalDetails(LateArrival lateArrival) async {
    if (kDebugMode) {
      print("Filtros de búsqueda: ${_date.value} - ${_dateRange.value}");
    }
    final now = DateTime.now();
    final begin = _dateRange.value?.start ??
        _date.value ??
        now.subtract(const Duration(days: 1));
    final end = _dateRange.value?.end ?? _date.value ?? now;
    if (kDebugMode) {
      print("Filtros iniciales Begin: $begin - End: $end");
    }
    await showModalBottomSheet(
        context: Get.context!,
        constraints: BoxConstraints(
          minHeight: Get.height * 0.5,
        ),
        backgroundColor: Colors.transparent,
        builder: (context) {
          return LateArrivalDetails(
              lateArrival: lateArrival, begin: begin, end: end);
        });
    Get.delete<LateArrivalDetailsController>();
  }
}
