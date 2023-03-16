import 'package:permission_handler/permission_handler.dart'
    show Permission, PermissionActions, PermissionStatusGetters;

/// This repository checks the microphone permission.
abstract class PermissionRepositoryInterface {
  Future<bool> get hasMicrophonePermission;
}

class PermissionRepository implements PermissionRepositoryInterface {
  const PermissionRepository();

  @override
  Future<bool> get hasMicrophonePermission async {
    final permissionStatus = await Permission.microphone.request();
    return permissionStatus.isGranted;
  }
}
