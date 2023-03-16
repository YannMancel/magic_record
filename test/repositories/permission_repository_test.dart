import 'package:flutter_test/flutter_test.dart'
    show TestWidgetsFlutterBinding, expect, isFalse, isTrue, setUpAll, test;
import 'package:magic_record/_features.dart';
import 'package:permission_handler/permission_handler.dart'
    show PermissionStatus;

import '../helper.dart' show Helper;

void main() {
  const PermissionRepositoryInterface kRepository = PermissionRepository();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test('Microphone permission granted must return true', () async {
    Helper.permission = PermissionStatus.granted;
    final hasRecordPermission = await kRepository.hasMicrophonePermission;
    expect(hasRecordPermission, isTrue);
  });

  test('Microphone permission denied must return false', () async {
    Helper.permission = PermissionStatus.denied;
    final hasRecordPermission = await kRepository.hasMicrophonePermission;
    expect(hasRecordPermission, isFalse);
  });

  test('Microphone permission limited must return false', () async {
    Helper.permission = PermissionStatus.limited;
    final hasRecordPermission = await kRepository.hasMicrophonePermission;
    expect(hasRecordPermission, isFalse);
  });

  test('Microphone permission permanently denied must return false', () async {
    Helper.permission = PermissionStatus.permanentlyDenied;
    final hasRecordPermission = await kRepository.hasMicrophonePermission;
    expect(hasRecordPermission, isFalse);
  });

  test('Microphone permission restricted must return false', () async {
    Helper.permission = PermissionStatus.restricted;
    final hasRecordPermission = await kRepository.hasMicrophonePermission;
    expect(hasRecordPermission, isFalse);
  });
}
