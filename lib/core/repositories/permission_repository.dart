import 'package:permission_handler/permission_handler.dart'
    show Permission, PermissionActions, PermissionStatusGetters;

/// This repository checks the record permission.
abstract class PermissionRepositoryInterface {
  Future<bool> get hasRecordPermission;
}

class PermissionRepository implements PermissionRepositoryInterface {
  const PermissionRepository();

  @override
  Future<bool> get hasRecordPermission async {
    final permissionStatus = await Permission.microphone.request();
    return permissionStatus.isGranted;
  }
}
