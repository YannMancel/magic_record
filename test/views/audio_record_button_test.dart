import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart'
    show
        TestWidgetsFlutterBinding,
        expect,
        find,
        findsNothing,
        findsOneWidget,
        setUp,
        setUpAll,
        tearDown,
        testWidgets;
import 'package:magic_record/_features.dart';
import 'package:mockito/mockito.dart' show any, reset, when;
import 'package:permission_handler/permission_handler.dart'
    show PermissionStatus;
import 'package:provider/provider.dart' show MultiProvider, Provider;
import 'package:provider/single_child_widget.dart' show SingleChildWidget;

import '../helper.dart' show Helper;
import '../logics/audio_recorder_logic_test.mocks.dart' show MockRecord;
import '../repositories/storage_repository_test.mocks.dart'
    show MockHiveBoxOfList, MockHiveInterface;

void main() {
  late MockRecord mockRecord;
  late MockHiveInterface mockHiveInterface;
  late MockHiveBoxOfList mockHiveBox;
  late StorageRepositoryInterface storageRepository;
  late AudioRecorderLogicInterface audioRecorderLogic;
  late MyAudioRecordsLogicInterface myAudioRecordsLogic;
  const PermissionRepositoryInterface kPermissionRepository =
      PermissionRepository();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  setUp(() {
    mockRecord = MockRecord();
    mockHiveInterface = MockHiveInterface();
    mockHiveBox = MockHiveBoxOfList();

    when(mockHiveInterface.openBox<List<dynamic>>(any))
        .thenAnswer((_) async => mockHiveBox);

    storageRepository = StorageRepository(hive: mockHiveInterface);
  });

  tearDown(() async {
    await audioRecorderLogic.onDispose();
    await storageRepository.onDispose();
    reset(mockRecord);
    reset(mockHiveInterface);
    reset(mockHiveBox);
  });

  testWidgets('Show mic icon must be a success', (tester) async {
    audioRecorderLogic = AudioRecorderLogic(
      permissionRepository: kPermissionRepository,
      recorder: mockRecord,
    );
    myAudioRecordsLogic = MyAudioRecordsLogic(
      storageRepository: storageRepository,
    );
    final widget = MultiProvider(
      providers: <SingleChildWidget>[
        Provider<AudioRecorderLogicInterface>.value(
          value: audioRecorderLogic,
        ),
        Provider<MyAudioRecordsLogicInterface>.value(
          value: myAudioRecordsLogic,
        ),
      ],
      child: const MaterialApp(
        home: AudioRecorderButton(),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byIcon(Icons.stop), findsNothing);
    expect(find.byIcon(Icons.mic), findsOneWidget);
  });

  testWidgets('Show stop icon must be a success', (tester) async {
    Helper.permission = PermissionStatus.granted;
    audioRecorderLogic = AudioRecorderLogic(
      permissionRepository: kPermissionRepository,
      recorder: mockRecord,
    );
    myAudioRecordsLogic = MyAudioRecordsLogic(
      storageRepository: storageRepository,
    );
    final widget = MultiProvider(
      providers: <SingleChildWidget>[
        Provider<AudioRecorderLogicInterface>.value(
          value: audioRecorderLogic,
        ),
        Provider<MyAudioRecordsLogicInterface>.value(
          value: myAudioRecordsLogic,
        ),
      ],
      child: const MaterialApp(
        home: AudioRecorderButton(),
      ),
    );
    await tester.pumpWidget(widget);
    await tester.tap(find.byType(AudioRecorderButton));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.stop), findsOneWidget);
    expect(find.byIcon(Icons.mic), findsNothing);
  });

  testWidgets('Show stop icon must be a fail', (tester) async {
    Helper.permission = PermissionStatus.denied;
    audioRecorderLogic = AudioRecorderLogic(
      permissionRepository: kPermissionRepository,
      recorder: mockRecord,
    );
    myAudioRecordsLogic = MyAudioRecordsLogic(
      storageRepository: storageRepository,
    );
    final widget = MultiProvider(
      providers: <SingleChildWidget>[
        Provider<AudioRecorderLogicInterface>.value(
          value: audioRecorderLogic,
        ),
        Provider<MyAudioRecordsLogicInterface>.value(
          value: myAudioRecordsLogic,
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(floatingActionButton: AudioRecorderButton()),
      ),
    );
    await tester.pumpWidget(widget);
    await tester.tap(find.byType(AudioRecorderButton));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.stop), findsNothing);
    expect(find.byIcon(Icons.mic), findsOneWidget);
  });
}
