import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum VisualizeMode { morning, afternoon, both }

class LateArrivalDetailsController extends GetxController {
  final LateArrival _lateArrival;
  final DateTime _begin;
  final DateTime _end;

  LateArrivalDetailsController(
      {required LateArrival lateArrival,
      required DateTime begin,
      required DateTime end})
      : _lateArrival = lateArrival,
        _begin = begin,
        _end = end;

  final LateArrivalsService _lateArrivalDetailsService =
      LateArrivalsService.getInstance();
  final WorkPermitService _workPermitService = WorkPermitService.getInstance();

  final RxList<LateArrivalDetailItem> _lateArrivalDetails =
      <LateArrivalDetailItem>[].obs;
  final Rx<String?> _search = "".obs;
  final RxBool _isRangeFilter = false.obs;
  final Rx<DateTimeRange?> _dateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  ).obs;
  final RxBool _loading = false.obs;
  final Rx<VisualizeMode> _visualizeMode = VisualizeMode.both.obs;
  final RxList<WorkPermit> _workPermits = <WorkPermit>[].obs;
  final RxList<WorkPermit> _workPermitsFiltered = <WorkPermit>[].obs;
  final Rx<LateArrivalDetailItem?> _selectedLateArrivalDetail =
      Rxn<LateArrivalDetailItem>();

  // =======================================================

  String? get search => _search.value;
  bool get isRangeFilter => _isRangeFilter.value;
  DateTimeRange? get dateRange => _dateRange.value;
  List<LateArrivalDetailItem> get lateArrivalDetails => _lateArrivalDetails;
  bool get loading => _loading.value;
  int get totalMorningLateArrivals => lateArrivalDetails
      .where((element) => element.nombre.contains("Mañana"))
      .length;
  int get totalAfternoonLateArrivals => lateArrivalDetails
      .where((element) => element.nombre.contains("Tarde"))
      .length;
  int get totalLateArrivals => lateArrivalDetails.length;
  VisualizeMode get visualizeMode => _visualizeMode.value;
  bool get isMorningFilter => _visualizeMode.value == VisualizeMode.morning;
  bool get isAfternoonFilter => _visualizeMode.value == VisualizeMode.afternoon;
  bool get isBothFilter => _visualizeMode.value == VisualizeMode.both;
  LateArrivalDetailItem? get selectedLateArrivalDetail =>
      _selectedLateArrivalDetail.value;

  List<LateArrivalDetailItem> get lateArrivalDetailsFiltered {
    final isMorningFilter = visualizeMode == VisualizeMode.morning;

    return lateArrivalDetails
        .where((element) =>
            element.nombre.toLowerCase().contains(search!.toLowerCase()))
        .where((element) => isMorningFilter
            ? element.nombre.contains("Mañana")
            : !element.nombre.contains("Mañana"))
        .toList();
  }

  List<WorkPermit> get workPermits => _workPermitsFiltered;

  Map<DateTime, List<LateArrivalDetailItem>> get lateArrivalDetailsGrouped {
    final lateArrivalDetailsFiltered = lateArrivalDetails;
    final Map<DateTime, List<LateArrivalDetailItem>> grouped = {};

    for (final lateArrivalDetail in lateArrivalDetailsFiltered) {
      final date = lateArrivalDetail.fecha;
      if (grouped.containsKey(date)) {
        grouped[date]!.add(lateArrivalDetail);
      } else {
        grouped[date] = [lateArrivalDetail];
      }
    }

    return grouped;
  }

  // =======================================================

  void setSearch(String value) {
    _search.value = value;
  }

  void setIsRangeFilter(bool value) {
    _isRangeFilter.value = value;
  }

  void setDateRange(DateTimeRange value) {
    _dateRange.value = value;
  }

  void setMorningFilter() {
    _visualizeMode.value = VisualizeMode.morning;
  }

  void setAfternoonFilter() {
    _visualizeMode.value = VisualizeMode.afternoon;
  }

  void setBothFilter() {
    _visualizeMode.value = VisualizeMode.both;
  }

  void clearFilters() {
    _search.value = "";
    _isRangeFilter.value = false;
    _dateRange.value =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());
  }

  // =======================================================

  @override
  void onReady() {
    super.onReady();
    ever(_selectedLateArrivalDetail, _filterWorkPermits);
    ever(_workPermits, _workPermitsFiltered.assignAll);
    _getLateArrivalDetails();
    _getWorkPermits();
  }

  // =======================================================

  Future<void> _getLateArrivalDetails() async {
    _loading.value = true;
    try {
      final lateArrivalDetails =
          await _lateArrivalDetailsService.getLateArrivalsByEmployee(
        employeeId: _lateArrival.id,
        begin: _begin,
        end: _end,
      );
      _lateArrivalDetails.value = lateArrivalDetails;
    } finally {
      _loading.value = false;
      _loading.refresh();
    }
  }

  // =======================================================

  void _filterWorkPermits(LateArrivalDetailItem? lateArrivalDetail) {
    if (lateArrivalDetail == null) {
      _workPermitsFiltered.value = _workPermits;
      return;
    }

    final workPermits = _workPermits.where((element) {
      return isWithinDateRange(
        _selectedLateArrivalDetail.value!.fecha,
        element.fechaEntrada,
        element.fechaSalida,
      );
    }).toList();

    _workPermitsFiltered.value = workPermits;
  }

  // =======================================================

  Future<void> _getWorkPermits() async {
    try {
      final workPermits = await _workPermitService.getWorkPermits(
        _lateArrival.id,
        startDate: _begin,
        endDate: _end,
      );
      _workPermits.value = workPermits;
    } finally {
      _loading.value = false;
      _loading.refresh();
    }
  }

  // =======================================================

  void toggleSelectLateArrivalDetail(LateArrivalDetailItem lateArrivalDetail) {
    if (_selectedLateArrivalDetail.value == lateArrivalDetail) {
      _selectedLateArrivalDetail.value = null;
    } else {
      _selectedLateArrivalDetail.value = lateArrivalDetail;
    }
  }
}
