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
    ever(
      _currentMember,
      _listeCurrentMemberChanges,
    );
    ever(_permissions, _savePermissionsOnCache,
        condition: (_) => !_loading.value);
    ever(_loading, _goToLoading);
    ever(_currentMember, _fetchPermissionsOnCache);
    _fetchCurrentMember();
  }

  // =================================================================

  void _savePermissionsOnCache(List<Permission> permissions) async {
    final permissionsString = permissionToJson(permissions);
    await cacheService.setString("cached_permissions", permissionsString);
  }

  // =================================================================

  void _fetchPermissionsOnCache(Member? member) async {
    final permissionsString = cacheService.getString("cached_permissions");
    if (permissionsString != null) {
      final permissions = permissionFromJsonString(permissionsString);
      _permissions.assignAll(permissions);
      _filteredPermissions.assignAll(permissions);
    } else {
      _getPermissions(member);
    }
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
    if (member != null) {
      Get.put<AssistanceController>(AssistanceController(member: member));
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
      if (Get.currentRoute == "/") {
        Get.offAllNamed("/dashboard");
      }
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
