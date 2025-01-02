import 'package:control_asistencia_daemon/lib.dart';
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
  final RxBool _isRangeFilter = false.obs;
  final Rx<DateTime?> _date = DateTime.now().obs;
  final Rx<DateTimeRange?> _dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now()).obs;
  final RxBool _loading = false.obs;

  // =======================================================

  String? get search => _search.value;
  bool get isRangeFilter => _isRangeFilter.value;
  DateTime? get date => _date.value;
  DateTimeRange? get dateRange => _dateRange.value;
  List<LateArrival> get lateArrivals => _filteredLateArrivals;
  bool get loading => _loading.value;

  // =======================================================

  void setSearch(String value) {
    _search.value = value;
  }

  void setIsRangeFilter(bool value) {
    _isRangeFilter.value = value;
  }

  void setDate(DateTime value) {
    _date.value = value;
  }

  void setDateRange(DateTimeRange value) {
    _dateRange.value = value;
  }

  // =======================================================

  void clearFilters() {
    _search.value = "";
    _isRangeFilter.value = false;
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
                lateArrival.nombres
                    .toLowerCase()
                    .contains(search.toLowerCase()) ||
                lateArrival.apellidos.contains(search.toLowerCase()) ||
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
}
