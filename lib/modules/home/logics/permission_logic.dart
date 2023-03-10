import 'package:permission_handler/permission_handler.dart'
    show Permission, PermissionActions, PermissionStatusGetters;

/// This logic checks the record permission.
abstract class PermissionLogicInterface {
  Future<bool> get hasRecordPermission;
}

class PermissionLogic implements PermissionLogicInterface {
  const PermissionLogic();

  @override
  Future<bool> get hasRecordPermission async {
    final permissionStatus = await Permission.microphone.request();
    return permissionStatus.isGranted;
  }
}
