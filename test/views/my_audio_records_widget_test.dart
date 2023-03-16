import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart'
    show
        anything,
        expect,
        find,
        findsNothing,
        findsOneWidget,
        setUp,
        tearDown,
        testWidgets;
import 'package:magic_record/_features.dart';
import 'package:mockito/mockito.dart' show any, anyNamed, reset, when;
import 'package:provider/provider.dart' show Provider;

import '../repositories/storage_repository_test.mocks.dart'
    show MockHiveBoxOfList, MockHiveInterface;

void main() {
  late MockHiveInterface mockHiveInterface;
  late MockHiveBoxOfList mockHiveBox;
  late StorageRepositoryInterface repository;

  const kAudioRecord = AudioRecord(
    formattedDate: 'fakeDate',
    audioPath: 'FakePath',
  );

  final audioRecordJson = <String, String>{
    MyAudioRecordsLogic.kFormattedDateKey: kAudioRecord.formattedDate,
    MyAudioRecordsLogic.kAudioPathKey: kAudioRecord.audioPath,
  };

  setUp(() {
    mockHiveInterface = MockHiveInterface();
    mockHiveBox = MockHiveBoxOfList();

    when(mockHiveInterface.openBox<List<dynamic>>(any))
        .thenAnswer((_) async => mockHiveBox);

    repository = StorageRepository(hive: mockHiveInterface);
  });

  tearDown(() async {
    await repository.onDispose();
    reset(mockHiveInterface);
    reset(mockHiveBox);
  });

  testWidgets('No audio record', (tester) async {
    final logic = MyAudioRecordsLogic(storageRepository: repository);
    final widget = Provider<MyAudioRecordsLogicInterface>.value(
      value: logic,
      child: const MaterialApp(
        home: MyAudioRecordsWidget(),
      ),
    );
    await tester.pumpWidget(widget);

    expect(find.text('No record'), findsOneWidget);
    expect(find.byType(AudioPlayerCard), findsNothing);
  });

  testWidgets('1 record', (tester) async {
    when(mockHiveBox.get(anything, defaultValue: anyNamed('defaultValue')))
        .thenAnswer((_) => <dynamic>[audioRecordJson]);

    final logic = MyAudioRecordsLogic(storageRepository: repository);
    final widget = Provider<MyAudioRecordsLogicInterface>.value(
      value: logic,
      child: const MaterialApp(
        home: MyAudioRecordsWidget(),
      ),
    );
    await tester.pumpWidget(widget);

    expect(find.text('No record'), findsNothing);
    expect(find.byType(AudioPlayerCard), findsOneWidget);
  });

  testWidgets('Pass to (0 -> 1 -> 0) record', (tester) async {
    final logic = MyAudioRecordsLogic(storageRepository: repository);
    final widget = Provider<MyAudioRecordsLogicInterface>.value(
      value: logic,
      child: const MaterialApp(
        home: MyAudioRecordsWidget(),
      ),
    );
    await tester.pumpWidget(widget);

    expect(find.text('No record'), findsOneWidget);
    expect(find.byType(AudioPlayerCard), findsNothing);

    logic.add(kAudioRecord);
    await tester.pumpAndSettle();

    expect(find.text('No record'), findsNothing);
    expect(find.byType(AudioPlayerCard), findsOneWidget);

    logic.delete(kAudioRecord, needToRemoveFile: false);
    await tester.pumpAndSettle();

    expect(find.text('No record'), findsOneWidget);
    expect(find.byType(AudioPlayerCard), findsNothing);
  });
}
