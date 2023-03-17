import 'package:flutter/services.dart' show MethodChannel;
import 'package:flutter_test/flutter_test.dart'
    show TestDefaultBinaryMessengerBinding;
import 'package:magic_record/_features.dart';
import 'package:permission_handler/permission_handler.dart'
    show Permission, PermissionStatus;

abstract class Helper {
  static set permission(PermissionStatus permissionStatus) {
    TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('flutter.baseflow.com/permissions/methods'),
            (_) async => <int, int>{
                  Permission.microphone.value: permissionStatus.index,
                });
  }

  static const kAudioRecord = AudioRecord(
    formattedDate: 'fakeDate',
    audioPath: 'FakePath',
  );

  static Map<String, String> audioRecordJson = <String, String>{
    MyAudioRecordsLogic.kFormattedDateKey: kAudioRecord.formattedDate,
    MyAudioRecordsLogic.kAudioPathKey: kAudioRecord.audioPath,
  };
}
