import 'package:flutter_test/flutter_test.dart'
    show
        TestWidgetsFlutterBinding,
        anything,
        expect,
        setUp,
        setUpAll,
        tearDown,
        test,
        throwsA;
import 'package:magic_record/_features.dart';
import 'package:mockito/annotations.dart' show GenerateNiceMocks, MockSpec;
import 'package:mockito/mockito.dart'
    show anyNamed, reset, verify, verifyNever, when;
import 'package:permission_handler/permission_handler.dart'
    show PermissionStatus;
import 'package:record/record.dart' show RecordPlatform;

import '../helper.dart' show Helper;
import 'audio_recorder_logic_test.mocks.dart' show MockRecord;

@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<RecordPlatform>(as: #MockRecord),
  ],
)
void main() {
  late MockRecord mockRecord;
  late AudioRecorderLogicInterface logic;
  const PermissionRepositoryInterface kRepository = PermissionRepository();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    mockRecord = MockRecord();
    logic = AudioRecorderLogic(
      permissionRepository: kRepository,
      recorder: mockRecord,
    );
  });

  tearDown(() async {
    await logic.onDispose();
    reset(mockRecord);
  });

  test('setup with AudioRecorderState.idle', () {
    expect(logic.stateNotifier.value, const AudioRecorderState.idle());
  });

  test('start call must be a success', () async {
    Helper.permission = PermissionStatus.granted;
    await logic.start();
    expect(logic.stateNotifier.value, const AudioRecorderState.start());
    verify(mockRecord.start(path: anyNamed('path'))).called(1);
  });

  test('start call must be a fail', () async {
    Helper.permission = PermissionStatus.denied;
    expect(() async => logic.start(), throwsA(anything));
    verifyNever(mockRecord.start(path: anyNamed('path')));
  });

  test('stop call must be a success', () async {
    const kFakePath = 'FakePath';
    when(mockRecord.stop()).thenAnswer((_) async => kFakePath);
    final audioPath = await logic.stop();
    expect(audioPath, kFakePath);
    expect(
      logic.stateNotifier.value,
      const AudioRecorderState.stop(audioPath: kFakePath),
    );
    verify(mockRecord.stop()).called(1);
  });
}
