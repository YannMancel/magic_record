import 'package:flutter/services.dart' show MethodChannel;
import 'package:flutter_test/flutter_test.dart'
    show
        TestDefaultBinaryMessengerBinding,
        TestWidgetsFlutterBinding,
        expect,
        isFalse,
        isTrue,
        setUpAll,
        test;
import 'package:magic_record/_features.dart';
import 'package:permission_handler/permission_handler.dart'
    show Permission, PermissionStatus;

void main() {
  const PermissionRepositoryInterface kRepository = PermissionRepository();

  void setupPermission(PermissionStatus permissionStatus) {
    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('flutter.baseflow.com/permissions/methods'),
            (_) async => <int, int>{
                  Permission.microphone.value: permissionStatus.index,
                });
  }

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('Microphone permission granted must return true', () async {
    setupPermission(PermissionStatus.granted);
    final hasRecordPermission = await kRepository.hasMicrophonePermission;
    expect(hasRecordPermission, isTrue);
  });

  test('Microphone permission denied must return false', () async {
    setupPermission(PermissionStatus.denied);
    final hasRecordPermission = await kRepository.hasMicrophonePermission;
    expect(hasRecordPermission, isFalse);
  });

  test('Microphone permission limited must return false', () async {
    setupPermission(PermissionStatus.limited);
    final hasRecordPermission = await kRepository.hasMicrophonePermission;
    expect(hasRecordPermission, isFalse);
  });

  test('Microphone permission permanently denied must return false', () async {
    setupPermission(PermissionStatus.permanentlyDenied);
    final hasRecordPermission = await kRepository.hasMicrophonePermission;
    expect(hasRecordPermission, isFalse);
  });

  test('Microphone permission restricted must return false', () async {
    setupPermission(PermissionStatus.restricted);
    final hasRecordPermission = await kRepository.hasMicrophonePermission;
    expect(hasRecordPermission, isFalse);
  });
}
