import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // =================================================================

  final AuthenticationService authenticationService =
      AuthenticationService.getInstance();
  final CacheService cacheService = CacheService.getInstance();

  // =================================================================

  final Rx<Member?> _currentMember = Rx<Member?>(null);
  final RxBool _loading = RxBool(false);
  final RxList<Permission> _permissions = RxList<Permission>([]);
  final RxList<Permission> _filteredPermissions = RxList<Permission>([]);

  // =================================================================

  List<Permission> get permissions => _permissions.toList();

  List<Permission> get filteredPermissions => _filteredPermissions.toList();

  // =================================================================

  @override
  void onReady() {
    super.onReady();
    debounce(
      _currentMember,
      _listeCurrentMemberChanges,
      time: const Duration(seconds: 1),
    );
    ever(_loading, _goToLoading);
    ever(_currentMember, _getPermissions);
    _fetchCurrentMember();
  }

  // =================================================================

  void _getPermissions(Member? member) async {
    if (member != null) {
      var permissions = await authenticationService.getPermissions(member.id);
      permissions = permissions
          .where((element) =>
              element.deletedAt == null &&
              element.menus.isNotEmpty &&
              element.nombreCabecera.isNotEmpty)
          .toList();
      permissions.sort((a, b) => a.nombreCabecera.compareTo(b.nombreCabecera));
      _permissions.value = permissions;
      _filteredPermissions.value = permissions;
    }
  }

  // =================================================================

  void _goToLoading(bool loading) {
    if (loading) {
      Get.toNamed("/");
    }
  }

  // =================================================================

  void _listeCurrentMemberChanges(Member? member) async {
    if (kDebugMode) {
      print(
          "current member changed -> ${member == null ? "null" : member.email}");
    }
    _redirectTo(member);
  }

  // =================================================================

  void _redirectTo(Member? member) {
    if (kDebugMode) {
      print("redirecting to -> ${member == null ? "/login" : "/dashboard"}");
    }
    if (member == null) {
      Get.offAllNamed("/login");
    } else {
      Get.offAllNamed("/dashboard");
    }
  }

  // =================================================================

  void _fetchCurrentMember() {
    var memberJson = cacheService.getString("currentMember");
    if (memberJson != null) {
      _currentMember.value = memberFromJson(memberJson);
      return;
    }
    _currentMember.value = null;
    if (kDebugMode) {
      print("fetching current member -> ${_currentMember.value}");
    }
  }

  // =================================================================

  Member? get currentMember => _currentMember.value;

  // =================================================================

  void login(String email, String password) async {
    _loading.value = true;
    Member? member = await authenticationService
        .signInWithEmailAndPassword(email, password)
        .catchError((error) {
      _loading.value = false;
      Get.offAllNamed("/login");
      throw error;
    });
    await cacheService.setString("currentMember", memberToJson(member));
    _currentMember.value = member;

    _loading.value = false;
  }

  // =================================================================

  Future<void> logout() async {
    await cacheService.remove("currentMember");
    _currentMember.value = null;
  }

  // =================================================================

  void filterPermissions(String filter) {
    if (filter.isEmpty) {
      _filteredPermissions.value = permissions;
      return;
    } else {
      _filteredPermissions.value = permissions
          .where((element) => element.nombreCabecera
              .toLowerCase()
              .contains(filter.toLowerCase()))
          .toList();
    }
  }
}
